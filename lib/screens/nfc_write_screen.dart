// lib/screens/nfc_write_screen.dart

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../widgets/shared/custom_app_bar.dart';

class NfcWriteScreen extends StatefulWidget {
  const NfcWriteScreen({super.key});

  @override
  State<NfcWriteScreen> createState() => _NfcWriteScreenState();
}

class _NfcWriteScreenState extends State<NfcWriteScreen> {
  final TextEditingController _textController = TextEditingController();
  bool isWriting = false;

  Future<void> _writeTag() async {
    final message = _textController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe un texto para guardar en la etiqueta.')),
      );
      return;
    }

    final available = await NfcManager.instance.isAvailable();
    if (!available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NFC no disponible en este dispositivo.')),
      );
      return;
    }

    // Mostrar nuestro overlay primero
    setState(() => isWriting = true);
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      await NfcManager.instance.startSession(
        alertMessage: " ",
        onDiscovered: (tag) async {
          try {
            var ndef = Ndef.from(tag);
            if (ndef == null || !ndef.isWritable) {
              NfcManager.instance.stopSession(errorMessage: 'Etiqueta no compatible o no escribible.');
              return;
            }

            final record = NdefRecord.createText(message);
            final ndefMessage = NdefMessage([record]);

            await ndef.write(ndefMessage);
            NfcManager.instance.stopSession();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Texto "$message" escrito correctamente en la etiqueta.')),
              );
              Navigator.pop(context);
            }
          } catch (e) {
            NfcManager.instance.stopSession(errorMessage: e.toString());
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al escribir: ${e.toString()}')),
              );
            }
          }
        },
      );
    } finally {
      if (mounted) setState(() => isWriting = false);
    }
  }

  Widget _buildNfcOverlay() {
    return Container(
      color: Colors.black.withAlpha((0.5 * 255).round()),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'Acerca tu dispositivo a la etiqueta NFC',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Escribiendo: "${_textController.text.trim()}"',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
              onPressed: () {
                setState(() => isWriting = false);
                NfcManager.instance.stopSession();
              },
              child: const Text('CANCELAR'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Escribir en etiqueta NFC'),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Texto a guardar en la etiqueta:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contenido de la etiqueta',
                    hintText: 'Ejemplo: documentosidentidad',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.nfc),
                  label: const Text('ESCRIBIR EN ETIQUETA'),
                  onPressed: isWriting ? null : _writeTag,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
          if (isWriting) _buildNfcOverlay(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    NfcManager.instance.stopSession();
    super.dispose();
  }
}
