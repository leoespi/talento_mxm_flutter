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
        title: Text('Menú Demostrativo'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(), // Llama al método de logout sin argumentos
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyForm()), // Reemplaza IncapacidadesPage con el nombre de tu clase de la página de incapacidades
                );
              },
              child: Column(
                children: [
                  Icon(Icons.article), // Icono de la opción
                  SizedBox(height: 8),
                  Text('Incapacidades'), // Texto de la opción
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Agrega aquí la lógica para la otra opción del menú
              },
              child: Column(
                children: [
                  Icon(Icons.quiz), // Icono de la opción
                  SizedBox(height: 8),
                  Text('Otra opción'), // Texto de la opción
                ],
              ),
            ),
            SizedBox(height: 20),
            // Agrega más opciones del menú según sea necesario
          ],
        ),
      ),
    );
  }
}
