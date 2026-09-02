import 'package:flutter/material.dart';
import 'package:lumen/core/router/app_router.dart';
import 'package:lumen/core/widgets/widgets.dart';

void main() {
  runApp(const LumenApp());
}

class LumenApp extends StatelessWidget {
  const LumenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lumen: Broken Circuit',
      theme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
