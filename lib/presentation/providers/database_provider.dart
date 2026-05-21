import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solarpro/data/datasources/local/app_database.dart';
import 'package:solarpro/data/repositories/database_repository.dart';

// 1. Provide the Drift Database instance globally
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// 2. Provide the Database Repository, injecting the database into it automatically
final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DatabaseRepository(db);
});

// 3. Provide a Future list of all saved projects
final projectsProvider = FutureProvider.autoDispose<List<Project>>((ref) async {
  final repo = ref.watch(databaseRepositoryProvider);
  return repo.getAllProjects();
});