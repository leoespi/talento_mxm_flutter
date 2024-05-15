import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                // Acción al presionar el botón 1
                print('Botón 1 presionado');
              },
              child: Text('Opción 1'),
            ),
            RaisedButton(
              onPressed: () {
                // Acción al presionar el botón 2
                print('Botón 2 presionado');
              },
              child: Text('Opción 2'),
            ),
            RaisedButton(
              onPressed: () {
                // Acción al presionar el botón 3
                print('Botón 3 presionado');
              },
              child: Text('Opción 3'),
            ),
          ],
        ),
      ),
    );
  }
}

RaisedButton({required Null Function() onPressed, required Text child}) {
}