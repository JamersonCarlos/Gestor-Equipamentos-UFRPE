import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cards_provier.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cursos_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/projector_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/cards_grid_screen.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/tags/tags_associateds_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ProjectorProvider()),
            ChangeNotifierProvider(create: (context) => CardsProvider()),
            ChangeNotifierProvider(create: (context) => CursosProvider()),
          ],
          child: MainLayout(child: child),
        );
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
        GoRoute(
          path: '/cards',
          name: 'cards',
          builder: (context, state) => const ResponsiveRfidCardGrid(),
        ),
        GoRoute(
          path: '/tags-associateds',
          name: 'tags-associateds',
          builder: (context, state) => const TagsAssociatedsScreen(),
        ),
      ],
    ),
  ],
);
