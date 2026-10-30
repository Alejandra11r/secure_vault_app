import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/vault_theme.dart';
import '../widgets/vault_ui.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Información')),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: VaultPanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const VaultBrandMark(),
                      const SizedBox(height: 18),
                      Text(
                        'Secure Vault',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tus notas, imágenes y documentos se guardan localmente y cifrados en este dispositivo. '
                        'El acceso requiere la contraseña de la cuenta local.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: VaultColors.muted),
                      ),
                      const SizedBox(height: 16),
                      const ListTile(
                        leading: Icon(Icons.offline_bolt_outlined),
                        title: Text('Uso offline'),
                        subtitle: Text(
                          'Las funciones principales no requieren conexión a internet.',
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Continuar a Secure Vault'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.key_outlined),
                        title: Text('Acceso privado'),
                        subtitle: Text(
                          'No existe recuperación de contraseña; consérvala de forma segura.',
                        ),
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
