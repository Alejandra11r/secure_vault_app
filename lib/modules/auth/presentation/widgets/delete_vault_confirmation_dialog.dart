import 'package:flutter/material.dart';

class DeleteVaultConfirmationDialog extends StatefulWidget {
  const DeleteVaultConfirmationDialog({required this.email, super.key});

  final String email;

  @override
  State<DeleteVaultConfirmationDialog> createState() =>
      _DeleteVaultConfirmationDialogState();
}

class _DeleteVaultConfirmationDialogState
    extends State<DeleteVaultConfirmationDialog> {
  final _confirmationController = TextEditingController();

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar caja fuerte'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Se eliminará la cuenta local ${widget.email}. Esta acción no se puede deshacer.',
          ),
          const SizedBox(height: 8),
          const Text(
            'Las notas antiguas AES-CBC se conservarán sin migrarse y no aparecerán en la nueva caja fuerte.',
          ),
          const SizedBox(height: 12),
          const Text('Escribe ELIMINAR para confirmar.'),
          TextField(
            controller: _confirmationController,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            _confirmationController.text == 'ELIMINAR',
          ),
          child: const Text('Eliminar caja fuerte'),
        ),
      ],
    );
  }
}
