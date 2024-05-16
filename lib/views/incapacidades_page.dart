import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Flutter',
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
  DateTime _fechaInicio = DateTime.now();
  late File? _image;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
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
        title: Text('Formulario de Datos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _diasIncapacidadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Días de Incapacidad',
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
                title: Text('Fecha de Inicio de la Incapacidad:'),
                subtitle: Text('${_fechaInicio.toLocal()}'.split(' ')[0]),
                onTap: () {
                  _selectDate(context);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _getImage();
                },
                child: Text('Seleccionar Imagen de la Galería'),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      print('Días de Incapacidad: ${_diasIncapacidadController.text}');
                      print('Fecha de Inicio de la Incapacidad: $_fechaInicio');
                      print('Imagen seleccionada: $_image');
                    }
                  },
                  child: Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
