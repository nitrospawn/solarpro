import 'package:flutter_test/flutter_test.dart';
import 'package:solarpro/domain/entities/appliance.dart';
import 'package:solarpro/engine/load_analyzer.dart';

void main() {
  group('LoadAnalyzer', () {
    late LoadAnalyzer analyzer;

    setUp(() {
      analyzer = LoadAnalyzer();
    });

    test('should return zeros for an empty appliance list', () {
      final result = analyzer.analyze([]);

      expect(result.totalRunningWatts, 0.0);
      expect(result.peakSurgeWatts, 0.0);
      expect(result.dailyEnergyWh, 0.0);
      expect(result.dailyEnergyKwh, 0.0);
    });

    test('should correctly calculate metrics for a single appliance', () {
      final appliance = Appliance(
        id: '1',
        name: 'Ceiling Fan',
        category: 'cooling',
        quantity: 2,
        runningWatts: 75,
        surgeMultiplier: 2.0, // Incremental surge = (75 * 2) - 75 = 75W per appliance
        dailyHours: 12,
      );

      final result = analyzer.analyze([appliance]);

      // Total Running: 75W * 2 qty = 150W
      expect(result.totalRunningWatts, 150.0);

      // Peak Surge: 150W (running) + 75W (incremental surge of one motor) = 225W
      expect(result.peakSurgeWatts, 225.0);

      // Daily Energy: 75W * 2 qty * 12 hours = 1800Wh
      expect(result.dailyEnergyWh, 1800.0);
      expect(result.dailyEnergyKwh, 1.8);
    });

    test('should apply conservative surge policy by taking highest incremental surge', () {
      final appliances = [
        Appliance(
          id: '1',
          name: 'Vaccine Fridge',
          category: 'cooling',
          quantity: 1,
          runningWatts: 150,
          surgeMultiplier: 3.5, // Incremental = (150 * 3.5) - 150 = 375W
          dailyHours: 24,
          dutyCycle: 0.5,
        ),
        Appliance(
          id: '2',
          name: 'Water Pump',
          category: 'water',
          quantity: 1,
          runningWatts: 500,
          surgeMultiplier: 2.0, // Incremental = (500 * 2.0) - 500 = 500W (Highest)
          dailyHours: 2,
        ),
      ];

      final result = analyzer.analyze(appliances);

      // Total Running: 150W + 500W = 650W
      expect(result.totalRunningWatts, 650.0);

      // Peak Surge: 650W + 500W (Pump's incremental surge is higher than Fridge's 375W) = 1150W
      expect(result.peakSurgeWatts, 1150.0);

      // Daily Energy: (150W * 24h * 0.5) + (500W * 2h) = 1800Wh + 1000Wh = 2800Wh
      expect(result.dailyEnergyWh, 2800.0);
    });
  });
}