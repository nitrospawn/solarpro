import 'package:flutter_test/flutter_test.dart';
import 'package:solarpro/engine/solar_sizer.dart';

void main() {
  group('SolarSizer', () {
    late SolarSizer sizer;

    setUp(() {
      sizer = SolarSizer();
    });

    test('should size solar array and charge controller correctly', () {
      // Example: 6000 Wh daily energy demand, 24V system, 5 peak sun hours, 400W panels
      final result = sizer.size(
        dailyEnergyWh: 6000,
        systemVoltage: 24,
        peakSunHours: 5.0,
        systemEfficiency: 0.8,
        panelWattage: 400,
      );

      // Required Array = 6000Wh / (5 hours * 0.8 efficiency) = 1500W
      expect(result.requiredArrayWattage, 1500.0);

      // Panels = 1500W / 400W = 3.75 -> rounds up to 4 panels
      expect(result.numberOfPanels, 4);

      // Installed Array W = 4 * 400W = 1600W
      // Required CC Amps = (1600W / 24V) * 1.25 safety factor = 83.33A
      expect(result.requiredChargeControllerAmps, closeTo(83.33, 0.01));

      // Recommended standard CC = 100A (since 83.33A > 80A standard size)
      expect(result.recommendedChargeControllerAmps, 100);
    });
  });
}