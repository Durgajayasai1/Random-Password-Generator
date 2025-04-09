import 'package:flutter/material.dart';
import 'package:random_pwd_generator/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Password Generator',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.black, elevation: 0),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const Home(),
    );
  }
}
