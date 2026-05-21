import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarpro/presentation/widgets/app_drawer.dart';

class SolarCalculationScreen extends StatefulWidget {
  const SolarCalculationScreen({super.key});

  @override
  State<SolarCalculationScreen> createState() => _SolarCalculationScreenState();
}

class _SolarCalculationScreenState extends State<SolarCalculationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _panelPmaxController = TextEditingController();
  final _panelVmpController = TextEditingController();
  final _inverterVoltageController = TextEditingController();
  final _batteryAhController = TextEditingController();
  final _totalBatteriesController = TextEditingController();
  final _activeLoadAmpsController = TextEditingController();

  bool _includeActiveLoad = false;

  // Output State
  String? _systemGoal;
  double? _totalCurrentRequiredAmps;
  double? _exactPanelsRequired;
  int? _totalPanelsNeeded;
  String? _recommendedArrayWiring;
  double? _minMpptAmps;
  double? _recMpptAmps;
  String? _wiringExplanation;

  @override
  void dispose() {
    _panelPmaxController.dispose();
    _panelVmpController.dispose();
    _inverterVoltageController.dispose();
    _batteryAhController.dispose();
    _totalBatteriesController.dispose();
    _activeLoadAmpsController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final pmaxW = double.tryParse(_panelPmaxController.text) ?? 0;
    final vmpV = double.tryParse(_panelVmpController.text) ?? 0;
    final invSystemDCV = double.tryParse(_inverterVoltageController.text) ?? 0;
    final singleBattAh = double.tryParse(_batteryAhController.text) ?? 0;
    final totalBatt = int.tryParse(_totalBatteriesController.text) ?? 0;
    
    double activeLoadAmps = 0;
    if (_includeActiveLoad) {
      activeLoadAmps = double.tryParse(_activeLoadAmpsController.text) ?? 0;
    }

    if (pmaxW <= 0 || vmpV <= 0 || invSystemDCV <= 0 || singleBattAh <= 0 || totalBatt <= 0) return;

    // 1. Battery Setup Deductions (Assumes 12V single battery blocks)
    const double singleBatteryVolts = 12.0;
    final int seriesStrings = (invSystemDCV / singleBatteryVolts).toInt();
    if (seriesStrings <= 0) return; // Prevent division by zero
    
    final double parallelStrings = totalBatt / seriesStrings;
    final double totalBankAh = singleBattAh * parallelStrings;
    final double baselineChargingCurrent = totalBankAh * 0.10; // 10% rule

    // 2. Target Voltage & Panel Output
    final double targetSystemChargingVoltage = invSystemDCV * 1.2;
    final double ampsFromSinglePanel = pmaxW / targetSystemChargingVoltage;

    // 3. Conditional Target Current Logic
    final double totalTargetCurrent = _includeActiveLoad 
        ? activeLoadAmps + baselineChargingCurrent 
        : baselineChargingCurrent;

    // 4. Rounding Rule for Panels
    final double exactPanels = totalTargetCurrent / ampsFromSinglePanel;
    int totalPanelsRoundedUp = exactPanels.ceil();

    // Array Wiring Calculation (Series panels needed to overcome target voltage)
    int panelSeriesCount = (targetSystemChargingVoltage / vmpV).ceil();
    if (panelSeriesCount < 1) panelSeriesCount = 1;
    
    // Ensure total panels forms a balanced array string
    int panelParallelCount = (totalPanelsRoundedUp / panelSeriesCount).ceil();
    totalPanelsRoundedUp = panelSeriesCount * panelParallelCount;

    final String arrayWiring = '${panelSeriesCount}S${panelParallelCount}P';

    // 5. MPPT Controller Sizing Logic
    final double minMppt = totalTargetCurrent;
    final double rawRecMppt = totalTargetCurrent * 1.25;
    
    // Standardize to market sizes
    final List<double> standardMpptSizes = [20, 30, 40, 50, 60, 80, 100];
    double recommendedMppt = rawRecMppt;
    for (final size in standardMpptSizes) {
      if (size >= rawRecMppt) {
        recommendedMppt = size;
        break;
      }
    }

    setState(() {
      _systemGoal = _includeActiveLoad 
          ? "Charge battery bank AND support active daytime load simultaneously."
          : "Charge battery bank only (no active daytime load).";
      _totalCurrentRequiredAmps = totalTargetCurrent;
      _exactPanelsRequired = exactPanels;
      _totalPanelsNeeded = totalPanelsRoundedUp;
      _recommendedArrayWiring = arrayWiring;
      _minMpptAmps = minMppt;
      _recMpptAmps = recommendedMppt;
      _wiringExplanation = "Wired with $panelSeriesCount panels in series to step up voltage over the ${targetSystemChargingVoltage.toStringAsFixed(1)}V charging threshold, and $panelParallelCount strings in parallel to meet the ${(totalTargetCurrent).toStringAsFixed(1)}A current demand.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Form Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Solar & Battery Specs', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildTextField(_panelPmaxController, 'Panel Rating (Pmax)'),
                      const SizedBox(height: 12),
                      _buildTextField(_panelVmpController, 'Panel Vmp (V)'),
                      const SizedBox(height: 12),
                      _buildTextField(_inverterVoltageController, 'System DC Volts (V)'),
                      const SizedBox(height: 12),
                      _buildTextField(_totalBatteriesController, 'Total Batteries', isInteger: true),
                      const SizedBox(height: 12),
                      _buildTextField(_batteryAhController, 'Single Battery Cap. (Ah)'),
                      const SizedBox(height: 16),
                      
                      // Active Load Toggle
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SwitchListTile(
                          title: const Text('Include Active Daytime Load', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Factor in continuous DC current drawn while charging.'),
                          value: _includeActiveLoad,
                          onChanged: (val) {
                            setState(() => _includeActiveLoad = val);
                            if (!val) _activeLoadAmpsController.clear();
                          },
                        ),
                      ),
                      
                      if (_includeActiveLoad) ...[
                        const SizedBox(height: 12),
                        _buildTextField(_activeLoadAmpsController, 'Actual Load Current (Amps DC)'),
                      ],

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: _calculate,
                          icon: const Icon(Icons.solar_power),
                          label: const Text('Calculate Array', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Results Output Card
            if (_systemGoal != null)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Solar Analysis Results', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      
                      Text('System Goal:', style: Theme.of(context).textTheme.bodySmall),
                      Text(_systemGoal!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const Divider(height: 24),

                      _buildResultRow('Total Target Current', '${_totalCurrentRequiredAmps!.toStringAsFixed(1)} A', Icons.bolt),
                      _buildResultRow('Exact Panels Computed', _exactPanelsRequired!.toStringAsFixed(2), Icons.calculate),
                      _buildResultRow('Total Panels Required', '$_totalPanelsNeeded', Icons.grid_view),
                      _buildResultRow('Recommended Wiring', _recommendedArrayWiring!, Icons.cable),
                      
                      const Divider(height: 24),
                      Text('Charge Controller (MPPT)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                      const SizedBox(height: 8),
                      _buildResultRow('Minimum Rating', '${_minMpptAmps!.toStringAsFixed(1)} A', Icons.arrow_downward),
                      _buildResultRow('Recommended Rating', '${_recMpptAmps!.toStringAsFixed(0)} A', Icons.check_circle),
                      const SizedBox(height: 4),
                      const Text('Includes 25% safety margin for continuous current protection.', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),

                      const Divider(height: 24),
                      Text('Engineering Notes:', style: Theme.of(context).textTheme.bodySmall),
                      Text(_wiringExplanation!, style: const TextStyle(fontSize: 14, height: 1.4)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isInteger = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isInteger ? TextInputType.number : const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        isInteger 
            ? FilteringTextInputFormatter.digitsOnly 
            : FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
      ],
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 15)),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}