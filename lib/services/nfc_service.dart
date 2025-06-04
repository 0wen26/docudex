import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;

class NfcService {
  static Future<String?> readTag() async {
    try {
      final tag = await FlutterNfcKit.poll();
      await FlutterNfcKit.finish();
      return tag.id;
    } catch (e) {
      throw 'Error leyendo NFC: $e';
    }
  }

  /// Reads the first NDEF text record from a tag, if available.
  static Future<String?> readNdefText() async {
    try {
      final availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        throw 'NFC no disponible en este dispositivo.';
      }

      await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      final records = await FlutterNfcKit.readNDEFRecords();

      String? text;
      for (final record in records) {
        if (record is ndef.TextRecord) {
          text = record.text;
          break;
        }
      }

      await FlutterNfcKit.finish();
      return text;
    } catch (e) {
      try {
        await FlutterNfcKit.finish();
      } catch (_) {}
      throw 'Error leyendo NFC: $e';
    }
  }
}
