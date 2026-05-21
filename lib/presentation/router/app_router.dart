import 'package:go_router/go_router.dart';
import 'package:solarpro/presentation/screens/load_analyzer_screen.dart';
import 'package:solarpro/presentation/screens/main_screen.dart';
import 'package:solarpro/presentation/screens/projects_screen.dart';
import 'package:solarpro/presentation/screens/inverter_calculation_screen.dart';
import 'package:solarpro/presentation/screens/solar_calculation_screen.dart';

// The global router configuration for the app
final appRouter = GoRouter(
  initialLocation: '/calculator',
  routes: [
    // StatefulShellRoute keeps the state of each tab alive when switching
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Branch 1: The Calculator (Load Analyzer)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calculator',
              builder: (context, state) => const LoadAnalyzerScreen(),
            ),
          ],
        ),
        // Branch 2: Inverter Calculation
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inverter_calc',
              builder: (context, state) => const InverterCalculationScreen(),
            ),
          ],
        ),
        // Branch 3: Solar Calculation
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/solar_calc',
              builder: (context, state) => const SolarCalculationScreen(),
            ),
          ],
        ),
        // Branch 4: The Projects Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/projects',
              builder: (context, state) => const ProjectsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);