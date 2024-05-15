import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importa la biblioteca Get

import 'views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Usa GetMaterialApp en lugar de MaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Talento MxM',
      home: LoginPage(),
    );
  }
}
