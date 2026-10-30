import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/info_page.dart';
import '../../modules/auth/presentation/pages/login_page.dart';
import '../../modules/auth/presentation/provider/auth_provider.dart';
import '../../modules/vault/presentation/pages/vault_page.dart';

GoRouter createAppRouter(AuthProvider auth) => GoRouter(
      initialLocation: '/login',
      refreshListenable: auth,
      redirect: (context, state) {
        final location = state.matchedLocation;
        final isAuthPage = location == '/login' || location == '/register';
        if (auth.status == AuthStatus.initializing) return '/loading';
        if (auth.isUnlocked) return isAuthPage ? '/vault' : null;
        if (location == '/vault') {
          return auth.status == AuthStatus.setupRequired
              ? '/register'
              : '/login';
        }
        if (auth.status == AuthStatus.setupRequired && location == '/login') {
          return '/register';
        }
        if (location == '/loading') {
          return auth.status == AuthStatus.setupRequired
              ? '/register'
              : '/login';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/loading',
          builder: (context, state) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
        GoRoute(
          path: '/info',
          name: 'info',
          builder: (context, state) => const InfoPage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const LoginPage(registration: true),
        ),
        GoRoute(
          path: '/vault',
          name: 'vault',
          builder: (context, state) => VaultPage(
            user: auth.user?.email ?? 'Sin usuario',
          ),
        ),
      ],
    );
