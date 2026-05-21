class SolarSizingResult {
  final double requiredArrayWattage;
  final int numberOfPanels;
  final double requiredChargeControllerAmps;
  final int recommendedChargeControllerAmps;

  SolarSizingResult({
    required this.requiredArrayWattage,
    required this.numberOfPanels,
    required this.requiredChargeControllerAmps,
    required this.recommendedChargeControllerAmps,
  });
}

class SolarSizer {
  // Standard Charge Controller ratings in Amps
  static const List<int> _standardCcRatings = [10, 20, 30, 40, 50, 60, 80, 100, 120];

  /// Sizes the solar array and charge controller based on daily energy needs.
  SolarSizingResult size({
    required double dailyEnergyWh,
    required int systemVoltage,
    double peakSunHours = 4.5,
    double systemEfficiency = 0.80, // 80% to account for real-world losses (dust, heat, wire)
    int panelWattage = 400, // Standard modern panel size
    double safetyMarginCc = 1.25, // 25% safety margin for charge controller (NEC standard)
  }) {
    // 1. Calculate required solar array wattage
    final requiredArrayWattage = dailyEnergyWh / (peakSunHours * systemEfficiency);

    // 2. Calculate number of panels needed (always round up)
    final numberOfPanels = (requiredArrayWattage / panelWattage).ceil();

    // 3. Calculate actual installed array wattage
    final installedArrayWattage = numberOfPanels * panelWattage;

    // 4. Calculate Charge Controller size in Amps based on installed array
    final requiredCcAmps = (installedArrayWattage / systemVoltage) * safetyMarginCc;

    // 5. Find nearest standard Charge Controller size
    int recommendedCcAmps = _standardCcRatings.last; // Fallback to largest
    for (final rating in _standardCcRatings) {
      if (rating >= requiredCcAmps) {
        recommendedCcAmps = rating;
        break;
      }
    }

    return SolarSizingResult(
      requiredArrayWattage: requiredArrayWattage,
      numberOfPanels: numberOfPanels,
      requiredChargeControllerAmps: requiredCcAmps,
      recommendedChargeControllerAmps: recommendedCcAmps,
    );
  }
}