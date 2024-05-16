import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart'; // Asegúrate de importar el archivo donde tienes la página de incapacidades

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Demostrativo'),
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
              child: Text('Incapacidades'), // Cambia el texto según la opción que quieras
            ),
            SizedBox(height: 20),
           
          ],
        ),
      ),
    );
  }
}
