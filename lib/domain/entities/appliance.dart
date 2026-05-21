class Appliance {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final double runningWatts;
  final double surgeMultiplier;
  final double dailyHours;
  final double dutyCycle;

  Appliance({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.runningWatts,
    required this.surgeMultiplier,
    required this.dailyHours,
    this.dutyCycle = 1.0,
  });

  // Formula calculations based on PRD Section 4.2
  double get totalRunningWatts => runningWatts * quantity;
  
  double get totalSurgeWatts => runningWatts * surgeMultiplier * quantity;
  
  double get dailyEnergyWh => runningWatts * quantity * dailyHours * dutyCycle;

  double get maxIncrementalSurge => (runningWatts * surgeMultiplier) - runningWatts;
}