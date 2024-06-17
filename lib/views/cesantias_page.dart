import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/controllers/cesantias_controller.dart';

import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/views/perfil.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart';

void main() => runApp(MyCesantiaspage());
  bool _isExpanded = false;


class CreateCesantiaPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyCesantiaspage(),
    );
  }
}


class MyCesantiaspage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyCesantiaspage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedtipocesantiareportada;
 
  List<File> _images = [];
  bool _isLoading = false;


  final CesantiasController _controller = Get.put(CesantiasController());

 Future<void> _getImages() async {
  final pickedFiles = await ImagePicker().pickMultiImage();

  if (pickedFiles != null) {
    setState(() {
      _images.clear();
      _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
    });
  }
}


  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  try {
    List<String> imagePaths = _images.map((image) => image.path).toList();

    await _controller.createCesantias(
      tipocesantiareportada: _selectedtipocesantiareportada!,
      images: _images,
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
                      'Formulario Solicitud de Cesantias',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedtipocesantiareportada,
                      items: const [
                        DropdownMenuItem(
                          value: 'Para Arreglos',
                          child: Text('Para Arreglos'),
                        ),
                        DropdownMenuItem(
                          value: 'Para Vivienda',
                          child: Text('Para Vivienda'),
                        ),
                        DropdownMenuItem(
                          value: 'Para Educacion Superior',
                          child: Text('Para Educacion Superior'),
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
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        textStyle: TextStyle(fontSize: 16),
                      ),
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

      bottomNavigationBar: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
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
                                begin: Offset(1.0, 0.0),
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
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     _buildBottomMenuItem(
                    icon: Icons.document_scanner,
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
                          pageBuilder: (context, _, __) => MyCesantiaspage(), //Cesantiaspage
                        ),
                      );
                    },
                    color: Colors.red,
                    label: 'Cesantias',
                  ),
                    _buildBottomMenuItem(
                      icon: Icons.person_2,
                      onPressed: () {
                        // Acción para la nueva opción 2
                      },
                      color: Colors.yellow,
                      label: 'P. Referidos',
                    ),
                    _buildBottomMenuItem(
                      icon: Icons.settings,
                      onPressed: () {
                        // Acción para la nueva opción 3
                      },
                      color: const Color.fromARGB(255, 58, 58, 58),
                      label: 'Configuracion',
                    ),
                  ],
                ),
              ),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
     
          );
  }


  Widget _buildDocumentItem(String? selectedOption) {
    List<String> documents = [];

    switch (selectedOption) {
      case 'Para Arreglos':
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

      case 'Para Vivienda':
        documents.addAll([
          '- Carta Solicitud retiro total o parcial',
          '- Fotocopia documento de identificacion',
          '- Compraventa  a nombre del colaborador',
          '- Certificado del fondo de cesantias',
        ]);
        break;

      case 'Para Educacion Superior':
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

}

