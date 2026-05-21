import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.solar_power, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text('SolarPro', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('1. Load Calculator'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              context.go('/calculator');
            },
          ),
          ListTile(
            leading: const Icon(Icons.battery_charging_full),
            title: const Text('2. Inverter Calculator'),
            onTap: () {
              Navigator.pop(context);
              context.go('/inverter_calc');
            },
          ),
          ListTile(
            leading: const Icon(Icons.solar_power),
            title: const Text('3. Solar Calculator'),
            onTap: () {
              Navigator.pop(context);
              context.go('/solar_calc');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('My Projects'),
            onTap: () {
              Navigator.pop(context);
              context.go('/projects');
            },
          ),
        ],
      ),
    );
  }
}