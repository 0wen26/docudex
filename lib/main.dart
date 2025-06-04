// main.dart
import 'package:flutter/material.dart';
import 'screens/document_list_screen.dart';
import 'injection_container.dart';
import 'package:provider/provider.dart';
import 'providers/location_provider.dart';

void main() {
  setupDependencies();
  runApp(const ArchivoCentralApp());
}

class ArchivoCentralApp extends StatelessWidget {
  const ArchivoCentralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationProvider(),
      child: MaterialApp(
        title: 'Archivo Central',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.black,
          cardColor: Colors.grey[900],
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
        ),
        home: const DocumentListScreen(),
      ),
    );
  }
}
