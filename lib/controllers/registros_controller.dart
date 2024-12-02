import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:talento_mxm_flutter/models/registros_model.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

   //url prueba Celular por cable (SOLO SE USA PARA CARGAR EL PROYECTO EN EL CELULAR POR CABLE)
  //final String baseUrl = 'http://192.168.1.148:8000/api';


  // Obtiene la lista de cesantías
  Future<List<Cesantia>> fetchCesantias() async {
  final token = _getToken();
  final response = await _getRequest('$baseUrl/indexcesantias', token);

  if (response.body.isEmpty) {
    throw Exception('Respuesta vacía desde el servidor');
  }

  try {
    final decodedResponse = json.decode(response.body);

    // Comprobamos si la respuesta tiene el formato esperado
    if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('cesantias')) {
      final List<dynamic> data = decodedResponse['cesantias'];
      return data.map((item) => Cesantia.fromJson(item)).toList();
    } else {
      throw Exception('Formato de respuesta inválido: No contiene "cesantias"');
    }
  } catch (e) {
    print('Error al parsear JSON de Cesantías: $e');
    throw Exception('Error al cargar cesantías: $e');
  }
}


  // Obtiene la lista de incapacidades
  Future<List<Incapacidad>> fetchIncapacidades() async {
  final token = _getToken();

  if (token == null) {
    throw Exception('Token nulo. Por favor, inicie sesión nuevamente.');
  }

  final response = await _getRequest('$baseUrl/indexincapacidades', token);

  if (response.body.isEmpty) {
    throw Exception('Respuesta vacía desde el servidor');
  }

  try {
    print('Respuesta del servidor: ${response.body}'); // Imprimir la respuesta completa
    final decodedResponse = json.decode(response.body);

    if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('incapacidades')) {
      final List<dynamic> data = decodedResponse['incapacidades'];
      return data.map((item) => Incapacidad.fromJson(item)).toList();
    } else {
      throw Exception('Formato de respuesta inválido: No contiene "incapacidades"');
    }
  } catch (e) {
    print('Error al parsear JSON de Incapacidades: $e');
    throw Exception('Error al cargar incapacidades: $e');
  }
}

Future<List<Solicitud>> fetchpermisos()  async {
  final token = _getToken();
  final response = await _getRequest('$baseUrl/indexpermisos', token);

  if(response.body.isEmpty){
    throw Exception('Respuesta vacía desde el servidor');
  }

  try {
    final decodedResponse = json.decode(response.body);

    if(decodedResponse is Map <String,  dynamic> && decodedResponse.containsKey('permisos')){
      final List<dynamic> data = decodedResponse ['permisos'];
      return data.map((item) => Solicitud.fromJson(item)).toList();
    }else{
      throw Exception('Formato de respuesta inválido: No contiene "permisos"');
    }


  }catch(e) {
    print('Error al parsear JSON de Solicitudes: $e');
    throw Exception('Error al cargar solicitudes: $e');
  }

}


Future<List<Malla>> fetchmallas() async {
  final token = _getToken();
  final response = await _getRequest('$baseUrl/indexmallas', token);

  if (response.body.isEmpty) {
    throw Exception('Respuesta vacía desde el servidor');
  }

 try {
  final decodedResponse = json.decode(response.body);

  // Verifica si la respuesta contiene la clave "mallas" de la forma que esperas
  if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data') && decodedResponse['data'].containsKey('mallas')) {
    final mallasData = decodedResponse['data']['malla'];
    return mallasData.map((item) => Malla.fromJson(item)).toList();
  } else {
    throw Exception('Formato de respuesta inválido: No contiene "data" o "mallas"');
  }
} catch (e) {
  print('Error al parsear JSON de Mallas: $e');
  throw Exception('Error al cargar mallas: $e');
}

}









  // Obtiene el token de almacenamiento
  String? _getToken() {
    final box = GetStorage();
    return box.read('token');
  }

  // Realiza una solicitud GET a la API
  Future<http.Response> _getRequest(String url, String? token) async {
    Map<String, String>? headers;

    if (token != null) {
      headers = {
        'Authorization': 'Bearer $token',
      };
    }

    final response = await http.get(Uri.parse(url), headers: headers);

    // Verificar si el estado es diferente de 200 (OK)
    if (response.statusCode != 200) {
      print('Error en solicitud GET: ${response.body}');
      throw Exception('No se pudo cargar los datos: ${response.body}');
    }

    return response;
  }
}