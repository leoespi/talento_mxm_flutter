import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talento_mxm_flutter/models/registros_model.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Cesantia>> fetchCesantias() async {
    final token = _getToken();
    final response = await _getRequest('$baseUrl/indexcesantias', token);

    final List<dynamic> data = json.decode(response.body)['cesantias'];
    return data.map((item) => Cesantia.fromJson(item)).toList();
  }

  Future<List<Incapacidad>> fetchIncapacidades() async {
  final token = _getToken();
  final response = await _getRequest('$baseUrl/indexincapacidades', token);

  print('Response body: ${response.body}'); // Agregar esto para ver la respuesta

  final List<dynamic> data = json.decode(response.body)['incapacidades'];
  return data.map((item) => Incapacidad.fromJson(item)).toList();
}

  String? _getToken() {
    final box = GetStorage();
    return box.read('token');
  }

  Future<http.Response> _getRequest(String url, String? token) async {
    Map<String, String>? headers;
    if (token != null) {
      headers = {
        'Authorization': 'Bearer $token',
      };
    }
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      print('Error: ${response.body}');
      throw Exception('Failed to load data: ${response.body}');
    }
    return response;
  }
}
