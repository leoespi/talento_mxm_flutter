import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/controllers/publicacion_controller.dart';
import 'package:talento_mxm_flutter/models/publicacion_model.dart';

class MenuPage extends StatefulWidget {
  @override
  _FeedListViewState createState() => _FeedListViewState();
}

class _FeedListViewState extends State<MenuPage> {
  List<Publicacion> feeds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarFeeds();
  }

  Future<void> cargarFeeds() async {
    try {
      List<Publicacion> listaFeeds = await FeedController.obtenerFeeds();
      setState(() {
        feeds = listaFeeds;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los feeds: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los feeds: $e')),
      );
      // Intenta cargar nuevamente en caso de error
      cargarFeeds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeds'),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: feeds.length,
                    itemBuilder: (context, index) {
                      var feed = feeds[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 4.0),
                              Text(
                                'Usuario: ${feed.userNombre}',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(height: 4.0),
                              if (feed.imagen.isNotEmpty)
                                FutureBuilder(
                                  future: precacheImage(
                                    NetworkImage('http://10.0.2.2:8000${feed.imagen}'),
                                    context,
                                    onError: (exception, stackTrace) {
                                      print('Error precaching image: $exception');
                                      // Puedes manejar el error de manera adecuada aquí
                                    },
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return Image.network(
                                        'http://10.0.2.2:8000${feed.imagen}',
                                        height: 200.0,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
