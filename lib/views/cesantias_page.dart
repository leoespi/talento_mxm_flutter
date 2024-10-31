import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/controllers/cesantias_controller.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart';
import 'package:image/image.dart' as img;
import 'package:file_picker/file_picker.dart';

void main() => runApp(MyCesantiaspage());

class MyCesantiaspage extends StatefulWidget {
  @override
  _MyCesantiaspageState createState() => _MyCesantiaspageState();
}

class _MyCesantiaspageState extends State<MyCesantiaspage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedtipocesantiareportada; // Tipo de cesantía seleccionada
  List<File> _images = []; // Lista de imágenes seleccionadas
  List<File> _documents = []; // Lista de documentos seleccionados
  bool _isLoading = false; // Estado de carga para el botón de enviar
  final CesantiasController _controller = Get.put(CesantiasController()); // Controlador de cesantías

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Construcción de la AppBar
      drawer: SideMenu(), // Menú lateral
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: _buildForm(), // Construcción del formulario
      ),
    );
  }

  // Método para construir la AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 5, 13, 121),
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        'Cesantias',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Método para construir el formulario
  Widget _buildForm() {
    return Card(
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
              _buildTitle(), // Título del formulario
              SizedBox(height: 20),
              _buildDropdown(), // Dropdown para seleccionar el tipo de cesantía
              SizedBox(height: 20),
              _buildDocumentRequirements(), // Documentos requeridos
              SizedBox(height: 20),
              _buildImagePickerButton(), // Botón para seleccionar imágenes
              SizedBox(height: 20),
              _buildSelectedImages(), // Muestra imágenes seleccionadas
              _buildSelectDocumentsButton(), // Botón para seleccionar documentos
              SizedBox(height: 20),
              _buildSelectedDocuments(), // Muestra documentos seleccionados
              SizedBox(height: 20),
              _buildSubmitButton(), // Botón para enviar el formulario
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir el título del formulario
  Widget _buildTitle() {
    return Text(
      'Formulario Solicitud de Cesantias',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  // Método para construir el Dropdown de tipos de cesantía
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedtipocesantiareportada,
      items: const [
        DropdownMenuItem(value: 'Arreglos de Vivienda', child: Text('Arreglos de Vivienda')),
        DropdownMenuItem(value: 'Compra de Vivienda', child: Text('Compra de Vivienda')),
        DropdownMenuItem(value: 'Educacion', child: Text('Educacion')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedtipocesantiareportada = value; // Actualiza el estado con la opción seleccionada
        });
      },
      decoration: InputDecoration(
        labelText: 'Tipo de Solicitud',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor selecciona el tipo de Solicitud'; // Validación
        }
        return null;
      },
    );
  }

  // Método para mostrar documentos requeridos
  Widget _buildDocumentRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documentos requeridos:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        _buildDocumentItem(_selectedtipocesantiareportada), // Lista de documentos
      ],
    );
  }

  // Construye la lista de documentos requeridos según la opción seleccionada
  Widget _buildDocumentItem(String? selectedOption) {
    List<String> documents = [];

    switch (selectedOption) {
      case 'Arreglos de Vivienda':
        documents.addAll([
          '- Carta Solicitud retiro total o parcial',
          '- Fotocopia documento de identificación',
          '- Cotización de la mejora a realizar',
          '- Contrato con el maestro de la obra',
          '- Fotocopia Escritura',
          '- Registros de instrumentos públicos',
          '- Certificado del fondo de cesantías con el saldo actualizado',
        ]);
        break;

      case 'Compra de Vivienda':
        documents.addAll([
          '- Carta Solicitud retiro total o parcial',
          '- Fotocopia documento de identificación',
          '- Compraventa a nombre del colaborador',
          '- Certificado del fondo de cesantías',
        ]);
        break;

      case 'Educacion':
        documents.addAll([
          '- Carta Solicitud retiro total o parcial',
          '- Fotocopia documento de identificación',
          '- Copia del recibo de pago entidad educativa para pago crédito icetex',
          '- Certificado del fondo de cesantías con el saldo actualizado',
        ]);
        break;

      default:
        documents.add('- Seleccione un tipo de solicitud para ver los documentos requeridos');
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: documents.map((doc) => Text(doc)).toList(), // Muestra cada documento
    );
  }

  // Método para construir el botón de selección de imágenes
  Widget _buildImagePickerButton() {
    return ElevatedButton(
      onPressed: () {
        _getImages(); // Llama a la función para obtener imágenes
      },
      child: Text('Seleccionar Imágenes'),
    );
  }

  // Función para obtener imágenes seleccionadas
  void _getImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage(); // Permitir selección de múltiples imágenes

    if (pickedFiles != null) {
      List<File> validImages = []; // Lista para almacenar imágenes válidas

      for (var pickedFile in pickedFiles) {
        File imageFile = File(pickedFile.path); // Crear objeto File

        // Validar el formato del archivo
        if (imageFile.path.endsWith('.jpg') || imageFile.path.endsWith('.png')) {
          // Validar tamaño (máximo 20 MB)
          if (await imageFile.length() <= 20 * 1024 * 1024) {
            img.Image? image = img.decodeImage(imageFile.readAsBytesSync()); // Decodificar imagen

            if (image != null) {
              List<int> compressedBytes = img.encodeJpg(image, quality: 85); // Comprimir imagen
              File compressedFile = File(imageFile.path.replaceFirst('.jpg', '_compressed.jpg'));
              compressedFile.writeAsBytesSync(compressedBytes); // Guardar imagen comprimida
              validImages.add(compressedFile); // Agregar a la lista
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El tamaño de la imagen ${pickedFile.name} debe ser menor a 20 MB.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Formato no válido para la imagen ${pickedFile.name}. Solo se aceptan JPG y PNG.')),
          );
        }
      }

      if (validImages.isNotEmpty) {
        setState(() {
          _images.clear();
          _images.addAll(validImages); // Actualizar la lista de imágenes
        });
      }
    }
  }

  // Método para mostrar las imágenes seleccionadas
  Widget _buildSelectedImages() {
    if (_images.isEmpty) return SizedBox(); // Si no hay imágenes, no muestra nada

    return Column(
      children: [
        Text('Imágenes seleccionadas:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Lista horizontal
            itemCount: _images.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.file(_images[index]), // Muestra la imagen desde el archivo
              );
            },
          ),
        ),
      ],
    );
  }

  // Método para construir el botón de envío del formulario
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _showConfirmationDialog(), // Muestra el diálogo de confirmación
      child: _isLoading ? CircularProgressIndicator() : Text('Enviar'), // Indicador de carga si es necesario
    );
  }

  // Función para mostrar el diálogo de confirmación
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
                Text('¿Estás seguro de que deseas enviar este formulario? En caso de que los datos no coincidan, la solicitud será eliminada y será necesario volver a subirla. Se te notificará a través del correo electrónico registrado en el sistema en caso de enviar incorrectamente el formulario.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text('Enviar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _submitForm(); // Envía el formulario
              },
            ),
          ],
        );
      },
    );
  }

  // Botón para seleccionar documentos
  Widget _buildSelectDocumentsButton() {
    return ElevatedButton(
      onPressed: _getDocuments, // Función para obtener documentos
      child: Text('Seleccionar Documentos'),
    );
  }

  // Método para obtener documentos
  void _getDocuments() async {
    final pickedFiles = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pickedFiles != null) {
      setState(() {
        _documents.clear();
        _documents.addAll(pickedFiles.paths.map((path) => File(path!))); // Actualiza la lista de documentos
      });
    }
  }

  // Método para mostrar documentos seleccionados
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
                child: Center(child: Text(document.path.split('/').last)), // Mostrar nombre del archivo
              );
            }).toList(),
          )
        : Text('No hay documentos seleccionados');
  }

  // Función para enviar el formulario
  Future<void> _submitForm() async {
    // Validar que el formulario sea correcto
    if (!_formKey.currentState!.validate()) return;

    if (_images.isEmpty && _documents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona al menos una imagen o un documento')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Indica que la carga ha comenzado
    });

    try {
      List<String> imagePaths = _images.map((img) => img.path).toList(); // Rutas de las imágenes
      List<String> documentPaths = _documents.map((doc) => doc.path).toList(); // Rutas de los documentos

      // Llamar al controlador para crear las cesantías
      await _controller.createCesantias(
        tipocesantiareportada: _selectedtipocesantiareportada!,
        images: _images,
        documents: _documents,
        imagePaths: imagePaths,
        documentPaths: documentPaths,
        context: context,
      );

      // Mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cesantía creada exitosamente')),
      );

      // Navegar a la página de menú
      Get.offAll(() => MenuPage());
    } catch (e) {
      String errorMessage;

      if (e is FileSystemException) {
        errorMessage = 'Error al acceder a los archivos. Verifica los permisos.'; // Error de acceso a archivos
      } else {
        errorMessage = 'Error desconocido: $e'; // Error desconocido
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false; // Indica que la carga ha finalizado
      });
    }
  }
}
