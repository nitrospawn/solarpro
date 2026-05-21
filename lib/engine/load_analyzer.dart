import '../domain/entities/appliance.dart'; // Adjust import path if needed based on your exact structure

class LoadAnalysisResult {
  final double totalRunningWatts;
  final double peakSurgeWatts;
  final double dailyEnergyWh;

  LoadAnalysisResult({
    required this.totalRunningWatts,
    required this.peakSurgeWatts,
    required this.dailyEnergyWh,
  });

  // Convenience getter for kWh
  double get dailyEnergyKwh => dailyEnergyWh / 1000.0;
}

class LoadAnalyzer {
  /// Analyzes a list of appliances and calculates total running watts,
  /// peak surge watts, and daily energy consumption.
  /// 
  /// Uses the conservative surge policy (PRD Section 4.2):
  /// Assumes all appliances are running, and only the single largest 
  /// motor surge is added on top of the total running load.
  LoadAnalysisResult analyze(List<Appliance> appliances) {
    double totalRunning = 0.0;
    double dailyEnergy = 0.0;
    double maxIncrementalSurge = 0.0;

    for (final appliance in appliances) {
      totalRunning += appliance.totalRunningWatts;
      dailyEnergy += appliance.dailyEnergyWh;
      
      if (appliance.maxIncrementalSurge > maxIncrementalSurge) {
        maxIncrementalSurge = appliance.maxIncrementalSurge;
      }
    }

    return LoadAnalysisResult(
      totalRunningWatts: totalRunning,
      peakSurgeWatts: totalRunning + maxIncrementalSurge,
      dailyEnergyWh: dailyEnergy,
    );
  }
}