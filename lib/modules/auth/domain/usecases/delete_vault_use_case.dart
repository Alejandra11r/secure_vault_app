import '../repositories/auth_repository.dart';

class DeleteVaultUseCase {
  const DeleteVaultUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call(String email) => _repository.deleteVault(email);
}
