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
                  return Card(
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
                  );
                },
              );
            },
          ),
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
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Incapacidad ID: ${incapacidad.id}'),
                          Text('Tipo: ${incapacidad.tipoIncapacidadReportada}'),
                          Text('Días de Incapacidad: ${incapacidad.diasIncapacidad}'),
                          Text('Fecha de Inicio: ${incapacidad.fechaInicioIncapacidad.toLocal()}'),
                          Text('Entidad Afiliada: ${incapacidad.entidadAfiliada}'),
                          if (incapacidad.imagenes.isNotEmpty)
                            _buildImageGrid(incapacidad.imagenes),
                        ],
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

  Widget _buildImageGrid(List<String> images) {
    return Container(
      height: 200.0,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: images.length == 1 ? 1 : 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: images.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, imgIndex) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: 'http://10.0.2.2:8000/storage/${images[imgIndex]}',
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
          );
        },
      ),
    );
  }
}
