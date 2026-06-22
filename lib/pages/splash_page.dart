import 'package:flutter/material.dart';
import 'scanner_page.dart';
import 'app_header.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _iniciarSistema();
  }

  Future<void> _iniciarSistema() async {

    await Future.delayed(
      const Duration(seconds: 7),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ScannerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AppHeader(),
      ),
    );
  }
}