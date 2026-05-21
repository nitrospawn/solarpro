import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:solarpro/data/datasources/local/app_database.dart';
import 'package:solarpro/data/repositories/database_repository.dart';
import 'package:solarpro/domain/entities/appliance.dart';

void main() {
  group('DatabaseRepository', () {
    late AppDatabase db;
    late DatabaseRepository repository;

    setUp(() {
      // Use an ultra-fast, temporary in-memory database for testing
      db = AppDatabase(e: NativeDatabase.memory());
      repository = DatabaseRepository(db);
    });

    tearDown(() async {
      // Clean up the database connection after every test
      await db.close();
    });

    test('should create a project and return its ID', () async {
      final id = await repository.createProject('Test Project', clientName: 'John Doe');
      expect(id, isNotEmpty);
    });

    test('should add an appliance and fetch it successfully', () async {
      final projectId = await repository.createProject('Solar Home');
      
      final appliance = Appliance(
        id: 'app-1',
        name: 'Ceiling Fan',
        category: 'Cooling',
        quantity: 2,
        runningWatts: 75,
        surgeMultiplier: 2.0,
        dailyHours: 12,
      );

      await repository.addApplianceToProject(projectId, appliance);
      
      final appliances = await repository.getAppliancesForProject(projectId);
      
      expect(appliances.length, 1);
      expect(appliances.first.name, 'Ceiling Fan');
      expect(appliances.first.totalRunningWatts, 150.0); // 75W * 2 qty
    });

    test('should delete an appliance successfully', () async {
      final projectId = await repository.createProject('Solar Home');
      final appliance = Appliance(
        id: 'app-2', name: 'TV', category: 'Entertainment', quantity: 1, 
        runningWatts: 100, surgeMultiplier: 1.0, dailyHours: 5,
      );

      await repository.addApplianceToProject(projectId, appliance);
      await repository.deleteAppliance('app-2');
      
      final appliances = await repository.getAppliancesForProject(projectId);
      expect(appliances, isEmpty);
    });
  });
}