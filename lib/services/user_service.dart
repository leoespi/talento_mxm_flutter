import 'dart:convert';
import 'package:talento_mxm_flutter/views/perfil.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<UserData> obtenerUsuarios(String token) async {
    final url = 'http://10.0.2.2:8000/api/get/user';
    var headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // La solicitud fue exitosa, imprime los datos recibidos
        final data = json.decode(response.body);
        print(data); // Agrega esto para ver la estructura de los datos

        return UserData(
          name: data["name"],
          cedula: data["cedula"].toString(), // Asegúrate de convertir a String si es necesario
          email: data["email"],
        );
      } else {
        // La solicitud falló, maneja el error de otra manera
        throw Exception('Error al obtener usuarios: ${response.statusCode}');
      }
    } catch (e) {
      // Error de conexión u otro error
      throw Exception('Error: $e');
    }
  }

  static actualizarUsuario(token, Map<String, String> map) {}
}
