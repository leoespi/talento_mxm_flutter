import 'dart:convert';

import 'package:talento_mxm_flutter/models/publicacion_model.dart';
import 'package:http/http.dart' as http;

class FeedController {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Reemplaza con la URL de tu backend

  static Future<List<Publicacion>> obtenerFeeds() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/feeds'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['feeds'];
        List<Publicacion> feeds = data.map((json) => Publicacion.fromJson(json)).toList();
        return feeds;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
