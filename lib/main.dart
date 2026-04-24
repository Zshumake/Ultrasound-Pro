import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'data/injection_provider.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_manager.dart';
import 'theme/favorites_manager.dart';
import 'theme/recently_viewed_manager.dart';

void main() {
  // Use bundled font files instead of fetching from Google CDN at runtime.
  // Fonts are declared in pubspec.yaml — eliminates 2 blocking network
  // requests per cold load, and works on hospital networks that block gstatic.
  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => FavoritesManager()),
        ChangeNotifierProvider(create: (_) => RecentlyViewedManager()),
        ChangeNotifierProvider(create: (_) => InjectionDataProvider()),
      ],
      child: const USGuidedInjectionsApp(),
    ),
  );
}

class USGuidedInjectionsApp extends StatelessWidget {
  const USGuidedInjectionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();

    return MaterialApp.router(
      title: 'US Guided Injections Manual',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.themeMode,
      routerConfig: router,
    );
  }
}
