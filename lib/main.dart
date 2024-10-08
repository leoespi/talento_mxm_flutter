import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importa la biblioteca Get
import 'package:get_storage/get_storage.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'views/login_page.dart';

void main()  {
    GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {  
     final box = GetStorage();
     final token = box.read('token');
    return   GetMaterialApp( 
      debugShowCheckedModeBanner: false,
      title: 'Talento MxM', 
      home: token == null ? const LoginPage() :  MenuPage(),
    );  
  }
}

