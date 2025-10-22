import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/injector.dart';
import '../modules/auth/presentation/provider/auth_provider.dart';
import '../modules/vault/presentation/provider/vault_provider.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<VaultProvider>()),
      ],
      child: MaterialApp.router(
        title: 'Secure Vault App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: goRouter,
      ),
    );
  }
}
