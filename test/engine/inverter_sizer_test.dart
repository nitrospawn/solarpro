import 'package:flutter_test/flutter_test.dart';
import 'package:solarpro/engine/inverter_sizer.dart';

void main() {
  group('InverterSizer', () {
    late InverterSizer sizer;

    setUp(() {
      sizer = InverterSizer();
    });

    test('should size small system correctly (12V)', () {
      // Example: 500W running, 800W peak surge
      final result = sizer.size(
        peakSurgeWatts: 800,
        continuousRunningWatts: 500,
      );

      // Adjusted peak = 800 * 1.25 = 1000W
      expect(result.adjustedPeakWatts, 1000.0);
      expect(result.recommendedInverterWatts, 1000); // Standard rating
      expect(result.systemVoltage, 12); // Under 1001W continuous
    });

    test('should size medium system correctly (24V)', () {
      // Example: 1500W running, 2100W peak surge
      final result = sizer.size(
        peakSurgeWatts: 2100,
        continuousRunningWatts: 1500,
      );

      // Adjusted peak = 2100 * 1.25 = 2625W -> rounds up to 3000W standard
      expect(result.adjustedPeakWatts, 2625.0);
      expect(result.recommendedInverterWatts, 3000);
      expect(result.systemVoltage, 24); // Between 1001W and 3000W
    });

    test('should size large commercial system correctly (48V)', () {
      // Mirrors PRD Sample Scenario (Section 16.3 & 16.4)
      final result = sizer.size(
        peakSurgeWatts: 4822,
        continuousRunningWatts: 3222,
      );

      // Adjusted peak = 4822 * 1.25 = 6027.5W -> rounds up to 8000W standard
      expect(result.adjustedPeakWatts, 6027.5);
      expect(result.recommendedInverterWatts, 8000);
      expect(result.systemVoltage, 48); // Over 3000W continuous
    });
  });
}