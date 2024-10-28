import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/controllers/registros_controller.dart';
import 'package:talento_mxm_flutter/models/registros_model.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin {
  final AuthenticationController _authController = AuthenticationController();
  late Future<List<Cesantia>> cesantias;
  late Future<List<Incapacidad>> incapacidades;
  late TabController _tabController;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    cesantias = ApiService().fetchCesantias();
    incapacidades = ApiService().fetchIncapacidades();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        title: Text(
          'Mis Registros',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'Cesantías'),
            Tab(text: 'Incapacidades'),
          ],
        ),
      ),
      drawer: SideMenu(),
      body: TabBarView(
        controller: _tabController,
        children: [
          // FutureBuilder for Cesantías...
          FutureBuilder<List<Cesantia>>(
            future: cesantias,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(child: Text('No hay cesantías disponibles.'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final cesantia = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      // Acción al pulsar
                    },
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Cesantía ID: ${cesantia.id}'),
                            Text('Tipo: ${cesantia.tipoCesantiaReportada}'),
                            Text('Estado: ${cesantia.estado}'),
                            if (cesantia.justificacion != null)
                              Text('Justificación: ${cesantia.justificacion}'),
                            Text('Fecha: ${cesantia.createdAt.toLocal()}'),
                            if (cesantia.imagenes.isNotEmpty)
                              _buildImageGrid(cesantia.imagenes),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // FutureBuilder for Incapacidades...
          FutureBuilder<List<Incapacidad>>(
            future: incapacidades,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(child: Text('No hay incapacidades disponibles.'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final incapacidad = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      // Acción al pulsar
                    },
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Incapacidad Nro: ${incapacidad.id}', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Tipo: ${incapacidad.tipoIncapacidadReportada}'),
                            SizedBox(height: 4),
                            Text('Días de Incapacidad: ${incapacidad.diasIncapacidad}'),
                            SizedBox(height: 4),
                            Text('Fecha de Inicio: ${incapacidad.fechaInicioIncapacidad.toLocal()}'),
                            SizedBox(height: 4),
                            Text('Entidad Afiliada: ${incapacidad.entidadAfiliada}'),
                            SizedBox(height: 8),
                            if (incapacidad.documentos.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Documentos:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  ...incapacidad.documentos.map((doc) => Text(doc)).toList(),
                                  SizedBox(height: 8),
                                ],
                              ),
                            if (incapacidad.imagenes.isNotEmpty) 
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Imágenes:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  _buildImageGrid(incapacidad.imagenes),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _mostrarImagen(BuildContext context, int index, List<String> imagenes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaImagen(
          imagenes: imagenes,
          inicial: index,
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(images.length, (index) {
          return GestureDetector(
            onTap: () => _mostrarImagen(context, index, images),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: 'http://10.0.2.2:8000/storage/${images[index]}',
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error),
                      Text('Error al cargar la imagen'),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class VistaImagen extends StatefulWidget {
  final List<String> imagenes;
  final int inicial;

  VistaImagen({required this.imagenes, required this.inicial});

  @override
  _VistaImagenState createState() => _VistaImagenState();
}

class _VistaImagenState extends State<VistaImagen> {
  late int currentImageIndex;

  @override
  void initState() {
    super.initState();
    currentImageIndex = widget.inicial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: widget.imagenes.length,
        controller: PageController(initialPage: widget.inicial),
        onPageChanged: (index) {
          setState(() {
            currentImageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context); // Cierra la vista de imagen al tocar
            },
            child: Center(
              child: CachedNetworkImage(
                imageUrl: 'http://10.0.2.2:8000/storage/${widget.imagenes[index]}',
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error),
                      Text('Error al cargar la imagen'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
  