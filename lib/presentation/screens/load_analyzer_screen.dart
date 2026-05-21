import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:solarpro/domain/entities/appliance.dart';
import 'package:solarpro/engine/battery_sizer.dart';
import 'package:solarpro/engine/inverter_sizer.dart';
import 'package:solarpro/engine/load_analyzer.dart';
import 'package:solarpro/engine/solar_sizer.dart';
import 'package:solarpro/presentation/providers/appliance_provider.dart';
import 'package:solarpro/presentation/providers/database_provider.dart';
import 'package:solarpro/presentation/widgets/app_drawer.dart';
import 'package:solarpro/services/pdf/report_generator.dart';

class LoadAnalyzerScreen extends ConsumerStatefulWidget {
  const LoadAnalyzerScreen({super.key});

  @override
  ConsumerState<LoadAnalyzerScreen> createState() => _LoadAnalyzerScreenState();
}

class _LoadAnalyzerScreenState extends ConsumerState<LoadAnalyzerScreen> {
  final LoadAnalyzer _analyzer = LoadAnalyzer();
  final InverterSizer _inverterSizer = InverterSizer();
  final BatterySizer _batterySizer = BatterySizer();
  final SolarSizer _solarSizer = SolarSizer();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _wattsController = TextEditingController();
  final _surgeController = TextEditingController(text: '1.0');
  final _hoursController = TextEditingController(text: '8.0');

  // Common Off-Grid Appliance Presets
  final List<Appliance> _presets = [
    Appliance(id: '', name: 'Pumping machine', category: 'Water', quantity: 1, runningWatts: 750, surgeMultiplier: 2.0, dailyHours: 2, dutyCycle: 1.0),
    Appliance(id: '', name: 'Bulb', category: 'Lighting', quantity: 1, runningWatts: 15, surgeMultiplier: 1.0, dailyHours: 8, dutyCycle: 1.0),
    Appliance(id: '', name: 'Ceiling Fan', category: 'Cooling', quantity: 1, runningWatts: 75, surgeMultiplier: 2.0, dailyHours: 12, dutyCycle: 1.0),
    Appliance(id: '', name: 'Freezer', category: 'Cooling', quantity: 1, runningWatts: 200, surgeMultiplier: 3.5, dailyHours: 24, dutyCycle: 1.0),
    Appliance(id: '', name: 'Fridge', category: 'Cooling', quantity: 1, runningWatts: 150, surgeMultiplier: 3.5, dailyHours: 24, dutyCycle: 0.5), // Fridges generally use a 50% duty cycle
    Appliance(id: '', name: 'TV', category: 'Entertainment', quantity: 1, runningWatts: 50, surgeMultiplier: 1.0, dailyHours: 5, dutyCycle: 1.0),
  ];

  void _addAppliance() {
    if (_formKey.currentState!.validate()) {
      final appliance = Appliance(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        category: 'custom',
        quantity: int.parse(_qtyController.text),
        runningWatts: double.parse(_wattsController.text),
        surgeMultiplier: double.parse(_surgeController.text),
        dailyHours: double.parse(_hoursController.text),
        dutyCycle: 1.0,
      );

      ref.read(applianceListProvider.notifier).addAppliance(appliance);

      // Clear inputs for the next appliance
      _nameController.clear();
      _wattsController.clear();
    }
  }

  void _removeAppliance(int index) {
    ref.read(applianceListProvider.notifier).removeAppliance(index);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _wattsController.dispose();
    _surgeController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _saveProject(List<Appliance> appliances, String? activeProjectId, String? activeProjectName) async {
    if (appliances.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add appliances first.')),
      );
      return;
    }

    final repo = ref.read(databaseRepositoryProvider);

    if (activeProjectId != null) {
      await repo.updateProjectAppliances(activeProjectId, appliances);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Project "$activeProjectName" updated successfully!')));
      }
      return;
    }

