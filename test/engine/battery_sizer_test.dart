import 'package:flutter_test/flutter_test.dart';
import 'package:solarpro/engine/battery_sizer.dart';

void main() {
  group('BatterySizer', () {
    late BatterySizer sizer;

    setUp(() {
      sizer = BatterySizer();
    });

    test('should size a 24V system correctly with 50% DoD', () {
      // Example: 3000 Wh daily energy demand
      final result = sizer.size(
        dailyEnergyWh: 3000,
        systemVoltage: 24,
        daysOfAutonomy: 1.0,
        depthOfDischarge: 0.5,
        systemEfficiency: 1.0, // Set to 100% for straightforward test math
        batteryVoltage: 12,
        batteryCapacityAh: 200,
      );

      // Total energy needed = 3000Wh / 0.5 = 6000Wh
      expect(result.requiredTotalEnergyWh, 6000.0);
      
      // Required Ah at 24V = 6000Wh / 24V = 250Ah
      expect(result.requiredCapacityAh, 250.0);

      // Series = 24V / 12V = 2 batteries in series
      expect(result.batteriesInSeries, 2);

      // Parallel strings = 250Ah required / 200Ah per battery = 1.25 -> rounded up to 2 strings
      expect(result.stringsInParallel, 2);

      // Total batteries = 2 (series) * 2 (parallel) = 4
      expect(result.totalBatteries, 4);
    });
  });
}