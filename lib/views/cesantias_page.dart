import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';

import 'package:talento_mxm_flutter/controllers/cesantias_controller.dart';

import 'package:talento_mxm_flutter/views/menu.dart';


import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart'; // Asegúrate de importar el nuevo widget


void main() => runApp(MyCesantiaspage());
  




class MyCesantiaspage extends StatefulWidget {



  
  @override
  
  _MyCesantiaspageState createState() => _MyCesantiaspageState();
}

class _MyCesantiaspageState extends State<MyCesantiaspage> {
  
  
  final _formKey = GlobalKey<FormState>();
  String? _selectedtipocesantiareportada;
  List<File> _images = [];
  bool _isLoading = false;
  final CesantiasController _controller = Get.put(CesantiasController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        title: Text(''),
        actions: [],
      ),
       drawer: SideMenu(),
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
                    'Formulario Solicitud de Cesantias',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedtipocesantiareportada,
                    items: const [
                      DropdownMenuItem(
                        value: 'Arreglos de Vivienda',
                        child: Text('Arreglos de Vivienda'),
                      ),
                      DropdownMenuItem(
                        value: 'Compra de Vivienda',
                        child: Text('Compra de Vivienda'),
                      ),
                      DropdownMenuItem(
                        value: 'Educacion',
                        child: Text('Educacion'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedtipocesantiareportada = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Tipo de Solicitud',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona el tipo de Solicitud';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Documentos requeridos:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      _buildDocumentItem(_selectedtipocesantiareportada),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _getImages();
                    },
                    child: Text('Seleccionar Imágenes'),
                  ),
                  SizedBox(height: 20),
                  if (_images.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          'Imágenes seleccionadas:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _images.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image.file(_images[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _showConfirmationDialog(),
                    child: _isLoading ? CircularProgressIndicator() : Text('Enviar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      
          );
    
  }

  Widget _buildDocumentItem(String? selectedOption) {
  List<String> documents = [];

  switch (selectedOption) {
    case 'Arreglos de Vivienda':
      documents.addAll([
        '- Carta Solicitud retiro total o parcial',
        '- Fotocopia documento de identificacion',
        '- Cotizacion de la mejora a realizar',
        '- Contrato con el maestro de la obra',
        '- Fotocopia Escritura',
        '- Registros de instrumentos publicos',
        '- Certificado del fondo de cesantias con el saldo actualizado',
      ]);
      break;

    case 'Compra de Vivienda':
      documents.addAll([
        '- Carta Solicitud retiro total o parcial',
        '- Fotocopia documento de identificacion',
        '- Compraventa  a nombre del colaborador',
        '- Certificado del fondo de cesantias',
      ]);
      break;

    case 'Educacion':
      documents.addAll([
        '- Carta Solicitud retiro total o parcial',
        '- Fotocopia documento de identificacion',
        '- Copia del recibo de pago entidad educativa para pago credito icetex',
        '- Certificado del fondo de cesantias con el saldo actualizado',
      ]);
      break;

    default:
      documents.add('- Seleccione un tipo de solicitud para ver los documentos requeridos');
      break;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: documents.map((doc) => Text(doc)).toList(),
  );
}


  Widget _buildBottomMenuItem({required IconData icon, required VoidCallback onPressed, required Color color, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: color,
          iconSize: 30,
        ),
        Text(
          label,
          style: TextStyle(color: color),
        ),
      ],
    );
  }


  

  void _getImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images.clear();
        _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));

        // Comprimir y redimensionar las imágenes justo después de seleccionarlas
        List<File> compressedFiles = [];
        for (File imageFile in _images) {
          File compressedFile = compressAndResizeImage(imageFile);
          compressedFiles.add(compressedFile);
        }

        _images.clear();
        _images.addAll(compressedFiles);
      });
    }
  }

  File compressAndResizeImage(File file) {
    img.Image? image = img.decodeImage(file.readAsBytesSync());

    // Redimensionar la imagen para que el lado más largo sea de 800 píxeles
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

    // Comprimir la imagen con formato JPEG
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 80);

    // Guardar la imagen comprimida en un archivo
    File compressedFile = File(file.path.replaceFirst('.jpg', '_compressed.jpg'));
    compressedFile.writeAsBytesSync(compressedBytes);

    return compressedFile;
  }

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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> imagePaths = [];
      List<File> compressedFiles = [];

      // Procesar cada imagen seleccionada
      for (File imageFile in _images) {
        // Comprimir y redimensionar la imagen
        File compressedFile = compressAndResizeImage(imageFile);
        compressedFiles.add(compressedFile);
        imagePaths.add(compressedFile.path); // Guardar la ruta del archivo comprimido
      }

      await _controller.createCesantias(
        tipocesantiareportada: _selectedtipocesantiareportada!,
        images: compressedFiles,
        imagePaths: imagePaths,
        context: context,
      );

      // La solicitud se completó sin errores, ahora puedes mostrar el SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cesantia creada exitosamente'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navegar a la página de menú u otro destino después del éxito
      Get.offAll(() => MenuPage());
    } catch (e) {
      // Error al crear la cesantía, muestra un mensaje de error
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear la cesantía'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }



  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

}
