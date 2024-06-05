import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/io_client.dart';

class IncapacidadesController extends GetxController {
  final box = GetStorage();
  final url = 'http://10.0.2.2:8000/api/';

  Future<void> createIncapacidad({
    required String tipoincapacidadreportada,
    required int diasIncapacidad,
    required DateTime fechaInicioIncapacidad,
    required String entidadAfiliada,
    required List<File> images,
    required List<String> imagePaths,
  }) async {
    try {
      int? userId = box.read('user_id'); // Asegúrate de que userId sea leído correctamente
      String? token = box.read('token'); // Asegúrate de que token sea leído correctamente

      if (userId == null) {
        print('Error: user_id is null');
        return;
      }

      var client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      var ioClient = IOClient(client);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}incapacidades'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields.addAll({
        'user_id': '$userId', // Cambia 'userId' a 'user_id' para que coincida con el backend
        'tipoincapacidadreportada': tipoincapacidadreportada,
        'diasIncapacidad': '$diasIncapacidad',
        'fechaInicioIncapacidad': '${fechaInicioIncapacidad.toIso8601String()}',
        'entidadAfiliada': entidadAfiliada,
      });

      for (int i = 0; i < images.length; i++) {
        var image = images[i];
        var imagePath = imagePaths[i];
        request.files.add(await http.MultipartFile.fromPath('images[$i]', imagePath));
      }

      var response = await ioClient.send(request);
      if (response.statusCode == 200) {
        print('Incapacidad creada exitosamente');
      } else {
        print('Error al crear la incapacidad. Código de estado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
