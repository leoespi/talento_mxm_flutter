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

class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  final AuthenticationController _authController = AuthenticationController();
  late Future<List<Cesantia>> cesantias;
  late Future<List<Incapacidad>> incapacidades;
  late Future<List<Solicitud>> permisos;
  late TabController _tabController;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    cesantias = ApiService().fetchCesantias();
    incapacidades = ApiService().fetchIncapacidades();
    permisos = ApiService().fetchpermisos();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Método para refrescar los datos
  Future<void> _refreshData() async {
    setState(() {
      cesantias = ApiService().fetchCesantias();
      incapacidades = ApiService().fetchIncapacidades();
      permisos = ApiService().fetchpermisos();
    });
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
            Tab(text: 'Permisos'),
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
                return _buildErrorState(snapshot.error);
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(child: Text('No hay cesantías disponibles.'));
              }
              // Invertir el orden para mostrar los más recientes primero
              final cesantiasData = snapshot.data!.reversed.toList();
              return RefreshIndicator(
                onRefresh: _refreshData, // Función para refrescar los datos
                child: ListView.builder(
                  itemCount: cesantiasData.length,
                  itemBuilder: (context, index) {
                    final cesantia = cesantiasData[index];
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
                                Text(
                                    'Justificación: ${cesantia.justificacion}'),
                              Text('Fecha: ${cesantia.createdAt.toLocal()}'),
                              SizedBox(height: 8),
                              if (cesantia.documentos.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Documentos:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    ...cesantia.documentos
                                        .map((doc) => Text(doc))
                                        .toList(),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              if (cesantia.imagenes.isNotEmpty)
                                _buildImageGrid(cesantia.imagenes),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
                return _buildErrorState(snapshot.error);
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(child: Text('No hay incapacidades disponibles.'));
              }
              // Invertir el orden para mostrar los más recientes primero
              final incapacidadesData = snapshot.data!.reversed.toList();
              return RefreshIndicator(
                onRefresh: _refreshData, // Función para refrescar los datos
                child: ListView.builder(
                  itemCount: incapacidadesData.length,
                  itemBuilder: (context, index) {
                    final incapacidad = incapacidadesData[index];
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
                              Text('Incapacidad Nro: ${incapacidad.id}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text(
                                  'Tipo: ${incapacidad.tipoIncapacidadReportada}'),
                              SizedBox(height: 4),
                              Text(
                                  'Días de Incapacidad: ${incapacidad.diasIncapacidad}'),
                              SizedBox(height: 4),
                              Text(
                                  'Fecha de Inicio: ${incapacidad.fechaInicioIncapacidad.toLocal()}'),
                              SizedBox(height: 4),
                              Text(
                                  'Entidad Afiliada: ${incapacidad.entidadAfiliada}'),
                              SizedBox(height: 8),
                              if (incapacidad.documentos.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Documentos:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    ...incapacidad.documentos
                                        .map((doc) => Text(doc))
                                        .toList(),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              if (incapacidad.imagenes.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Imágenes:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
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
                ),
              );
            },
          ),

          FutureBuilder<List<Solicitud>>(
            future: permisos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _buildErrorState(snapshot.error);
              }
              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
                    child: Text('No hay solicitudes de permisos disponibles.'));
              }

              // Invertir el orden para mostrar los más recientes primero
              final permisosData = snapshot.data!.reversed.toList();

              return RefreshIndicator(
                onRefresh: _refreshData, // Función para refrescar los datos
                child: ListView.builder(
                  itemCount: permisosData.length,
                  itemBuilder: (context, index) {
                    final permisos = permisosData[index];
                    return GestureDetector(
                      onTap: () {
                        // Acción al tocar el ítem
                      },
                      child: Card(
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('PERMISOS'),
                              Text('Sede: ${permisos.pVenta}'),
                              Text(
                                  'Categoria Solicitud: ${permisos.categoriaSolicitud}'),
                              Text(
                                  'Fecha de Permiso: ${permisos.fechaPermiso}'),
                              Text(
                                  'Fecha de Solicitud: ${permisos.fechaSolicitud}'),
                              Text('Hora: ${permisos.hora}'),
                              Text(
                                  'Unidad de tiempo: ${permisos.unidadTiempo}'),
                              Text('Justificación: ${permisos.justificacion}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),



        ],
      ),
    );
  }

  // Método para mostrar el error y el botón de refrescar
  Widget _buildErrorState(Object? error) {
    String errorMessage = 'Ha ocurrido un error desconocido';
    if (error is String) {
      errorMessage = error;
    } else if (error is Exception) {
      errorMessage = error.toString();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $errorMessage'),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: _refreshData,
            child: Text('Intentar de nuevo'),
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
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 1.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _mostrarImagen(context, index, images),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: 'http://192.168.1.148:8000/storage/${images[index]}',
              //imageUrl: 'http://10.0.2.2:8000/storage/${images[index]}',
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Center(child: Icon(Icons.error)),
            ),
          ),
        );
      },
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
                imageUrl:
                    'http://192.168.1.148:8000/storage/${widget.imagenes[index]}',
                //imageUrl: 'http://10.0.2.2:8000/storage/${widget.imagenes[index]}',
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // Forzar la reconstrucción del widget para recargar la imagen
                        CachedNetworkImage.evictFromCache(
                            'http://192.168.1.148:8000/storage/${widget.imagenes[index]}');
                        //CachedNetworkImage.evictFromCache('http://10.0.2.2:8000/storage/${widget.imagenes[index]}');
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error),
                        Text('Toca para intentar de nuevo'),
                      ],
                    ),
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
