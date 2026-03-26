import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class ASFFutoApp extends StatelessWidget {
  const ASFFutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ASF FUTO',
      debugShowCheckedModeBanner: false,

      // ── Themes ──
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // ── Router ──
      routerConfig: AppRouter.router,
    );
  }
}