import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/layouts/main_layout.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/projectors_screen.dart';
import '../../presentation/screens/teachers_screen.dart';
import '../../presentation/screens/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/projectors',
          name: 'projectors',
          builder: (context, state) => const ProjectorsScreen(),
        ),
        GoRoute(
          path: '/teachers',
          name: 'teachers',
          builder: (context, state) => const TeachersScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
