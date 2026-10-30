import 'dart:typed_data';

class UserEntity {
  const UserEntity({required this.accountId, required this.email});

  final String accountId;
  final String email;
}

class AuthSession {
  const AuthSession({required this.user, required this.vaultKey});

  final UserEntity user;
  final Uint8List vaultKey;
}
