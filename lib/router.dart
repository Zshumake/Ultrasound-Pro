import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'data/injection_provider.dart';
import 'screens/dashboard_page.dart';
import 'screens/injection_detail_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/category/:name',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? 'All';
        return DashboardPage(initialCategory: name);
      },
    ),
    GoRoute(
      path: '/procedure/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final provider = context.read<InjectionDataProvider>();
        final technique = provider.findById(id);
        if (technique == null) {
          return const Scaffold(
            body: Center(child: Text('Procedure not found')),
          );
        }
        return InjectionDetailPage(technique: technique);
      },
    ),
  ],
);
