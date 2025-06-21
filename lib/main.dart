import 'dart:io'; // Necesario para verificar la plataforma
import 'package:flutter/material.dart';
import 'package:laboratorio_crud/products_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Importa el paquete FFI

Future<void> main() async {
  // Asegura que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Si la app se ejecuta en Windows, Linux o macOS, inicializa la base de datos FFI
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratorio CRUD (Local)',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      debugShowCheckedModeBanner: false,
      home: const ProductsView(),
    );
  }
}