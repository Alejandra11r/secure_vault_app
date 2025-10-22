import 'package:secure_vault_app/modules/vault/data/datasources/vault_local_data_source.dart';
import 'package:secure_vault_app/modules/vault/data/repositories/vault_repository_impl.dart';
import 'package:secure_vault_app/modules/vault/domain/usecases/add_note_use_case.dart';
import 'package:secure_vault_app/modules/vault/domain/usecases/delete_note_use_case.dart';
import 'package:secure_vault_app/modules/vault/domain/usecases/get_notes_use_case.dart';
import 'package:secure_vault_app/modules/vault/presentation/provider/vault_provider.dart';

import '../../../app/di/injector.dart';

void initVaultModule() {
  getIt.registerLazySingleton(() => VaultLocalDataSource(getIt()));
  getIt.registerLazySingleton<VaultRepository>(() => VaultRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => AddNoteUseCase(getIt()));
  getIt.registerLazySingleton(() => GetNotesUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteNoteUseCase(getIt()));
  getIt.registerLazySingleton(
    () => VaultProvider(
      addNote: getIt<AddNoteUseCase>(),
      getNotesUseCase: getIt<GetNotesUseCase>(),
      deleteNote: getIt<DeleteNoteUseCase>(),
    ),
  );
}
