// ignore_for_file: cast_nullable_to_non_nullable

import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/application/auth/auth_notifier.dart';
import '../../../auth/presentation/sign_in_page.dart';
import '../../../auth/shared/providers.dart';

import '../../../home/presentation/home_page.dart';

import '../../../home/presentation/version_page.dart';

import 'route_names.dart';

class RouterNotifier extends ChangeNotifier {
  bool skipNotifications = false;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authNotifierProvider, (_, __) {
      if (!skipNotifications) {
        notifyListeners();
      }
    });
  }

  final Ref _ref;

  String? redirectLogic(BuildContext context, GoRouterState state) {
    try {
      skipNotifications = true;

      final authState = _ref.read(authNotifierProvider);

      final areWeSigningIn = state.location == RouteNames.signInRoute;

      log('location ${state.location}');

      return authState.maybeMap(
        authenticated: (_) => areWeSigningIn ? RouteNames.homeRoute : null,
        orElse: () => areWeSigningIn ? null : RouteNames.signInRoute,
      );
    } finally {
      skipNotifications = false;
    }
  }

  List<GoRoute> get routes {
    return [
      GoRoute(
        name: RouteNames.signInNameRoute,
        path: RouteNames.signInRoute,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        name: RouteNames.homeNameRoute,
        path: RouteNames.homeRoute,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
              name: RouteNames.versionlNameRoute,
              path: RouteNames.versionRoute,
              builder: (context, state) => const VersionPage()),
        ],
      ),
    ];
  }
}
