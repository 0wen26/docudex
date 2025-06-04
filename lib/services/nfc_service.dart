import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcReadException implements Exception {
  final String message;
  NfcReadException(this.message);
  @override
  String toString() => message;
}

class NfcService {
  static Future<String?> readTagId() async {
    try {
      final tag = await FlutterNfcKit.poll();
      await FlutterNfcKit.finish();
      return tag.id;
    } catch (e) {
      throw NfcReadException(e.toString());
    }
  }
}
