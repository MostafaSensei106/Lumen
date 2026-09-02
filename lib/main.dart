import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lumen/core/router/app_router.dart';
import 'package:lumen/core/widgets/widgets.dart';
import 'package:lumen/core/utils/sys_init/sys_init.dart';

void main() async {
  await SysInit.initializeCriticalServices();
  unawaited(SysInit.initializeDeferredServices());
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
