import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/controllers/registros_controller.dart';
import 'package:talento_mxm_flutter/models/registros_model.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:get_storage/get_storage.dart';

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
        title: Text('Mis Registros', style: TextStyle(
      color: Colors.white, // Cambia el color aquí
    ),),
            bottom: TabBar(
        controller: _tabController,
        labelColor: Colors.white, // Color del texto seleccionado
        unselectedLabelColor: Colors.grey, // Color del texto no seleccionado
        tabs: [
          Tab(text: 'Cesantías'),
          Tab(text: 'Incapacidades'),
        ],
      ),

      ),
      drawer: SideMenu(), // Asegúrate de que el SideMenu esté implementado
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
                  return ListTile(
                    title: Text('Cesantía ID: ${snapshot.data![index].id}'),
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
                  return ListTile(
                    title: Text('Incapacidad ID: ${snapshot.data![index].id}'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
