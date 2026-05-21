import 'package:drift/drift.dart';
import 'package:solarpro/data/datasources/local/app_database.dart';
import 'package:solarpro/domain/entities/appliance.dart';

class DatabaseRepository {
  final AppDatabase _db;

  DatabaseRepository(this._db);

  // ==========================================
  // PROJECTS
  // ==========================================
  
  /// Creates a new project and returns its unique ID
  Future<String> createProject(String name, {String? clientName}) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    await _db.into(_db.projects).insert(
      ProjectsCompanion.insert(
        id: id,
        name: name,
        clientName: Value(clientName),
      ),
    );
    
    return id;
  }

  /// Fetches all saved projects
  Future<List<Project>> getAllProjects() async {
    return await _db.select(_db.projects).get();
  }

  /// Deletes a project and its associated appliances
  Future<void> deleteProject(String id) async {
    // Delete appliances first to maintain relational integrity
    await (_db.delete(_db.appliancesTable)..where((t) => t.projectId.equals(id))).go();
    // Delete the project itself
    await (_db.delete(_db.projects)..where((t) => t.id.equals(id))).go();
  }

  /// Updates an existing project by replacing all its appliances
  Future<void> updateProjectAppliances(String projectId, List<Appliance> appliances) async {
    // Remove old appliances
    await (_db.delete(_db.appliancesTable)..where((t) => t.projectId.equals(projectId))).go();
    
    // Insert the new updated list
    for (final app in appliances) {
      await addApplianceToProject(projectId, app);
    }
  }

  // ==========================================
  // APPLIANCES
  // ==========================================
  
  /// Saves a domain Appliance into the Drift SQLite database
  Future<void> addApplianceToProject(String projectId, Appliance appliance) async {
    await _db.into(_db.appliancesTable).insert(
      AppliancesTableCompanion.insert(
        id: appliance.id,
        projectId: Value(projectId),
        name: appliance.name,
        category: appliance.category,
        quantity: appliance.quantity,
        runningWatts: appliance.runningWatts,
        surgeMultiplier: appliance.surgeMultiplier,
        dailyHours: appliance.dailyHours,
        dutyCycle: Value(appliance.dutyCycle),
      ),
    );
  }

  /// Fetches all appliances for a specific project and converts them back to domain entities
  Future<List<Appliance>> getAppliancesForProject(String projectId) async {
    final records = await (_db.select(_db.appliancesTable)..where((t) => t.projectId.equals(projectId))).get();

    return records.map((record) => Appliance(
      id: record.id,
      name: record.name,
      category: record.category,
      quantity: record.quantity,
      runningWatts: record.runningWatts,
      surgeMultiplier: record.surgeMultiplier,
      dailyHours: record.dailyHours,
      dutyCycle: record.dutyCycle,
    )).toList();
  }

  /// Deletes an appliance from the database by its ID
  Future<void> deleteAppliance(String applianceId) async {
    await (_db.delete(_db.appliancesTable)..where((t) => t.id.equals(applianceId))).go();
  }
}