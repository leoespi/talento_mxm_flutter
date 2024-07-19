import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/io_client.dart';
import 'package:talento_mxm_flutter/models/publicacion_model.dart';



class PublicacionController {
  static const String apiUrl = 'http://10.0.2.2:8000/api/publicacion'; // Reemplaza con la URL de tu API

  Future<List<Publicacion>> fetchPublicaciones() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body)['publicacion'];
      return responseData.map((item) => Publicacion.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar las publicaciones');
    }
  }
}