import 'dart:convert';
import 'package:talento_mxm_flutter/models/publicacion_model.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class FeedController {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  static Future<List<Publicacion>> obtenerFeeds(int offset, int limit) async {
    try {
      final box = GetStorage();
      String? token = box.read('token');

      final response = await http.get(
        Uri.parse('$baseUrl/feeds?order=desc&offset=$offset&limit=$limit'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['feeds'];
        List<Publicacion> feeds = [];

        for (var item in data) {
          feeds.add(Publicacion.fromJson(item));
        }

        // Ordenar los feeds por id de manera descendente (como un entero)
        feeds.sort((a, b) => b.id.compareTo(a.id));

        return feeds;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
