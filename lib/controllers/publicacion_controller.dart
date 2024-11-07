import 'dart:convert';
import 'package:talento_mxm_flutter/models/publicacion_model.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class FeedController {
  // URL base de la API
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
   //url prueba Celular por cable (SOLO SE USA PARA CARGAR EL PROYECTO EN EL CELULAR POR CABLE)
   //static const  baseUrl = 'http://192.168.1.148:8000/api';

  
  /// Obtiene una lista de publicaciones desde el feed
  /// 
  /// Parámetros:
  /// - [offset]: La cantidad de publicaciones a omitir.
  /// - [limit]: La cantidad máxima de publicaciones a obtener.
  /// 
  /// Retorna una lista de objetos [Publicacion].
  /// 
  static Future<List<Publicacion>> obtenerFeeds(int offset, int limit) async {
    try {
      final box = GetStorage(); // Instancia de almacenamiento local
      String? token = box.read('token'); // Recupera el token de autenticación

      // Realiza la solicitud GET para obtener los feeds
      final response = await http.get(
        Uri.parse('$baseUrl/feeds?order=desc&offset=$offset&limit=$limit'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      // Verifica si la solicitud fue exitosa
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['feeds'];
        List<Publicacion> feeds = [];

        // Convierte cada item en la lista de feeds a un objeto Publicacion
        for (var item in data) {
          feeds.add(Publicacion.fromJson(item));
        }

        // Ordena los feeds por id de manera descendente
        feeds.sort((a, b) => b.id.compareTo(a.id));

        return feeds; // Retorna la lista de publicaciones
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}'); // Lanza excepción si la solicitud falla
      }
    } catch (e) {
      throw Exception('Error de conexión: $e'); // Lanza excepción en caso de error de conexión
    }
  }
}
