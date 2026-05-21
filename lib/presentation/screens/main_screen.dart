import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    // Since we are moving to a Hamburger Menu (Drawer) inside each screen,
    // the MainScreen simply returns the active stateful shell branch.
    return navigationShell;
  }
}