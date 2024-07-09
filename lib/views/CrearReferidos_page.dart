import 'dart:io';
import 'package:flutter/material.dart';  // Asegúrate de importar desde flutter/material.dart
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:talento_mxm_flutter/controllers/crearReferido_controller.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';



class CrearReferidoScreen extends StatelessWidget {
  final AuthenticationController _authController = AuthenticationController();
  final ReferidosController _controller = Get.put(ReferidosController());
  final TextEditingController tipoCargoController = TextEditingController();
  File? selectedFile;

  // Función para cerrar sesión
  void logout() {
    _authController.logout(); // Lógica para cerrar sesión
    // Navegar a la pantalla de inicio de sesión, por ejemplo:
    Navigator.pushReplacement(
      context as BuildContext,
      MaterialPageRoute(builder: (context) => LoginPage()), // Reemplazar LoginPage con tu página de inicio de sesión
    );
  }

  

  void _seleccionarArchivo(BuildContext context) async {  // Asegúrate de pasar BuildContext aquí
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File selected = File(pickedFile.path);
      // Verificar que el archivo seleccionado sea un PDF
      if (pickedFile.path.toLowerCase().endsWith('.pdf')) {
        selectedFile = selected;
      } else {
        showDialog(
          context: context,  // Aquí también asegúrate de usar BuildContext
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text('Seleccione un archivo PDF válido.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        title: Text(''),
        actions: [
          IconButton(

           onPressed: logout,
           icon: Icon(Icons.logout),
           color: Colors.white,
          ),

        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: tipoCargoController,
              decoration: InputDecoration(labelText: 'Tipo de Cargo'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _seleccionarArchivo(context),  // Asegúrate de pasar BuildContext aquí también
              child: Text('Seleccionar Archivo PDF'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (selectedFile != null) {
                  _controller.createReferido(
                    tipoCargo: tipoCargoController.text,
                    documento: selectedFile!,
                    context: context,
                  );
                } else {
                  showDialog(
                    context: context,  // Y aquí también
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Seleccione un archivo PDF primero.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Crear Referido'),
            ),
          ],
        ),
      ),
    );
  }
}
