import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'data/injection_provider.dart';
import 'screens/dashboard_page.dart';
import 'screens/injection_detail_page.dart';
import 'screens/us_intro_page.dart';

/// Shared fade page transition used on all routes.
CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: CurveTween(curve: Curves.easeOut).animate(animation),
        child: child,
      ),
    );

final router = GoRouter(
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          _fadePage(state, const DashboardPage()),
    ),
    GoRoute(
      path: '/category/:name',
      pageBuilder: (context, state) {
        final name = state.pathParameters['name'] ?? 'All';
        return _fadePage(state, DashboardPage(initialCategory: name));
      },
    ),
    GoRoute(
      path: '/us-intro',
      pageBuilder: (context, state) =>
          _fadePage(state, const UsIntroPage()),
    ),
    GoRoute(
      path: '/procedure/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final provider = context.read<InjectionDataProvider>();
        final technique = provider.findById(id);
        if (technique == null) {
          return _fadePage(
            state,
            Scaffold(
              body: Center(
                child: Text('Procedure not found: $id'),
              ),
            ),
          );
        }
        return _fadePage(state, InjectionDetailPage(technique: technique));
      },
    ),
  ],
);
