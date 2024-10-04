import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/controllers/cesantias_controller.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart';
import 'package:image/image.dart' as img;

void main() => runApp(MyCesantiaspage());

class MyCesantiaspage extends StatefulWidget {
  @override
  _MyCesantiaspageState createState() => _MyCesantiaspageState();
}

class _MyCesantiaspageState extends State<MyCesantiaspage> {

  // Clave para el formulario
  final _formKey = GlobalKey<FormState>();
  String? _selectedtipocesantiareportada; // Tipo de cesantía seleccionada
  List<File> _images = []; // Lista de imágenes seleccionadas
  bool _isLoading = false; // Estado de carga para el botón de enviar
  final CesantiasController _controller = Get.put(CesantiasController()); // Controlador de cesantías

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Método para construir la AppBar
      drawer: SideMenu(), // Menú lateral
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: _buildForm(), // Método para construir el formulario
      ),
      
    );
  }

  // Método para construir la AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 5, 13, 121),
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(''),
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
              _buildDocumentRequirements(), // Muestra documentos requeridos
              SizedBox(height: 20),
              _buildImagePickerButton(), // Botón para seleccionar imágenes
              SizedBox(height: 20),
              _buildSelectedImages(), // Muestra imágenes seleccionadas
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
          return 'Por favor selecciona el tipo de Solicitud'; // Valida que se haya seleccionado un tipo
        }
        return null;
      },
    );
  }

  // Método para mostrar documentos requeridos según el tipo de cesantía seleccionada
  Widget _buildDocumentRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documentos requeridos:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        _buildDocumentItem(_selectedtipocesantiareportada), // Llama a la función para construir la lista de documentos
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
      children: documents.map((doc) => Text(doc)).toList(), // Muestra cada documento en una línea
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

  // Método para mostrar las imágenes seleccionadas
  Widget _buildSelectedImages() {
    if (_images.isEmpty) return SizedBox(); // Si no hay imágenes, no muestra nada

    return Column(
      children: [
        Text(
          'Imágenes seleccionadas:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
      child: _isLoading ? CircularProgressIndicator() : Text('Enviar'), // Muestra un indicador de carga si está en proceso
    );
  }

  //FUNCIONES 
  // Función para obtener imágenes seleccionadas
  void _getImages() async {
    // Permitir al usuario seleccionar múltiples imágenes
    final pickedFiles = await ImagePicker().pickMultiImage();

    // Verificar si se seleccionaron archivos
    if (pickedFiles != null) {
      List<File> validImages = []; // Lista para almacenar imágenes válidas

      // Iterar sobre cada archivo seleccionado
      for (var pickedFile in pickedFiles) {
        File imageFile = File(pickedFile.path); // Crear un objeto File a partir del archivo seleccionado

        // Validar el formato del archivo (solo JPG y PNG)
        if (imageFile.path.endsWith('.jpg') || imageFile.path.endsWith('.png')) {
          // Validar el tamaño del archivo (máximo 20 MB)
          if (await imageFile.length() <= 20 * 1024 * 1024) {
            // Comprimir y redimensionar la imagen
            img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

            // Redimensionar la imagen para que el lado más largo sea de 800 píxeles
            int width;
            int height;

            // Calcular las dimensiones de la imagen redimensionada
            if (image!.width > image.height) {
              width = 800;
              height = (image.height / image.width * 800).round();
            } else {
              height = 800;
              width = (image.width / image.height * 800).round();
            }

            img.Image resizedImage = img.copyResize(image, width: width, height: height); // Redimensiona la imagen

            // Comprimir la imagen con formato JPEG
            List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 80);

            // Guardar la imagen comprimida en un archivo
            File compressedFile = File(imageFile.path.replaceFirst('.jpg', '_compressed.jpg'));
            compressedFile.writeAsBytesSync(compressedBytes);

            validImages.add(compressedFile); // Agregar imagen comprimida y válida a la lista
          } else {
            // Mostrar mensaje de error si el tamaño es mayor a 20 MB
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('El tamaño de la imagen ${pickedFile.name} debe ser menor a 20 MB.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          // Mostrar mensaje de error si el formato no es válido
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Formato no válido para la imagen ${pickedFile.name}. Solo se aceptan JPG y PNG.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      // Si hay imágenes válidas, procesarlas
      if (validImages.isNotEmpty) {
        setState(() {
          _images.clear();
          _images.addAll(validImages); // Actualiza la lista de imágenes
        });
      }
    }
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

  // Función para enviar el formulario
  Future<void> _submitForm() async {
    // Validar que el formulario sea correcto
    if (!_formKey.currentState!.validate()) return;

    // Indicar que la carga ha comenzado
    setState(() {
      _isLoading = true;
    });

    try {
      List<String> imagePaths = []; // Lista para almacenar las rutas de las imágenes

      // Procesar cada imagen seleccionada
      for (File imageFile in _images) {
        imagePaths.add(imageFile.path); // Guardar la ruta del archivo comprimido
      }

      // Llamar al controlador para crear las cesantías
      await _controller.createCesantias(
        tipocesantiareportada: _selectedtipocesantiareportada!,
        images: _images, // Pasar las imágenes directamente
        imagePaths: imagePaths,
        context: context,
      );

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cesantía creada exitosamente'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navegar a la página de menú
      Get.offAll(() => MenuPage());
    } catch (e) {
      String errorMessage;

      // Manejar errores específicos
      if (e is FileSystemException) {
        errorMessage = 'Error al acceder a los archivos. Verifica los permisos.'; // Error de acceso a archivos
      } else if (e is Exception) {
        errorMessage = e.toString(); 
      } else {
        errorMessage = 'Error desconocido: $e'; 
      }

      // Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      // Indicar que la carga ha finalizado
      setState(() {
        _isLoading = false;
      });
    }
  }
}
