import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_chat_app/app/core/routes/router_path.dart';

import '../../feature/screens/message_screen/message_screen.dart';
import '../constants/enum.dart';
import '../extensions/route_path_extension.dart';



class AppRouter {
  AppRouter._();

  static final GoRouter initRoute = GoRouter(
    initialLocation: RoutePath.messageScreen.addBasePath,
    debugLogDiagnostics: true,
    navigatorKey: GlobalKey<NavigatorState>(),
    routes: [
      // Auth Routes
      _route(RoutePath.messageScreen, const MessageScreen()),

    ],
  );

  static GoRouter get route => initRoute;

  /// General route builder with optional animation
  static GoRoute _route(String path, Widget screen, {bool useAnimation = true}) {
    return GoRoute(
      name: path,
      path: path.addBasePath,
      pageBuilder: (context, state) => _buildPage(
        child: screen,
        state: state,
        disableAnimation: !useAnimation,
      ),
    );
  }

  /// Route builder for routes that require extra data
  // static GoRoute _routeWithExtra<T>(
  //     String path,
  //     Widget Function(T) builder, {
  //       TransitionType transitionType = TransitionType.defaultTransition,
  //     }) {
  //   return GoRoute(
  //     name: path,
  //     path: path.addBasePath,
  //     pageBuilder: (context, state) {
  //       final extra = state.extra as T;
  //       return _buildPage(
  //         child: builder(extra),
  //         state: state,
  //         transitionType: transitionType,
  //       );
  //     },
  //   );
  // }

  /// Centralized page builder with animation
  static CustomTransitionPage _buildPage({
    required Widget child,
    required GoRouterState state,
    bool disableAnimation = false,
    TransitionType transitionType = TransitionType.defaultTransition,
  }) {
    if (disableAnimation) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: Duration.zero,
        transitionsBuilder: (_, __, ___, child) => child,
      );
    }

    switch (transitionType) {
      case TransitionType.detailsScreen:
        return CustomTransitionPage(
          key: state.pageKey,
          child: child,
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, _, child) {
            final scaleAnim = animation.drive(
              Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
            );
            return ScaleTransition(scale: scaleAnim, child: child);
          },
        );
      default:
        return CustomTransitionPage(
          key: state.pageKey,
          child: child,
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, _, child) {
            final offsetAnim = animation.drive(
              Tween(begin: const Offset(1, 0), end: Offset.zero),
            );
            return SlideTransition(position: offsetAnim, child: child);
          },
        );
    }
  }
}