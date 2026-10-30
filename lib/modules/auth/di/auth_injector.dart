import 'package:secure_vault_app/modules/auth/data/datasources/auth_local_data_source.dart';
import 'package:secure_vault_app/modules/auth/data/repositories/auth_repository_impl.dart';
import 'package:secure_vault_app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/login_use_case.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/logout_use_case.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/register_use_case.dart';
import 'package:secure_vault_app/modules/auth/domain/usecases/delete_vault_use_case.dart';
import 'package:secure_vault_app/modules/auth/presentation/provider/auth_provider.dart';
import 'package:secure_vault_app/modules/vault/data/database/vault_database.dart';

import '../../../app/di/injector.dart';

void initAuthModule() {
  getIt.registerLazySingleton(() => AuthLocalDataSource(getIt()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt(),
      getIt(),
      deleteVaultData: getIt<VaultDatabase>().deleteAccountData,
    ),
  );
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteVaultUseCase(getIt()));
  getIt.registerLazySingleton(
    () => AuthProvider(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      deleteVaultUseCase: getIt<DeleteVaultUseCase>(),
    ),
  );
}
