import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart'; 
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:get/get.dart';

class MenuPage extends StatelessWidget {
  final AuthenticationController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyForm()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue, // Cambia el color de fondo según el diseño
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.article, color: Colors.white), // Icono de la opción
                    SizedBox(width: 20),
                    Text(
                      'Incapacidades', // Texto de la opción
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Agrega aquí la lógica para la otra opción del menú
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.green, // Cambia el color de fondo según el diseño
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.quiz, color: Colors.white), // Icono de la opción
                    SizedBox(width: 20),
                    Text(
                      'Otra opción', // Texto de la opción
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Agrega aquí la lógica para la opción de perfil
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.orange, // Cambia el color de fondo según el diseño
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.white), // Icono de la opción
                    SizedBox(width: 20),
                    Text(
                      'Perfil', // Texto de la opción
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
