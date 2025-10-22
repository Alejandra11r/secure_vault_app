import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                key: const Key('email_field'),
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                key: const Key('password_field'),
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    key: const Key('login_button'),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      final ok = await auth.login(
                          _emailCtrl.text.trim(), _passCtrl.text.trim());
                      setState(() {
                        _loading = false;
                      });
                      if (ok && context.mounted) {
                        context.go('/vault', extra: _emailCtrl.text);
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login failed')));
                      }
                    },
                    child: const Text('Login'),
                  ),
            if (widget.data != null)
              Text(
                  ' id: ${widget.data!['id']}, name: ${widget.data!['name']}, role: ${widget.data!['role']}')
          ],
        ),
      ),
    );
  }
}
