import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/auth/presentation/provider/auth_provider.dart';
import '../modules/vault/presentation/provider/vault_provider.dart';
import '../core/messaging/firebase_messaging_service.dart';
import 'app_environment.dart';
import 'di/injector.dart';
import 'routes/app_routes.dart';
import 'theme/vault_theme.dart';
import 'widgets/vault_backdrop.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late final AuthProvider _auth;
  late final VaultProvider _vault;
  late final routerConfig = createAppRouter(_auth);
  bool _obscureContent = false;

  @override
  void initState() {
    super.initState();
    _auth = getIt<AuthProvider>();
    _vault = getIt<VaultProvider>();
    _auth.addListener(_clearVaultOnLock);
    FirebaseMessagingService.onNavigate = (route) {
      if (mounted) {
        routerConfig.go(route);
      }
    };
    WidgetsBinding.instance.addObserver(this);
  }

  void _clearVaultOnLock() {
    if (!_auth.isUnlocked) _vault.activateAccount(null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        if (!_vault.hasExternalActivity) {
          _obscureContent = true;
          _auth.lock();
        }
        break;
      case AppLifecycleState.resumed:
        _obscureContent = false;
        break;
      case AppLifecycleState.detached:
        _obscureContent = true;
        _auth.lock();
        break;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _auth.removeListener(_clearVaultOnLock);
    FirebaseMessagingService.onNavigate = null;
    routerConfig.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: _auth),
        ChangeNotifierProvider<VaultProvider>.value(value: _vault),
      ],
      child: MaterialApp.router(
        title: AppBuildConfig.isProduction
            ? 'Secure Vault'
            : 'Secure Vault (${AppBuildConfig.environment.name})',
        theme: VaultTheme.dark,
        routerConfig: routerConfig,
        builder: (context, child) => VaultBackdrop(
          child: Stack(
            children: [
              child ?? const SizedBox.shrink(),
              if (_obscureContent)
                const Positioned.fill(
                  child: ColoredBox(
                    color: VaultColors.background,
                    child: Center(
                      child: Text(
                        'Secure Vault',
                        style: TextStyle(
                          color: VaultColors.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
