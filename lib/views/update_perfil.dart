import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';  // Para acceder al almacenamiento local del token

class UpdateUserForm extends StatefulWidget {
  @override
  _UpdateUserFormState createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pVentaController = TextEditingController();
  TextEditingController _cargoController = TextEditingController();

  // Función para actualizar los datos del usuario
  Future<void> _updateUser() async {
    final storage = GetStorage();
    String token = storage.read('token') ?? ''; // Recuperar el token almacenado

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token no encontrado. Inicia sesión nuevamente.'))
      );
      return;
    }

    final url = 'http://10.0.2.2:8000/api/user'; // Cambia la URL a la correcta

    // Agregar el token al encabezado de la solicitud
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Agregar el token de autenticación aquí
      },
      body: json.encode({
        'email': _emailController.text,
        'p_venta': _pVentaController.text,
        'cargo': _cargoController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Si la actualización es exitosa, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuario actualizado con éxito')));

      // Regresar a la página de perfil después de actualizar
      Navigator.pop(context);
    } else {
      // Si falla la actualización, muestra un error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el usuario')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),// Color de fondo de la AppBar
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Título principal
              Text(
                'Actualiza tu información de usuario',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 13, 121),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Campo para el correo electrónico
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 5, 13, 121)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 13, 121)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 13, 121)),
                  ),
                ),
                maxLength: 255,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Correo electrónico no válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Campo para la P.Venta
              TextFormField(
                controller: _pVentaController,
                decoration: InputDecoration(
                  labelText: 'P.Venta',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 5, 13, 121)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 13, 121)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 13, 121)),
                  ),
                ),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Campo para el cargo
              TextFormField(
                controller: _cargoController,
                decoration: InputDecoration(
                  labelText: 'Cargo',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 5, 13, 121)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 13, 121)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 5, 13, 121)),
                  ),
                ),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),

              // Botón de actualización
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateUser();
                  }
                },
                child: Text('Actualizar', style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 5, 13, 121), // Color del botón
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
