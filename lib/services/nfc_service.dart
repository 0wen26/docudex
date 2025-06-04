import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

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
}
