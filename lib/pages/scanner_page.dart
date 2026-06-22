import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:ui';
import '../services/api_service.dart';

class ScannerPage extends StatefulWidget {
const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  bool scanned = false;

  bool loading = false;

  Map<String, dynamic>? usuario;

  final AudioPlayer player = AudioPlayer();
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  Future<void> reproducirSonido(
    String archivo,
  ) async {
    try {
      await player.stop();

      await player.play(
        AssetSource(
          "sounds/$archivo",
        ),
      );
    } catch (e) {
      print("ERROR SONIDO:");
      print(e);
    }
  }

  Future<void> verificarQR(
    String qr,
  ) async {
    try {
      setState(() {
        loading = true;
        usuario = null;
      });

      print("================================");
      print("QR ESCANEADO:");
      print(qr);
      print("================================");

      final data =
          await ApiService.verificarQR(
        qr,
      );

      print("================================");
      print("RESPUESTA API:");
      print(data);
      print("================================");

      setState(() {
        usuario = data;
        loading = false;
      });

      // SONIDOS

      if (data["message"]
              ?.toString()
              .toLowerCase() ==
          "credencial inactiva") {
        await reproducirSonido(
          "NEGADO.mp4",
        );
      } else if (data["success"] ==
          false) {
        await reproducirSonido(
          "ERROR.mp4",
        );

        } else if (data["message"]
          ?.toString()
          .toLowerCase() ==
            "credencial no encontrada") {

          await reproducirSonido(
          "NEGADO.mp4",
      );

        
      } else if (data["movimiento"]
              ?.toString() ==
          "ENTRADA") {
        await reproducirSonido(
          "ENTRADA.mp4",
        );
      } else if (data["movimiento"]
              ?.toString() ==
          "SALIDA") {
        await reproducirSonido(
          "REGISTRO.mp4",
        );
      }

      Timer(
        const Duration(seconds: 5),
        () {
          if (!mounted) return;

          setState(() {
            usuario = null;
            scanned = false;
            loading = false;
          });
        },
      );
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
        scanned = false;
      });

      await reproducirSonido(
        "ERROR.mp4",
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(
      begin: 0,
      end: 220,
    ).animate(_scanController);
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor:
          Colors.grey.shade300,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // MENU
            Align(
              alignment: Alignment.centerLeft,
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: "camara",
                    child: Text("Selección de cámara"),
                  ),
                  PopupMenuItem(
                    value: "logout",
                    child: Text("Cerrar sesión"),
                  ),
                  PopupMenuItem(
                    value: "soporte",
                    child: Text("Soporte técnico"),
                  ),
                ],
              ),
            ),

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

            const SizedBox(height: 15),

            const Text(
              "Coloque el código QR dentro del recuadro",
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
    child: Stack(
      alignment: Alignment.center,
      children: [

        MobileScanner(
        onDetect: (capture) {
            if (scanned) return;

            final barcode = capture.barcodes.first;
            final qr = barcode.rawValue ?? "";

            if (qr.isEmpty) return;

            scanned = true;

            verificarQR(qr);
          },
      ),

      SizedBox(
  width: 250,
  height: 250,
  child: Stack(
    children: [

      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(5),
          ),
        ),
      ),

      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(5),
          ),
        ),
      ),

      AnimatedBuilder(
        animation: _scanAnimation,
        builder: (context, child) {
          return Positioned(
            top: _scanAnimation.value,
            left: 0,
            right: 0,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent,
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  ),
),

      if (loading)
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius:
                BorderRadius.circular(15),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.greenAccent,
                ),
              ),
              SizedBox(width: 15),
              Text(
                "Validando QR...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),  
    ],
  ),
),
    if (!loading && usuario != null)
    Container(
      margin: const EdgeInsets.fromLTRB(
        15,
        10,
        15,
        10,
      ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 25,
          sigmaY: 25,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              0.08,
            ),
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),

          child: Row(
            children: [

              CircleAvatar(
                radius: 35,
                backgroundImage:
                    usuario!["foto"] != null &&
                            usuario!["foto"]
                                .toString()
                                .isNotEmpty
                        ? NetworkImage(
                            "https://credencialestesvg.com.mx/${usuario!["foto"]}",
                          )
                        : null,
                child: usuario!["foto"] == null
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [

                    Text(
                      usuario!["nombreCompleto"]
                              ?.toString() ??
                          "",
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Text(
                      "Matrícula: ${usuario!["numeroControl"] ?? ""}",
                      style:
                          const TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      "Área: ${usuario!["area"] ?? ""}",
                      style:
                          const TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      "Hora: ${TimeOfDay.now().format(context)}",
                      style:
                          const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      usuario!["message"]
                                  ?.toString()
                                  .toLowerCase() ==
                              "credencial inactiva"
                          ? "ACCESO DENEGADO"
                          : usuario!["success"] ==
                                  false
                              ? "LÍMITE DE ACCESOS"
                              : usuario!["movimiento"]
                                          .toString() ==
                                      "ENTRADA"
                                  ? "ACCESO PERMITIDO"
                                  : "SALIDA REGISTRADA",
                      style: TextStyle(
                        color:
                            usuario!["message"]
                                        ?.toString()
                                        .toLowerCase() ==
                                    "credencial inactiva"
                                ? Colors.redAccent
                                : usuario!["success"] ==
                                        false
                                    ? Colors.redAccent
                                    : usuario!["movimiento"]
                                                .toString() ==
                                            "ENTRADA"
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),

            

            Container(
              height: 70,
              width:
                  double.infinity,
              color:
                  const Color(
                0xFF9F1239,
              ),
              child:
                  const Center(
                child: Text(
                  "TESVG",
                  style:
                      TextStyle(
                    color: Colors
                        .white,
                    fontSize:
                        32,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    player.dispose();
    super.dispose();
  }
}