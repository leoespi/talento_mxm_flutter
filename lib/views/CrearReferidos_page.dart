import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talento_mxm_flutter/controllers/crearReferido_controller.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart';
import 'package:talento_mxm_flutter/views/CrearReferidos_page.dart';
import 'package:talento_mxm_flutter/views/cesantias_page.dart';
import 'package:talento_mxm_flutter/views/perfil.dart';
import 'package:talento_mxm_flutter/views/menu.dart';

class CrearReferidoScreen extends StatefulWidget {
  @override
  _CrearReferidoScreenState createState() => _CrearReferidoScreenState();
}

class _CrearReferidoScreenState extends State<CrearReferidoScreen> {
  final AuthenticationController _authController = AuthenticationController();
  final ReferidosController _controller = Get.put(ReferidosController());
  File? selectedFile;
  bool _isExpanded = false;
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

  void logout() {
    _authController.logout(); // Lógica para cerrar sesión
    // Navegar a la pantalla de inicio de sesión, por ejemplo:
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Reemplazar LoginPage con tu página de inicio de sesión
    );
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
                    ? Text(
                        selectedFileName!,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                         // Aquí puedes enviar cualquier dato adicional si es necesario
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomMenuItem(
                    icon: Icons.article,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 250),
                          transitionsBuilder: (context, animation, _, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                          pageBuilder: (context, _, __) => MyForm(),
                        ),
                      );
                    },
                    color: Colors.blue,
                    label: 'Incapacidad',
                  ),
                  _buildBottomMenuItem(
                    icon: Icons.home,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 250),
                          transitionsBuilder: (context, animation, _, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                          pageBuilder: (context, _, __) => MenuPage(),
                        ),
                      );
                    },
                    color: Colors.green,
                    label: 'Inicio',
                  ),
                  _buildBottomMenuItem(
                    icon: Icons.person,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 250),
                          transitionsBuilder: (context, animation, _, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                          pageBuilder: (context, _, __) => ProfileScreen(userId: ''),
                        ),
                      );
                    },
                    color: Colors.orange,
                    label: 'Perfil',
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomMenuItem(
                      icon: Icons.document_scanner,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 250),
                            transitionsBuilder: (context, animation, _, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                            pageBuilder: (context, _, __) => MyCesantiaspage(),
                          ),
                        );
                      },
                      color: Colors.red,
                      label: 'Cesantias',
                    ),
                    _buildBottomMenuItem(
                      icon: Icons.document_scanner,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 250),
                            transitionsBuilder: (context, animation, _, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                            pageBuilder: (context, _, __) => CrearReferidoScreen(),
                          ),
                        );
                      },
                      color: const Color.fromARGB(255, 73, 54, 244),
                      label: 'P. Referidos',
                    ),
                    _buildBottomMenuItem(
                      icon: Icons.settings,
                      onPressed: () {
                        // Acción para la nueva opción 3
                      },
                      color: const Color.fromARGB(255, 58, 58, 58),
                      label: 'Configuración',
                    ),
                  ],
                ),
              ),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
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