    final projectNameController = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Project'),
        content: TextField(
          controller: projectNameController,
          decoration: const InputDecoration(hintText: 'Enter project name (e.g. John Doe Home)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (confirm == true && projectNameController.text.isNotEmpty) {
      final projectId = await repo.createProject(projectNameController.text);
      for (final app in appliances) {
        await repo.addApplianceToProject(projectId, app);
      }
      ref.read(activeProjectIdProvider.notifier).state = projectId;
      ref.read(activeProjectNameProvider.notifier).state = projectNameController.text;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Project "${projectNameController.text}" saved successfully!')));
      }
    }
  }

  Future<void> _printReport(LoadAnalysisResult result, String? activeProjectName) async {
    final appliances = ref.read(applianceListProvider);
    
    if (appliances.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add appliances first to generate a report.')));
      return;
    }

    // Compute the sizing requirements in the background specifically for the PDF report
    final invResult = _inverterSizer.size(peakSurgeWatts: result.peakSurgeWatts, continuousRunningWatts: result.totalRunningWatts);
    final batResult = _batterySizer.size(dailyEnergyWh: result.dailyEnergyWh, systemVoltage: invResult.systemVoltage);
    final solResult = _solarSizer.size(dailyEnergyWh: result.dailyEnergyWh, systemVoltage: invResult.systemVoltage);

    await Printing.layoutPdf(
      onLayout: (format) async => await ReportGenerator.generateProposal(
        projectName: activeProjectName ?? 'Current Draft Project',
        appliances: appliances, loadResult: result, invResult: invResult, batResult: batResult, solResult: solResult,
      ),
      name: 'SolarPro_Proposal.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider! Anytime the list changes, this build method automatically reruns.
    final _appliances = ref.watch(applianceListProvider);
    final activeProjectId = ref.watch(activeProjectIdProvider);
    final activeProjectName = ref.watch(activeProjectNameProvider);
    
    // Run our pure calculation engine on the current list of appliances
    final result = _analyzer.analyze(_appliances);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(activeProjectName != null ? 'Project: $activeProjectName' : 'Load Analyzer Engine'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear All Appliances',
            onPressed: () {
              ref.read(applianceListProvider.notifier).clear();
              ref.read(activeProjectIdProvider.notifier).state = null;
              ref.read(activeProjectNameProvider.notifier).state = null;
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Generate PDF Proposal',
            onPressed: () => _printReport(result, activeProjectName),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Project',
            onPressed: () => _saveProject(_appliances, activeProjectId, activeProjectName),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Real-time Results Dashboard
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Daily Energy',
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.eco, color: Theme.of(context).colorScheme.secondary),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${result.dailyEnergyKwh.toStringAsFixed(2)} kWh',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Running Load', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8), fontSize: 14)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.bolt, color: Theme.of(context).colorScheme.secondary, size: 20),
                                const SizedBox(width: 4),
                                Text('${result.totalRunningWatts.toStringAsFixed(0)} W', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        Container(width: 1, height: 40, color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Peak Surge Load', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8), fontSize: 14)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.offline_bolt, color: Theme.of(context).colorScheme.secondary, size: 20),
                                const SizedBox(width: 4),
                                Text('${result.peakSurgeWatts.toStringAsFixed(0)} W', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 2. Input Form Card
          SliverToBoxAdapter(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Load', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Appliance>(
                        decoration: const InputDecoration(labelText: 'Quick Select Preset', prefixIcon: Icon(Icons.flash_on)),
                        items: _presets.map((preset) {
                          return DropdownMenuItem(
                             value: preset,
                            child: Text(preset.name),
                          );
                        }).toList(),
                        onChanged: (Appliance? preset) {
                          if (preset != null) {
                            _nameController.text = preset.name;
                            _wattsController.text = preset.runningWatts.toStringAsFixed(0);
                            _surgeController.text = preset.surgeMultiplier.toString();
                            _hoursController.text = preset.dailyHours.toString();
                            _qtyController.text = '1';
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Appliance Name (e.g., Fridge)'),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _qtyController,
                              decoration: const InputDecoration(labelText: 'Quantity'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _wattsController,
                              decoration: const InputDecoration(labelText: 'Watts (W)'),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _surgeController,
                              decoration: const InputDecoration(labelText: 'Surge (x)'),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _hoursController,
                              decoration: const InputDecoration(labelText: 'Hours (h)'),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: _addAppliance,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Appliance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Appliance List Header
          if (_appliances.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Text('Active Appliances', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            
          // 4. Scrollable Appliance List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final app = _appliances[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(Icons.electrical_services, color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                      title: Text('${app.quantity}x ${app.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${app.runningWatts}W | ${app.dailyHours}h/day | Surge: ${app.surgeMultiplier}x'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeAppliance(index),
                      ),
                    ),
                  );
                },
                childCount: _appliances.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)), // Bottom padding

          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}