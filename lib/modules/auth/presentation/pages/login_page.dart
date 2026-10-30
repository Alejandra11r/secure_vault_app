import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/widgets/vault_panel.dart';
import '../controllers/login_page_controller.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_actions_widget.dart';
import '../widgets/auth_credentials_fields.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/auth_security_note_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.registration = false});

  final bool registration;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pageController = LoginPageController();
  bool _accountPrefilled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_accountPrefilled && !widget.registration) {
      _emailController.text = context.read<AuthProvider>().user?.email ?? '';
      _accountPrefilled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:
            Text(widget.registration ? 'Nueva caja fuerte' : 'Acceso privado'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeaderWidget(registration: widget.registration),
                  const SizedBox(height: 20),
                  VaultPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthCredentialsFields(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          registration: widget.registration,
                        ),
                        AuthActionsWidget(
                          registration: widget.registration,
                          isBusy: auth.isBusy,
                          hasRegisteredAccounts:
                              auth.registeredEmails.isNotEmpty,
                          onSubmit: () => _pageController.submit(
                            context: context,
                            auth: auth,
                            registration: widget.registration,
                            email: _emailController.text,
                            password: _passwordController.text,
                            passwordController: _passwordController,
                          ),
                          onGoToLogin: () => context.go('/login'),
                          onGoToRegistration: () => context.go('/register'),
                          onDeleteVault: () => _pageController.confirmDelete(
                            context: context,
                            auth: auth,
                            rawEmail: _emailController.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const AuthSecurityNoteWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
