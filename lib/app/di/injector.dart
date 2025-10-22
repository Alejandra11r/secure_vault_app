import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_vault_app/core/security/encryption_service.dart';
import 'package:secure_vault_app/core/security/secure_storage_service.dart';
import '../../modules/auth/di/auth_injector.dart';
import '../../modules/vault/di/vault_injector.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(() => SecureStorageService(getIt()));
  getIt.registerLazySingleton(() => EncryptionService());

  initAuthModule();
  initVaultModule();
}
