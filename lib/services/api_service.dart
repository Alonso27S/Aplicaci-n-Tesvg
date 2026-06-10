import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {

  static Future<Map<String, dynamic>>
      verificarQR(String qr) async {

    print("================================");
    print("ENVIANDO A API:");
    print(qr);
    print("================================");

    final response = await http.post(

      Uri.parse(
        "https://credencialestesvg.com.mx/api/verificar-credencial"
      ),

      headers: {

        "Content-Type":
            "application/json"
      },

      body: jsonEncode({

        "qr": qr

      }),
    );

    print("================================");
    print("STATUS:");
    print(response.statusCode);

    print("BODY:");
    print(response.body);
    print("================================");

    return jsonDecode(response.body);
  }
}