import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart'; // Importa file_picker
import 'package:talento_mxm_flutter/controllers/crearReferido_controller.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart'; // Asegúrate de importar el nuevo widget

class CrearReferidoScreen extends StatefulWidget {
  @override
  _CrearReferidoScreenState createState() => _CrearReferidoScreenState();
}

class _CrearReferidoScreenState extends State<CrearReferidoScreen> {
  final ReferidosController _controller = Get.put(ReferidosController());
  File? selectedFile; // Archivo seleccionado
  String? selectedFileName; // Nombre del archivo seleccionado

  // Método para seleccionar un archivo PDF
  void _seleccionarArchivo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Permitir solo archivos PDF
    );

    if (result != null && result.files.isNotEmpty) {
      File selected = File(result.files.single.path!);
      setState(() {
        selectedFile = selected;
        selectedFileName = result.files.single.name; // Obtener el nombre del archivo
      });
    } else {
      _showErrorDialog(context, 'Seleccione un archivo PDF válido.'); // Mensaje de error
    }
  }

  // Método para mostrar un diálogo de error
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(), // Cierra el diálogo
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Referidos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: SideMenu(), // Menú lateral
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Crear Referido',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                
                // Mostrar el nombre del archivo seleccionado o espacio vacío
                selectedFileName != null
                    ? Column(
                        children: [
                          Image.asset(
                            'assets/pdf_icon.png',
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            selectedFileName!,
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                    
                SizedBox(height: 20.0),
                
                // Botón para seleccionar un archivo PDF
                ElevatedButton(
                  onPressed: () => _seleccionarArchivo(context),
                  child: Text('Seleccionar Archivo PDF'),
                ),
                
                SizedBox(height: 20.0),
                
                // Botón para crear el referido
                ElevatedButton(
                  onPressed: () {
                    if (selectedFile != null) {
                      _controller.createReferido(
                        documento: selectedFile!,
                        context: context,
                      );
                    } else {
                      _showErrorDialog(context, 'Seleccione un archivo PDF primero.'); // Mensaje de error
                    }
                  },
                  child: Text('Crear Referido'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
