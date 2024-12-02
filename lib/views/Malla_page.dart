import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:talento_mxm_flutter/controllers/Malla_controller.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart';

import 'package:get/get.dart';

class CrearMallaScreen extends StatefulWidget {
  @override
  _CrearMallaScreenState createState() => _CrearMallaScreenState();
}

class _CrearMallaScreenState extends State<CrearMallaScreen> {
  final MallaController _mallaController = Get.put(MallaController());

  // Controladores para los campos de texto
  final TextEditingController _procesoController = TextEditingController();
  final TextEditingController _pVentaController = TextEditingController();
  File? _documento;

  // Opciones para los dropdowns
  final List<String> procesoOptions = [
    'Administrador de Tienda', 
    'Líder de Tienda', 
    'Auxiliar de Servicio al Cliente',
    'Auxiliar de Recibo', 
    'Vendedor - Puesto de Pago', 
    'Vendedor - Surtido',
    'Vendedor - Servicio', 
    'Vendedor - Recibo'
  ];

  final List<String> pVentaOptions = [
    '01 - COMERCIO', '02 - FLORIDABLANCA', '03 - SAN FRANCISCO', 
    '04 - COLOMBIA', '05 - PROVENZA', '06 - BUCARICA', '07 - K-27', 
    '08 - RUITOQUE', '09 - CIUDADELA', '10 - PIEDECUESTA', '11 - CABECERA',
    '12 - GIRON', '13 - COLTABACO', '14 - GUARIN', '15 - CARACOLI', 
    '16 - LA ROSITA', '17 - LA FLORESTA', '18 - GAIRA', '19 - POBLADO', 
    '20 - LA NOVENA', '21 - SOLERI', '22 - CUMBRE', '23 - PUERTA DEL SOL', 
    '24 - LA 200'
  ];

  String? _selectedProceso;
  String? _selectedPVenta;

  // Método para seleccionar el archivo con FilePicker
  Future<void> _pickFile() async {
    // Usar FilePicker para seleccionar un archivo
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _documento = File(result.files.single.path!); // Asignar el archivo seleccionado
      });
    } else {
      // Si el usuario cancela la selección de archivo, no pasa nada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se seleccionó ningún archivo')),
      );
    }
  }

  // Método para enviar el formulario
  Future<void> _submit() async {
    int? userId = 1; // Suponiendo que el ID del usuario es 1, o lo obtienes desde GetStorage

    // Llamamos al método del controlador para crear la malla
    await _mallaController.createMalla(
      userId: userId,
      proceso: _selectedProceso,
      pVenta: _selectedPVenta,
      documento: _documento,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        title: Text('Mallas', style: TextStyle(color: Colors.white)),
      ),
       drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Dropdown para seleccionar el proceso
            DropdownButtonFormField<String>(
              value: _selectedProceso,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProceso = newValue!;
                });
              },
              items: procesoOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Proceso'),
            ),
            SizedBox(height: 10),
            
            // Dropdown para seleccionar el precio de venta
            DropdownButtonFormField<String>(
              value: _selectedPVenta,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPVenta = newValue!;
                });
              },
              items: pVentaOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Precio de Venta'),
            ),
            SizedBox(height: 20),
            
            // Botón para seleccionar el archivo
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Seleccionar Documento'),
            ),
            SizedBox(height: 20),
            
            // Muestra el nombre del archivo seleccionado
            if (_documento != null)
              Text('Archivo seleccionado: ${_documento!.path.split('/').last}'),
            SizedBox(height: 20),
            
            // Botón para enviar el formulario
            ElevatedButton(
              onPressed: _submit,
              child: Text('Crear Malla'),
            ),
          ],
        ),
      ),
    );
  }
}
