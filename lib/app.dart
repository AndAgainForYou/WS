import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_test/core/router/app_router.dart';
import 'package:ws_test/core/theme/app_theme.dart';

class PathFinderApp extends StatelessWidget {
  PathFinderApp({super.key, GoRouter? router})
    : _router = router ?? createRouter();

  final GoRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Path Finder',
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
