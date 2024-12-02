import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/controllers/incapacidades_controller.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:talento_mxm_flutter/views/bottom_menu.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

// La clase principal que ejecuta la aplicación
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyForm(),
    );
  }
}

// Widget principal que contiene el formulario
class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  // Controladores
  final AuthenticationController _authController = AuthenticationController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _diasIncapacidadController = TextEditingController();
  final TextEditingController _categoriaCodigoController = TextEditingController();

  // Variables para los campos del formulario
  String? _selectedEntidadAfiliada;
  String? _selectedTipoincapacidadReportada;
  DateTime _fechaInicio = DateTime.now();
  List<File> _images = [];
  List<File> _documents = [];
  bool _isCategoriaValida = true;
  bool _isLoading = false;
  String? _codigoCategoriaError;

  // Controlador de incapacidades
  final IncapacidadesController _controller = Get.put(IncapacidadesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        title: Text('Incapacidades', style: TextStyle(color: Colors.white)),
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
                  _buildDocumentItem(_selectedTipoincapacidadReportada),
                  SizedBox(height: 20),
                  _buildDiasIncapacidadField(),
                  SizedBox(height: 20),
                  _buildFechaInicioField(),
                  SizedBox(height: 20),
                  _buildDropdownEntidadAfiliada(),
                  SizedBox(height: 20),
                  _buildCategoriaCodigoField(),
                  SizedBox(height: 20),
                  _buildSelectImagesButton(),
                  SizedBox(height: 20),
                  _buildSelectedImages(),
                  SizedBox(height: 20),
                  _buildSelectDocumentsButton(),
                  SizedBox(height: 20),
                  _buildSelectedDocuments(),
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

  // Método para comprimir la imagen
  File compressImage(File file) {
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    if (image == null) return file;
    List<int> compressedBytes = img.encodeJpg(image, quality: 85);
    File compressedFile = File(file.path.replaceFirst('.jpg', '_compressed.jpg'));
    compressedFile.writeAsBytesSync(compressedBytes);
    return compressedFile;
  }

  // Método para obtener imágenes desde la galería
  void _getImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.clear();
        _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
        _images = _images.map(compressImage).toList();
      });
    }
  }

  // Método para obtener documentos desde el sistema de archivos
  void _getDocuments() async {
    final pickedFiles = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pickedFiles != null) {
      setState(() {
        _documents.clear();
        _documents.addAll(pickedFiles.paths.map((path) => File(path!)));
      });
    }
  }


  

  // Métodos para construir los widgets del formulario
  Widget _buildDropdownTipoincapacidad() {
    return DropdownButtonFormField<String>(
      value: _selectedTipoincapacidadReportada,
      items: const [
        DropdownMenuItem(value: 'Incapacidad por Enfermedad General', child: Text('Incapacidad por Enfermedad General')),
        DropdownMenuItem(value: 'Incapacidad por Accidente de Transito', child: Text('Incapacidad por Accidente de Transito')),
        DropdownMenuItem(value: 'Licencia Por Maternidad', child: Text('Licencia Por Maternidad')),
        DropdownMenuItem(value: 'Licencia Por Paternidad', child: Text('Licencia Por Paternidad')),
        DropdownMenuItem(value: 'Licencia Por Luto', child: Text('Licencia Por Luto')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedTipoincapacidadReportada = value;
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

  // Sección de documentos requeridos según tipo de incapacidad
  Widget _buildDocumentItem(String? selectedOption) {
    List<String> documents = [];

    switch (selectedOption) {
      case 'Incapacidad por Enfermedad General':
        documents.addAll(['- Incapacidad emitida por la EPS', '- Historia clínica']);
        break;
      case 'Incapacidad por Accidente de Transito':
        documents.addAll(['- Incapacidad emitida por la EPS', '- Historia clínica', '- Formulario Furips', '- Fotocopia del SOAT', '- Fotocopia de la Cédula']);
        break;
      case 'Licencia Por Maternidad':
        documents.addAll(['- Incapacidad emitida por la EPS', '- Epicrisis', '- Registro civil', '- Certificado de nacido vivo']);
        break;
      case 'Licencia Por Paternidad':
        documents.addAll(['- Transcripción de la licencia', '- Incapacidad emitida por la EPS', '- Epicrisis', '- Certificado de nacido vivo', '- Registro civil del hijo(a)', '- Fotocopia de la Cédula']);
        break;
      case 'Licencia Por Luto':
        documents.addAll(['- Incapacidad emitida por la EPS', '- Registro civil del fallecido', '- Certificado de defunción']);
        break;
      default:
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Documentos requeridos:'),
        ...documents.map((doc) => Text(doc)).toList(),
      ],
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
          DropdownMenuItem(value: 'COOSALUD EPS-S', child: Text('COOSALUD EPS-S')),
          DropdownMenuItem(value: 'Mutual Ser', child: Text('Mutual Ser')),
          DropdownMenuItem(value: 'Aliansalud EPS', child: Text('Aliansalud EPS')),
          DropdownMenuItem(value: 'Famisanar', child: Text('Famisanar')),
          DropdownMenuItem(value: 'Servicio Occidental de Salud EPS SOS', child: Text('Servicio Occidental de Salud EPS SOS')),
          DropdownMenuItem(value: 'Salud MIA', child: Text('Salud MIA')),
          DropdownMenuItem(value: 'Comfenalco Valle', child: Text('Comfenalco Valle')),
          DropdownMenuItem(value: 'EPM - Empresas Públicas de Medellín', child: Text('EPM - Empresas Públicas de Medellín')),
          DropdownMenuItem(value: 'Fondo de Pasivo Social de Ferrocarriles Nacionales de Colombia', child: Text('Fondo de Pasivo Social de Ferrocarriles Nacionales de Colombia')),
          DropdownMenuItem(value: 'Cajacopi Atlántico', child: Text('Cajacopi Atlántico')),
          DropdownMenuItem(value: 'Capresoca', child: Text('Capresoca')),
          DropdownMenuItem(value: 'Comfachocó', child: Text('Comfachocó')),
          DropdownMenuItem(value: 'Comfaoriente', child: Text('Comfaoriente')),
          DropdownMenuItem(value: 'EPS Familiar de Colombia', child: Text('EPS Familiar de Colombia')),
          DropdownMenuItem(value: 'Asmet Salud', child: Text('Asmet Salud')),
          DropdownMenuItem(value: 'Emssanar E.S.S.', child: Text('Emssanar E.S.S.')),
          DropdownMenuItem(value: 'Capital Salud EPS-S', child: Text('Capital Salud EPS-S')),
          DropdownMenuItem(value: 'Savia Salud EPS', child: Text('Savia Salud EPS')),
          DropdownMenuItem(value: 'Dusakawi EPSI', child: Text('Dusakawi EPSI')),
          DropdownMenuItem(value: 'Asociación Indígena del Cauca EPSI', child: Text('Asociación Indígena del Cauca EPSI')),
          DropdownMenuItem(value: 'Anas Wayuu EPSI', child: Text('Anas Wayuu EPSI')),
          DropdownMenuItem(value: 'Mallamas EPSI', child: Text('Mallamas EPSI')),
          DropdownMenuItem(value: 'Pijaos Salud EPSI', child: Text('Pijaos Salud EPSI')),
          DropdownMenuItem(value: 'Salud Bolívar EPS SAS', child: Text('Salud Bolívar EPS SAS')),
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

  // Método para agregar imágenes
  Widget _buildSelectImagesButton() {
    return ElevatedButton(
      onPressed: _getImages,
      child: Text('Seleccionar Imágenes'),
    );
  }

  // Campo para el código de categoría
  Widget _buildCategoriaCodigoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _categoriaCodigoController,
          decoration: InputDecoration(
            labelText: 'Código del diagnostico',
            border: OutlineInputBorder(),
            errorText: _codigoCategoriaError, // Mostrar error si lo hay
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              _checkCodigoCategoria(value);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa el código del diagnostico';
            }
            if (_codigoCategoriaError != null) {
              return _codigoCategoriaError; // Mostrar el error aquí
            }
            return null;
          },
        ),
        if (_codigoCategoriaError != null && _codigoCategoriaError!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _codigoCategoriaError!,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }

  // Método para verificar el código de categoría con el backend
  Future<void> _checkCodigoCategoria(String codigo) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/categoria/$codigo');  // Cambiar localhost a tu IP local
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _codigoCategoriaError = null; // Código válido
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('¡Código de categoría válido!')));
      } else {
        setState(() {
          _codigoCategoriaError = 'Este código de categoría no existe. Solicítalo con tu EPS.';
        });
      }
    } catch (error) {
      setState(() {
        _codigoCategoriaError = 'Error al verificar el código de categoría.';
      });
    }
  }

  // Método para mostrar las imágenes seleccionadas
  Widget _buildSelectedImages() {
    return _images.isNotEmpty
        ? Wrap(
            spacing: 8.0,
            children: _images.map((image) {
              return GestureDetector(
                onTap: () {
                  _retryImageUpload(image);  // Intentar cargar la imagen nuevamente
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Center(child: Text(image.path.split('/').last)),
                ),
              );
            }).toList(),
          )
        : Text('No hay imágenes seleccionadas');
  }

  // Reintentar cargar una imagen
  void _retryImageUpload(File image) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.remove(image);
        _images.add(File(pickedFile.path));
      });
    }
  }

  // Método para seleccionar documentos
  Widget _buildSelectDocumentsButton() {
    return ElevatedButton(
      onPressed: _getDocuments,
      child: Text('Seleccionar Documentos'),
    );
  }

  // Mostrar los documentos seleccionados
  Widget _buildSelectedDocuments() {
    return _documents.isNotEmpty
        ? Wrap(
            spacing: 8.0,
            children: _documents.map((document) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Center(child: Text(document.path.split('/').last)),
              );
            }).toList(),
          )
        : Text('No hay documentos seleccionados');
  }
