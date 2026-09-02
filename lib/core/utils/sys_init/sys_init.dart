import 'package:flutter/material.dart';
import 'package:lumen/core/di/injection.dart';

class SysInit {
  static Future<void> initializeCriticalServices() async {
    WidgetsFlutterBinding.ensureInitialized();
    await InjectionContainer.init();
    // Initialize other critical services here if needed
  }

  static Future<void> initializeDeferredServices() async {
    // Initialize deferred/non-critical services here
  }
}
