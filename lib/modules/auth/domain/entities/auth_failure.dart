enum AuthFailureCode {
  accountAlreadyExists,
  invalidCredentials,
  invalidEmail,
  invalidPassword,
  invalidVault,
}

class AuthFailure implements Exception {
  const AuthFailure(this.code);

  final AuthFailureCode code;
}
