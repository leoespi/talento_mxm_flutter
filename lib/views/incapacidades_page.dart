import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  DateTime _fechaInicio = DateTime.now();
  File? _image;

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

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
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
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        print('Días de Incapacidad: ${_diasIncapacidadController.text}');
                        print('Fecha de Inicio de la Incapacidad: $_fechaInicio');
                        print('Entidad Afiliada: $_selectedEntidadAfiliada');
                        print('Imagen seleccionada: $_image');
                      }
                    },
                    child: Text('Enviar'),
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
    );
  }
}
