import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarpro/presentation/widgets/app_drawer.dart';

class InverterCalculationScreen extends StatefulWidget {
  const InverterCalculationScreen({super.key});

  @override
  State<InverterCalculationScreen> createState() => _InverterCalculationScreenState();
}

class _InverterCalculationScreenState extends State<InverterCalculationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _inverterCapacityController = TextEditingController();
  final _inverterVoltageController = TextEditingController();
  final _batteryCapacityController = TextEditingController();
  final _batteryVoltageController = TextEditingController();
  final _totalBatteriesController = TextEditingController();
  final _connectedLoadController = TextEditingController();

  String _batteryType = 'AGM';
  final List<String> _batteryTypes = ['AGM', 'GEL', 'Flooded', 'Lithium'];

  // Results
  String? _wiringConfig;
  double? _bankTotalAh;
  double? _rawKwh;
  double? _usableKwh;
  double? _fullLoadAmps;
  double? _actualLoadAmps;
  double? _runtimeHours;
  double? _minChargeCurrent;
  double? _maxChargeCurrent;

  @override
  void dispose() {
    _inverterCapacityController.dispose();
    _inverterVoltageController.dispose();
    _batteryCapacityController.dispose();
    _batteryVoltageController.dispose();
    _totalBatteriesController.dispose();
    _connectedLoadController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final invCapacity = double.tryParse(_inverterCapacityController.text) ?? 0;
    final invVoltage = double.tryParse(_inverterVoltageController.text) ?? 0;
    final batCapacity = double.tryParse(_batteryCapacityController.text) ?? 0;
    final batVoltage = double.tryParse(_batteryVoltageController.text) ?? 0;
    final totalBatteries = int.tryParse(_totalBatteriesController.text) ?? 0;
    final load = double.tryParse(_connectedLoadController.text) ?? 0;

    if (invVoltage <= 0 || batVoltage <= 0 || totalBatteries <= 0) return;

    // Depth of Discharge (DoD) & Inverter Efficiency Rules
    double dod = 0.50;
    double eff = 0.85;
    if (_batteryType == 'AGM' || _batteryType == 'GEL') {
      dod = 0.50;
      eff = 0.85;
    } else if (_batteryType == 'Flooded') {
      dod = 0.50;
      eff = 0.80;
    } else if (_batteryType == 'Lithium') {
      dod = 0.80;
      eff = 0.95;
    }

    // Wiring Configuration
    final series = invVoltage / batVoltage;
    if (series <= 0) return;
    final parallel = totalBatteries / series;

    // Battery Bank Total Ah
    final bankAh = batCapacity * parallel;
    
    // Total Energy (Raw vs. Usable)
    final rawKwh = (totalBatteries * batCapacity * batVoltage) / 1000.0;
    final usableKwh = rawKwh * dod;

    // DC Current Drawn (Amps)
    final fullLoadAmps = invCapacity / (invVoltage * eff);
    
    double actualLoadAmps = 0;
    if (eff > 0) {
      actualLoadAmps = load / (invVoltage * eff);
    }

    // Runtime (Hours)
    double runtime = 0;
    if (actualLoadAmps > 0) {
      runtime = (bankAh * dod) / actualLoadAmps;
    }

    // Recommended Charging Current
    final minCharge = bankAh * 0.10;
    final maxCharge = bankAh * (_batteryType == 'Lithium' ? 0.50 : 0.20);

    setState(() {
      _wiringConfig = '${series.toInt()}S${parallel.toInt()}P';
      _bankTotalAh = bankAh;
      _rawKwh = rawKwh;
      _usableKwh = usableKwh;
      _fullLoadAmps = fullLoadAmps;
      _actualLoadAmps = actualLoadAmps;
      _runtimeHours = runtime;
      _minChargeCurrent = minCharge;
      _maxChargeCurrent = maxCharge;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inverter Calculator'),
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
                      Text('System Parameters', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildTextField(_inverterCapacityController, 'Inverter Capacity (VA)'),
                      const SizedBox(height: 12),
                      _buildTextField(_inverterVoltageController, 'Inverter DC Volts (V)'),
                      const SizedBox(height: 12),
                      _buildTextField(_batteryCapacityController, 'Single Battery Cap. (Ah)'),
                      const SizedBox(height: 12),
                      _buildTextField(_batteryVoltageController, 'Single Battery DC Volts (V)'),
                      const SizedBox(height: 12),
                      _buildTextField(_totalBatteriesController, 'Total Batteries', isInteger: true),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _batteryType,
                        decoration: const InputDecoration(labelText: 'Battery Type'),
                        items: _batteryTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                        onChanged: (val) => setState(() => _batteryType = val!),
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(_connectedLoadController, 'Connected Load (Watts)'),
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
                          icon: const Icon(Icons.calculate),
                          label: const Text('Calculate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Results Dashboard Card
            if (_wiringConfig != null)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calculation Results', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildResultRow('Wiring Configuration', _wiringConfig!, Icons.cable),
                      _buildResultRow('Battery Bank Total', '${_bankTotalAh!.toStringAsFixed(0)} Ah', Icons.battery_charging_full),
                      const Divider(),
                      _buildResultRow('Total Energy (Raw)', '${_rawKwh!.toStringAsFixed(2)} kWh', Icons.flash_on),
                      _buildResultRow('Usable Energy', '${_usableKwh!.toStringAsFixed(2)} kWh', Icons.eco),
                      const Divider(),
                      _buildResultRow('Full Load Current', '${_fullLoadAmps!.toStringAsFixed(1)} Amps', Icons.bolt),
                      _buildResultRow('Actual Load Current', '${_actualLoadAmps!.toStringAsFixed(1)} Amps', Icons.electric_meter),
                      const Divider(),
                      _buildResultRow('Estimated Runtime', '${_runtimeHours!.toStringAsFixed(1)} Hours', Icons.timer),
                      _buildResultRow('Recommended Charge', '${_minChargeCurrent!.toStringAsFixed(1)}A - ${_maxChargeCurrent!.toStringAsFixed(1)}A', Icons.power),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
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
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}