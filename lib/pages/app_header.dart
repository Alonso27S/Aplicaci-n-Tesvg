import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 240, 240),
      body: SafeArea(
        child: Column(
          children: [

            // LOGOS
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/sounds/images/logo gobierno.png",
                    height: 30,
                  ),
                  Image.asset(
                    "assets/sounds/images/logo tecnm.png",
                    height: 30,
                  ),
                  Image.asset(
                    "assets/sounds/images/logo tesvg.png",
                    height: 30,
                  ),
                ],
              ),
            ),

            // TITULO
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      "Sistema De Escaneo\nDe Credenciales QR",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 164, 40, 3),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const CircularProgressIndicator(),

                    const SizedBox(height: 15),

                    const Text(
                      "Inicializando sistema...",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}