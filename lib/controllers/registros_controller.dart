import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talento_mxm_flutter/models/registros_model.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  /// Obtiene la lista de cesantías
  Future<List<Cesantia>> fetchCesantias() async {
    final token = _getToken(); // Obtiene el token de almacenamiento
    final response = await _getRequest('$baseUrl/indexcesantias', token); // Realiza la solicitud

    print('Response body: ${response.body}'); // Imprimir respuesta para depuración
    final List<dynamic> data = json.decode(response.body)['cesantias']; // Decodifica la respuesta
    return data.map((item) => Cesantia.fromJson(item)).toList(); // Convierte a lista de objetos Cesantia
  }

  /// Obtiene la lista de incapacidades
  Future<List<Incapacidad>> fetchIncapacidades() async {
    final token = _getToken(); // Obtiene el token de almacenamiento
    final response = await _getRequest('$baseUrl/indexincapacidades', token); // Realiza la solicitud

    print('Response body: ${response.body}'); // Imprimir respuesta para depuración
    final List<dynamic> data = json.decode(response.body)['incapacidades']; // Decodifica la respuesta
    return data.map((item) => Incapacidad.fromJson(item)).toList(); // Convierte a lista de objetos Incapacidad
  }

  /// Obtiene el token de almacenamiento
  String? _getToken() {
    final box = GetStorage();
    return box.read('token'); // Retorna el token guardado
  }

  /// Realiza una solicitud GET a la API
  Future<http.Response> _getRequest(String url, String? token) async {
    Map<String, String>? headers;
    if (token != null) {
      headers = {
        'Authorization': 'Bearer $token', // Añade encabezado de autorización si el token está presente
      };
    }
    
    // Realiza la solicitud GET
    final response = await http.get(Uri.parse(url), headers: headers);

    // Manejo de errores
    if (response.statusCode != 200) {
      print('Error: ${response.body}'); // Imprimir cuerpo de error para depuración
      throw Exception('Failed to load data: ${response.body}'); // Lanza excepción si la solicitud falla
    }
    return response; // Retorna la respuesta exitosa
  }
}
