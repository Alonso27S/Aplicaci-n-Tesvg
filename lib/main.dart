import 'package:flutter/material.dart';
import 'pages/scanner_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Verificador QR',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: ScannerPage(),
    );
  }
}