import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solarpro/presentation/providers/database_provider.dart';
import 'package:solarpro/presentation/providers/appliance_provider.dart';
import 'package:solarpro/presentation/widgets/app_drawer.dart';
import 'package:solarpro/data/datasources/local/app_database.dart';
import 'package:solarpro/data/repositories/database_repository.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the future provider to handle loading, success, and error states automatically
    final projectsAsyncValue = ref.watch(projectsProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('My Projects'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: projectsAsyncValue.when(
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(
              child: Text('No projects saved yet. Go to the Calculator to create one!'),
            );
          }

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ListTile(
                leading: const Icon(Icons.solar_power),
                title: Text(project.name),
                subtitle: Text('Created: ${project.createdAt.toString().split(' ')[0]}'),
                onTap: () async {
                  // 1. Fetch appliances for this specific project
                  final repo = ref.read(databaseRepositoryProvider);
                  final savedAppliances = await repo.getAppliancesForProject(project.id);
                  
                  // 2. Load them into our active memory state
                  ref.read(applianceListProvider.notifier).setAppliances(savedAppliances);
                  ref.read(activeProjectIdProvider.notifier).state = project.id;
                  ref.read(activeProjectNameProvider.notifier).state = project.name;
                  
                  // 3. Jump back to the Calculator tab to view them!
                  if (context.mounted) {
                    context.go('/calculator');
                  }
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final repo = ref.read(databaseRepositoryProvider);
                    await repo.deleteProject(project.id);
                    // Refresh the list automatically after deleting
                    ref.invalidate(projectsProvider);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}