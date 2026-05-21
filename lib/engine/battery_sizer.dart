class BatterySizingResult {
  final double requiredTotalEnergyWh;
  final double requiredCapacityAh;
  final int batteriesInSeries;
  final int stringsInParallel;
  final int totalBatteries;

  BatterySizingResult({
    required this.requiredTotalEnergyWh,
    required this.requiredCapacityAh,
    required this.batteriesInSeries,
    required this.stringsInParallel,
    required this.totalBatteries,
  });
}

class BatterySizer {
  /// Sizes the battery bank to meet daily energy needs.
  /// [batteryVoltage] is typically 12V for standard individual batteries.
  /// [batteryCapacityAh] is typically 100Ah or 200Ah per physical battery.
  BatterySizingResult size({
    required double dailyEnergyWh,
    required int systemVoltage,
    double daysOfAutonomy = 1.0,
    double depthOfDischarge = 0.5, // 50% default for Lead-Acid/Gel/AGM
    double systemEfficiency = 0.95, // Accounts for inverter and wiring losses
    int batteryVoltage = 12,
    int batteryCapacityAh = 200,
  }) {
    // 1. Calculate total gross energy needed considering DoD and efficiency
    final requiredTotalEnergyWh = (dailyEnergyWh * daysOfAutonomy) / (depthOfDischarge * systemEfficiency);

    // 2. Calculate required Ah at the chosen DC system voltage
    final requiredCapacityAh = requiredTotalEnergyWh / systemVoltage;

    // 3. Calculate physical battery layout (Series/Parallel)
    final batteriesInSeries = (systemVoltage / batteryVoltage).ceil();
    final stringsInParallel = (requiredCapacityAh / batteryCapacityAh).ceil();
    final totalBatteries = batteriesInSeries * stringsInParallel;

    return BatterySizingResult(
      requiredTotalEnergyWh: requiredTotalEnergyWh,
      requiredCapacityAh: requiredCapacityAh,
      batteriesInSeries: batteriesInSeries,
      stringsInParallel: stringsInParallel,
      totalBatteries: totalBatteries,
    );
  }
}