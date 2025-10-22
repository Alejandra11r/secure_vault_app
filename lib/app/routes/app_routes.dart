import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:secure_vault_app/modules/auth/presentation/pages/login_page.dart';
import 'package:secure_vault_app/modules/vault/presentation/pages/vault_page.dart';

final goRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        final dataParam = state.uri.queryParameters['data'];
        final decodedMap = dataParam != null
            ? jsonDecode(Uri.decodeComponent(dataParam)) as Map<String, dynamic>
            : null;
        return LoginPage(
          data: decodedMap,
        );
      },
    ),
    GoRoute(
      path: '/vault',
      name: 'vault',
      builder: (context, state) {
        final String? user = state.extra as String?;
        return VaultPage(user: user ?? 'Sin usuario');
      },
    ),
  ],
);
