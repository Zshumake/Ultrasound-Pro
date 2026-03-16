import 'package:flutter/material.dart';
import 'screens/dashboard_page.dart';
import 'theme/app_theme.dart';
import 'theme/theme_manager.dart';
import 'theme/favorites_manager.dart';

final themeManager = ThemeManager();
final favoritesManager = FavoritesManager();

void main() {
  runApp(const USGuidedInjectionsApp());
}

class USGuidedInjectionsApp extends StatefulWidget {
  const USGuidedInjectionsApp({super.key});

  @override
  State<USGuidedInjectionsApp> createState() => _USGuidedInjectionsAppState();
}

class _USGuidedInjectionsAppState extends State<USGuidedInjectionsApp> {
  @override
  void initState() {
    super.initState();
    themeManager.addListener(_update);
    favoritesManager.addListener(_update);
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    themeManager.removeListener(_update);
    favoritesManager.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'US Guided Injections Manual',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.themeMode,
      home: const DashboardPage(),
    );
  }
}
