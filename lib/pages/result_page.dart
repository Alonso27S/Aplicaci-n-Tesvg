import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';



class ResultPage extends StatefulWidget {
  final String qrData;

  const ResultPage({
    super.key,
    required this.qrData,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool loading = true;

  Map<String, dynamic>? usuario;

  final AudioPlayer player = AudioPlayer();

  bool sonidoReproducido = false;

  @override
  void initState() {
    super.initState();

    print("================================");
    print("RESULT PAGE INICIADA");
    print("QR RECIBIDO:");
    print(widget.qrData);
    print("================================");

    cargar();
  }

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

  Future<void> cargar() async {
    try {
      print("================================");
      print("CONSULTANDO API...");
      print("================================");

      final data = await ApiService.verificarQR(
        widget.qrData,
      );

      print("================================");
      print("DATOS RECIBIDOS DE API:");
      print(data);
      print("================================");

      setState(() {
  usuario = data;
  loading = false;
});

// ======================
// SONIDOS
// ======================

if (!sonidoReproducido) {

  sonidoReproducido = true;

  // CREDENCIAL INACTIVA
  if (
      data["message"]
              ?.toString()
              .toLowerCase() ==
          "credencial inactiva") {

    await reproducirSonido(
      "NEGADO.mp4",
    );
  }

  // LÍMITE DE ACCESOS
  else if (data["success"] == false) {

    await reproducirSonido(
      "ERROR.mp4",
    );
  }

  // ENTRADA
  else if (
      data["movimiento"]
              ?.toString() ==
          "ENTRADA") {

    await reproducirSonido(
      "ENTRADA.mp4",
    );
  }

  // SALIDA
  else if (
      data["movimiento"]
              ?.toString() ==
          "SALIDA") {

    await reproducirSonido(
      "REGISTRO.mp4",
    );
  }
}

      // Regresar automáticamente al escáner
      Timer(
  const Duration(seconds: 5),
  () {
    if (mounted) {
      Navigator.pop(context);
    }
  },
);
    } catch (e) {
      print("================================");
      print("ERROR EN RESULT PAGE:");
      print(e);
      print("================================");

      setState(() {
  loading = false;
});

await reproducirSonido(
  "ERROR.mp4",
);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credencial"),
      ),
     body: loading
    ? const Center(
        child: CircularProgressIndicator(),
      )

    : usuario == null

        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No se encontró información",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "QR:\n${widget.qrData}",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )

          : usuario!["message"]
            ?.toString()
            .toLowerCase() ==
        "credencial inactiva"

    ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 120,
              ),

              const SizedBox(height: 20),

              const Text(
                "CREDENCIAL INACTIVA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                usuario!["message"]
                        ?.toString() ??
                    "",
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Acceso denegado",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )



        : (usuario!["success"] == false)

            ? Center(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      const Icon(
                        Icons.block,
                        color: Colors.red,
                        size: 120,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Text(
                        "LÍMITE DE ACCESOS",
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Text(
                        usuario!["message"]
                                ?.toString() ??
                            "El usuario excedió el límite de accesos permitidos para el día de hoy",
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      const Text(
                        "Regresando al escáner en 5 segundos...",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            : SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            usuario!["foto"] != null &&
                                    usuario!["foto"]
                                        .toString()
                                        .isNotEmpty
                                ? NetworkImage(
                                    "https://credencialestesvg.com.mx/${usuario!["foto"]}",
                                  )
                                : null,
                        child:
                            usuario!["foto"] == null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                  )
                                : null,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        usuario!["nombreCompleto"]
                                ?.toString() ??
                            "",
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ENTRADA O SALIDA
                      Card(
                        color: usuario!["movimiento"]
                                    ?.toString() ==
                                "ENTRADA"
                            ? Colors.green
                            : Colors.orange,
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                                  15),
                          child: Center(
                            child: Text(
                              usuario![
                                          "movimiento"]
                                      ?.toString() ??
                                  "",
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 22,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Card(
                        child: ListTile(
                          leading:
                              const Icon(
                            Icons.badge,
                          ),
                          title:
                              const Text(
                            "Número de Control",
                          ),
                          subtitle:
                              Text(
                            usuario![
                                        "numeroControl"]
                                    ?.toString() ??
                                "",
                          ),
                        ),
                      ),

                      Card(
                        child: ListTile(
                          leading:
                              const Icon(
                            Icons.school,
                          ),
                          title:
                              const Text(
                            "Área / Carrera",
                          ),
                          subtitle:
                              Text(
                            usuario!["area"]
                                    ?.toString() ??
                                "",
                          ),
                        ),
                      ),

                      Card(
                        child: ListTile(
                          leading:
                              const Icon(
                            Icons.calendar_month,
                          ),
                          title:
                              const Text(
                            "Vigencia",
                          ),
                          subtitle:
                              Text(
                            usuario![
                                        "fechaVigencia"]
                                    ?.toString() ??
                                "",
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets
                                .all(20),
                        decoration:
                            BoxDecoration(
                          color:
                              usuario![
                                      "activo"] ==
                                  true
                              ? Colors.green
                              : Colors.red,
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      15),
                        ),
                        child: Text(
                          usuario![
                                      "activo"] ==
                                  true
                              ? "ACTIVO"
                              : "INACTIVO",
                          textAlign:
                              TextAlign.center,
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Regresando al escáner en 5 segundos...",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Card(
                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .all(12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Text(
                                "Datos recibidos de API",
                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                              const SizedBox(
                                  height: 10),
                              Text(
                                usuario.toString(),
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
  @override
void dispose() {
  player.dispose();
  super.dispose();
}
}