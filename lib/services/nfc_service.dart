// lib/services/nfc_service.dart

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcService {
  /// Lee una etiqueta NFC y devuelve su ID o lanza una excepción si falla.
  Future<String?> readNfcId() async {
    try {
      final tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      await FlutterNfcKit.finish();
      return tag.id;
    } catch (e) {
      return Future.error('Error al leer NFC: \$e');
    }
  }

  /// Verifica si el dispositivo soporta y tiene activado el NFC.
  Future<bool> isNfcAvailable() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    return availability == NFCAvailability.available;
  }

  /// Devuelve un mensaje descriptivo si NFC no está disponible
  Future<String?> getAvailabilityMessage() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    return {
      NFCAvailability.disabled: 'NFC está desactivado. Actívalo desde los ajustes.',
      NFCAvailability.not_supported: 'Este dispositivo no soporta NFC.',
    }[availability];
  }
}
