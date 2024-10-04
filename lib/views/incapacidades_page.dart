import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/controllers/incapacidades_controller.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:image/image.dart' as img;
import 'package:talento_mxm_flutter/views/bottom_menu.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final AuthenticationController _authController = AuthenticationController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _diasIncapacidadController = TextEditingController();
  
  String? _selectedEntidadAfiliada;
  String? _selectedtipoincapacidadreportada;
  DateTime _fechaInicio = DateTime.now();
  List<File> _images = [];
  bool _isLoading = false;

  final IncapacidadesController _controller = Get.put(IncapacidadesController());


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
      ),
      drawer: SideMenu(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildDropdownTipoincapacidad(),
                  SizedBox(height: 20),
                  _buildDocumentItem(_selectedtipoincapacidadreportada),
                  SizedBox(height: 20),
                  _buildDiasIncapacidadField(),
                  SizedBox(height: 20),
                  _buildFechaInicioField(),
                  SizedBox(height: 20),
                  _buildDropdownEntidadAfiliada(),
                  SizedBox(height: 20),
                  _buildSelectImagesButton(),
                  SizedBox(height: 20),
                  _buildSelectedImages(),
                  SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Método para seleccionar la fecha
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

  // Método para comprimir y redimensionar la imagen
  File compressAndResizeImage(File file) {
    img.Image? image = img.decodeImage(file.readAsBytesSync());

    int width;
    int height;

    if (image!.width > image.height) {
      width = 800;
      height = (image.height / image.width * 800).round();
    } else {
      height = 800;
      width = (image.width / image.height * 800).round();
    }

    img.Image resizedImage = img.copyResize(image, width: width, height: height);
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 80);
    
    File compressedFile = File(file.path.replaceFirst('.jpg', '_compressed.jpg'));
    compressedFile.writeAsBytesSync(compressedBytes);

    return compressedFile;
  }

  // Método para seleccionar imágenes
  void _getImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.clear();
        _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
        // Comprimir y redimensionar imágenes después de seleccionarlas
        _images = _images.map(compressAndResizeImage).toList();
      });
    }
  }

  // Método para enviar el formulario
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> imagePaths = _images.map((img) => img.path).toList();
      await _controller.createIncapacidad(
        tipoincapacidadreportada: _selectedtipoincapacidadreportada!,
        diasIncapacidad: int.parse(_diasIncapacidadController.text),
        fechaInicioIncapacidad: _fechaInicio,
        entidadAfiliada: _selectedEntidadAfiliada!,
        images: _images,
        imagePaths: imagePaths,
        context: context,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incapacidad creada con éxito')),
      );

      Get.offAll(() => MenuPage());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error. Por favor, inténtalo de nuevo.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para mostrar el diálogo de confirmación
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
                Text('¿Estás seguro de que deseas enviar este formulario?'),
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

 
  Widget _buildDropdownTipoincapacidad() {
    return DropdownButtonFormField<String>(
      value: _selectedtipoincapacidadreportada,
      items: const [
        DropdownMenuItem(value: 'Incapacidad por Enfermedad General', child: Text('Incapacidad por Enfermedad General')),
        DropdownMenuItem(value: 'Incapacidad por Accidente de Transito', child: Text('Incapacidad por Accidente de Transito')),
        DropdownMenuItem(value: 'Licencia Por Maternidad', child: Text('Licencia Por Maternidad')),
        DropdownMenuItem(value: 'Licencia Por Paternidad', child: Text('Licencia Por Paternidad')),
        DropdownMenuItem(value: 'Licencia Por Luto', child: Text('Licencia Por Luto')),
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
    );
  }

  Widget _buildDiasIncapacidadField() {
    return TextFormField(
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
    );
  }

  Widget _buildFechaInicioField() {
    return ListTile(
      title: Text('Fecha de Inicio de la Incapacidad:'),
      subtitle: Text('${_fechaInicio.toLocal()}'.split(' ')[0]),
      trailing: Icon(Icons.calendar_month),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildDocumentItem(String? selectedOption) {
    List<String> documents = [];

    switch (selectedOption) {
      case 'Incapacidad por Enfermedad General':
        documents.addAll(['- Incapacidad emitida por la EPS', '- Historia clínica']);
        break;
      case 'Incapacidad por Accidente de Transito':
        documents.addAll(['- Incapacidad emitida por la EPS', '- Historia clínica', '- Formulario Furips', '- Fotocopia del SOAT', '- Fotocopia de la Cedula']);
        break;
      case 'Licencia Por Maternidad':
        documents.addAll(['- Incapacidad emitida por la EPS', '- Epicrisis', '- Registro civil', '- Certificado de nacido vivo']);
        break;
      case 'Licencia Por Paternidad':
        documents.addAll(['- Transcripción de la licencia', '- Incapacidad emitida por la EPS', '- Epicrisis', '- Certificado de nacido vivo', '- Registro civil del hijo(a)', '- Fotocopia de la cédula del hijo(a)']);
        break;
      case 'Licencia Por Luto':
        documents.addAll(['- Incapacidad emitida por la EPS', '- Registro civil de defunción', '- Registro civil del hijo(a)', '- Fotocopia de la cédula del hijo(a)']);
        break;
      default:
        documents.add('- Seleccione un tipo de incapacidad para ver los documentos requeridos');
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: documents.map((doc) => Text(doc)).toList(),
    );
  }

  Widget _buildDropdownEntidadAfiliada() {
    return DropdownButtonFormField<String>(
      value: _selectedEntidadAfiliada,
      items: const [
        DropdownMenuItem(value: 'Nueva EPS', child: Text('Nueva EPS')),
        DropdownMenuItem(value: 'Salud Total', child: Text('Salud Total')),
        DropdownMenuItem(value: 'Eps Sura', child: Text('Eps Sura')),
        DropdownMenuItem(value: 'Eps Sanitas', child: Text('Eps Sanitas')),
        DropdownMenuItem(value: 'Compensar', child: Text('Compensar')),
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
    );
  }

  Widget _buildSelectImagesButton() {
    return ElevatedButton(
      onPressed: _getImages,
      child: Text('Seleccionar Imágenes'),
    );
  }

  Widget _buildSelectedImages() {
    return _images.isNotEmpty
        ? Wrap(
            spacing: 8.0,
            children: _images.map((image) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Image.file(image, fit: BoxFit.cover),
              );
            }).toList(),
          )
        : Text('No hay imágenes seleccionadas');
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _showConfirmationDialog,
      child: _isLoading ? CircularProgressIndicator() : Text('Enviar'),
    );
  }
}
