import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modules/home/presentation/home_screen.dart';
import '../../modules/levels/presentation/levels_screen.dart';
import '../../modules/shop/presentation/shop_screen.dart';
import '../../modules/settings/presentation/settings_screen.dart';
import '../../modules/profile/presentation/profile_screen.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [$homeRoute, $levelsRoute, $shopRoute, $settingsRoute, $profileRoute],
);

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@TypedGoRoute<LevelsRoute>(path: '/levels')
class LevelsRoute extends GoRouteData with $LevelsRoute {
  const LevelsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LevelsScreen();
  }
}

@TypedGoRoute<ShopRoute>(path: '/shop')
class ShopRoute extends GoRouteData with $ShopRoute {
  const ShopRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ShopScreen();
  }
}

@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}

@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileScreen();
  }
}
