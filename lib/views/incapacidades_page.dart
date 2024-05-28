import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/controllers/incapacidades_controller.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/views/perfil.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _diasIncapacidadController = TextEditingController();
  String? _selectedEntidadAfiliada;
  String? _selectedtipoincapacidadreportada;
  DateTime _fechaInicio = DateTime.now();
  File? _image;
  bool _isLoading = false;

  final IncapacidadesController _controller = Get.put(IncapacidadesController());

  // Función para seleccionar una fecha 
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fechaInicio) {
      setState(() {
        _fechaInicio = picked;
      });
    }
  }

  // Función para obtener una imagen de la galería
  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  
  // Función para enviar el formulario
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _controller.createIncapacidad(
        tipoincapacidadreportada: _selectedtipoincapacidadreportada!,
        diasIncapacidad: int.parse(_diasIncapacidadController.text),
        fechaInicioIncapacidad: _fechaInicio,
        entidadAfiliada: _selectedEntidadAfiliada!,
        imagePath: _image!.path,
      );

      // Redirige al usuario al menú después de enviar la incapacidad
      Get.offAll(() => MenuPage());

    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para mostrar un diálogo de confirmación antes de enviar el formulario
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que deseas enviar este formulario? En caso de que los datos no coincidan, la incapacidad será eliminada y será necesario volver a subirla. Se te notificará a través del correo electrónico registrado en el sistema en caso de enviar incorrectamente el formulario.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Enviar'),
              onPressed: () {
                Navigator.of(context).pop();
                _submitForm();
              },
            ),
          ],
        );
      },
    );
  }

  //Formulario Incapacidades 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Transform.translate(
          offset: Offset(0.0, 25.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Formulario de Incapacidades',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedtipoincapacidadreportada,
                      items: const [
                        DropdownMenuItem(
                          value: 'Incapacidad por Enfermedad General',
                          child: Text('Incapacidad por Enfermedad General'),
                        ),
                        DropdownMenuItem(
                          value: 'Incapacidad por Accidente de Transito',
                          child: Text('Incapacidad por Accidente de Transito'),
                        ),
                         DropdownMenuItem(
                          value: 'Licencia Por Maternidad',
                          child: Text('Licencia Por Maternidad'),
                        ),
                        DropdownMenuItem(
                          value: 'Licencia Por Paternidad',
                          child: Text('Licencia Por Paternidad'),
                        ),
                         DropdownMenuItem(
                          value: 'Licencia Por Luto',
                          child: Text('Licencia Por Luto'),
                        ),
                        
                       
                       
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedtipoincapacidadreportada = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Tipo de Incapacidad',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona el tipo de Incapacidad';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _diasIncapacidadController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Días de Incapacidad',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Por favor ingresa los días de incapacidad';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Fecha de Inicio de la Incapacidad:'),
                      subtitle: Text('${_fechaInicio.toLocal()}'.split(' ')[0]),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedEntidadAfiliada,
                      items: const [
                        DropdownMenuItem(
                          value: 'Nueva EPS',
                          child: Text('Nueva EPS'),
                        ),
                        DropdownMenuItem(
                          value: 'Salud Total',
                          child: Text('Salud Total'),
                        ),
                        DropdownMenuItem(
                          value: 'Eps Sura',
                          child: Text('Eps Sura'),
                        ),
                        DropdownMenuItem(
                          value: 'Eps Sanitas',
                          child: Text('Eps Sanitas'),
                        ),
                        DropdownMenuItem(
                          value: 'Compensar',
                          child: Text('Compensar'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedEntidadAfiliada = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Entidad Afiliada',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona la entidad afiliada';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _getImage();
                },
                child: Text('Seleccionar Imagen'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              if (_image != null)
                Column(
                  children: [
                    Text(
                      'Imagen seleccionada:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Image.file(_image!),
                  ],
                ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _showConfirmationDialog(),
                      child: _isLoading ? CircularProgressIndicator() : Text('Enviar'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // Barra de navegación
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -5.0),
        child: Container(
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
          child: Padding(
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
                              begin: Offset(0.0, 1.0),
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
        ),
      ),
    );
  }


  // menu items
  Widget _buildBottomMenuItem({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required String label,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
