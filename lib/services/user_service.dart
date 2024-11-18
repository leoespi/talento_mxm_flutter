import 'dart:convert';
import 'package:talento_mxm_flutter/views/perfil.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<UserData> obtenerUsuarios(String token) async {
    
    //url usuarios
    final url = 'http://10.0.2.2:8000/api/get/user';


   //url prueba Celular por cable (SOLO SE USA PARA CARGAR EL PROYECTO EN EL CELULAR POR CABLE)
     //final  url = 'http://192.168.1.148:8000/api/get/user';
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
          cedula: data["cedula"].toString(), 
          email: data["email"],
          p_venta: data["p_venta"],
          cargo: data["cargo"]
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


   // Método para solicitar el PIN de restablecimiento
  static Future<bool> requestResetPin(String email) async {
    //url prueba Celular por cable (SOLO SE USA PARA CARGAR EL PROYECTO EN EL CELULAR POR CABLE)
    //final url = 'http://192.168.1.148:8000/api/password/forgot';

    final url = 'http://10.0.2.2:8000/api/password/forgot';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'email': email});

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        return true; // PIN enviado correctamente
      } else {
        throw Exception('Error al solicitar el PIN: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Método para restablecer la contraseña usando el PIN
  static Future<bool> resetPasswordWithPin(String email, String pin, String newPassword) async {
      //url prueba Celular por cable (SOLO SE USA PARA CARGAR EL PROYECTO EN EL CELULAR POR CABLE)
     //final url = 'http://192.168.1.148:8000/api/password/reset';
     
    final url = 'http://10.0.2.2:8000/api/password/reset';
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'email': email,
      'pin': pin,
      'new_password': newPassword,
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        return true; // Contraseña restablecida correctamente
      } else {
        throw Exception('Error al restablecer la contraseña: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
