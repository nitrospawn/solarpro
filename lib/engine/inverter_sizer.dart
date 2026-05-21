class InverterSizingResult {
  final double adjustedPeakWatts;
  final int recommendedInverterWatts;
  final int systemVoltage;
  final bool requiresPureSineWave;

  InverterSizingResult({
    required this.adjustedPeakWatts,
    required this.recommendedInverterWatts,
    required this.systemVoltage,
    required this.requiresPureSineWave,
  });
}

class InverterSizer {
  // Standard inverter ratings in Watts (from PRD Section 4.3)
  static const List<int> _standardRatings = [
    500, 1000, 1500, 2000, 2500, 3000, 5000, 6000, 8000, 10000, 15000, 20000
  ];

  /// Sizes the inverter based on peak surge and continuous load.
  InverterSizingResult size({
    required double peakSurgeWatts,
    required double continuousRunningWatts,
    double safetyMargin = 0.25, // 25% default margin
  }) {
    // 1. Calculate adjusted peak with safety headroom
    final double adjustedPeak = peakSurgeWatts * (1 + safetyMargin);

    // 2. Round up to the nearest standard inverter rating
    int recommendedW = _standardRatings.last; // Fallback to largest if it exceeds our list
    for (final rating in _standardRatings) {
      if (rating >= adjustedPeak) {
        recommendedW = rating;
        break;
      }
    }

    // 3. Determine DC System Voltage based on continuous running load
    int voltage = 12;
    if (continuousRunningWatts > 3000) {
      voltage = 48;
    } else if (continuousRunningWatts > 1000) {
      voltage = 24;
    }

    return InverterSizingResult(
      adjustedPeakWatts: adjustedPeak,
      recommendedInverterWatts: recommendedW,
      systemVoltage: voltage,
      // PRD states Pure Sine Wave is always recommended for off-grid professional installs
      requiresPureSineWave: true, 
    );
  }
}