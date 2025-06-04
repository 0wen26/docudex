// main.dart
import 'package:flutter/material.dart';
import 'screens/document_list_screen.dart';

void main() {
  runApp(ArchivoCentralApp());
}

class ArchivoCentralApp extends StatelessWidget {
  const ArchivoCentralApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archivo Central',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
      ),
      home: const DocumentListScreen(),
    );
  }
}
