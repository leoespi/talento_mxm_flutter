import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talento_mxm_flutter/controllers/crearReferido_controller.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart'; // Asegúrate de importar el nuevo widget



class CrearReferidoScreen extends StatefulWidget {
  @override
  _CrearReferidoScreenState createState() => _CrearReferidoScreenState();
}

class _CrearReferidoScreenState extends State<CrearReferidoScreen> {
  final ReferidosController _controller = Get.put(ReferidosController());
  File? selectedFile;
  
  String? selectedFileName; // Variable para almacenar el nombre del archivo seleccionado

  void _seleccionarArchivo(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File selected = File(pickedFile.path);
      if (pickedFile.path.toLowerCase().endsWith('.pdf')) {
        setState(() {
          selectedFile = selected;
          selectedFileName = selectedFile!.path.split('/').last; // Obtener el nombre del archivo
        });
      } else {
        showDialog(
          context: context,
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

  

  Future<void> _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se pudo abrir la URL: $url';
  }
}


  @override
  Widget build(BuildContext context) {
     return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 5, 13, 121),
      title: Text(''),
      actions: [  ],
    ),
     drawer: SideMenu(),
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
              selectedFileName != null
                  ? Column(
                      children: [
                        Image.asset(
                          'assets/pdf_icon.png', // Aquí colocas la ruta relativa desde 'lib'
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
                  : SizedBox.shrink(), // Mostrar el nombre del archivo seleccionado si hay uno
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _seleccionarArchivo(context),
                child: Text('Seleccionar Archivo PDF'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (selectedFile != null) {
                    _controller.createReferido(
                      documento: selectedFile!,
                      context: context,
                    );
                  } else {
                    showDialog(
                      context: context,
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
        ),
      ),
     
    );
  }

  Widget _buildBottomMenuItem({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required String label,
  }) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            color: color,
            iconSize: 30.0,
          ),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
  
}
