import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:secure_vault_app/modules/auth/presentation/widgets/login_button_widget.dart';
import 'package:secure_vault_app/modules/data/data_repository.dart';
import '../../presentation/provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.data});
  final Map<String, dynamic>? data;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final repository = DataRepository();

  @override
  void initState() {
    super.initState();
    repository.init();
  }

  Future<void> cargarDatos() async {
    final json = '[ "hola", "mundo", "flutter" ]';

    final result = await repository.getProcessedData(json);

    debugPrint(result.toString()); // ["HOLA", "MUNDO", "FLUTTER"]
  }

  @override
  void dispose() {
    repository.dispose();
    super.dispose();
  }

  bool _loading = false;
  Future<void> _onPressedContinue({
    required AuthProvider auth,
    required BuildContext context,
  }) async {
    setState(() {
      _loading = true;
    });
    final ok = await auth.login(
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );
    setState(() {
      _loading = false;
    });
    if (ok && context.mounted) {
      context.go(
        '/vault',
        extra: _emailCtrl.text,
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // cargarDatos();
    final AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      key: const Key('email_field'),
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      key: const Key('password_field'),
                      controller: _passCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    _loading
                        ? const CircularProgressIndicator()
                        : LoginButtonWidget(
                            onPressed: () => _onPressedContinue(
                              auth: auth,
                              context: context,
                            ),
                          ),
                    if (widget.data != null)
                      Text(
                        ' id: ${widget.data?['id']}, name: ${widget.data?['name']}, role: ${widget.data?['role']}',
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