// Método para confirmar y enviar el formulario
Future<void> _confirmAndSubmit() async {
  // Verificamos si el código de categoría es válido
  if (_codigoCategoriaError != null && _codigoCategoriaError!.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor ingresa un código de categoría válido.')),
    );
    return;
  }

  // Continuamos con la confirmación solo si el código es válido
  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirmar Envío'),
        content: Text('¿Estás seguro de que deseas enviar la incapacidad?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirmar'),
          ),
        ],
      );
    },
  );

  if (confirm == true) {
    _submitForm();
  }
}

// Método para enviar el formulario
Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) {
    return; // Si la validación falla, salimos
  }

  setState(() {
    _isLoading = true;
  });

  try {
    List<String> imagePaths = _images.map((img) => img.path).toList();
    List<String> documentPaths = _documents.map((doc) => doc.path).toList();

    String categoriaCodigo = _categoriaCodigoController.text;

    // Enviar la incapacidad si todo es válido
    await _controller.createIncapacidad(
      tipoincapacidadreportada: _selectedTipoincapacidadReportada!,
      diasIncapacidad: int.parse(_diasIncapacidadController.text),
      fechaInicioIncapacidad: _fechaInicio,
      entidadAfiliada: _selectedEntidadAfiliada!,
      images: _images,
      documents: _documents,
      imagePaths: imagePaths,
      documentPaths: documentPaths,
      categoriaCodigo: categoriaCodigo,
      context: context,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Incapacidad creada correctamente')),
    );
    Get.offAll(() => MenuPage()); // Redirige al menú principal

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

// Método para construir el botón de envío
Widget _buildSubmitButton() {
  return ElevatedButton(
    onPressed: _isLoading || (_codigoCategoriaError != null && _codigoCategoriaError!.isNotEmpty) ? null : _confirmAndSubmit,
    child: _isLoading
        ? CircularProgressIndicator(color: Colors.white)
        : Text('Enviar'),
  );
}

}
