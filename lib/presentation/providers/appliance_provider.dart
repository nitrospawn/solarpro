import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solarpro/domain/entities/appliance.dart';

/// A Notifier that manages the active list of appliances in memory
class ApplianceListNotifier extends StateNotifier<List<Appliance>> {
  ApplianceListNotifier() : super([]);

  void addAppliance(Appliance appliance) {
    // Replaces the old list with a new list containing the new appliance
    state = [...state, appliance];
  }

  void removeAppliance(int index) {
    final newState = [...state];
    newState.removeAt(index);
    state = newState;
  }

  void clear() {
    state = [];
  }

  // Loads an entire list of appliances at once (used when loading a saved project)
  void setAppliances(List<Appliance> appliances) {
    state = appliances;
  }
}

final applianceListProvider = StateNotifierProvider<ApplianceListNotifier, List<Appliance>>((ref) {
  return ApplianceListNotifier();
});

// Track the currently loaded project (so we can update it instead of making a new one)
final activeProjectIdProvider = StateProvider<String?>((ref) => null);
final activeProjectNameProvider = StateProvider<String?>((ref) => null);