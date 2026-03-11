import 'package:flutter/material.dart';
import 'package:frontend_flutter/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namaz Vakitleri',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFD0F3E4),
          primary: Color(0xFF11d483),
          primaryFixed: Color(0xFFE5F8F0),
          primaryFixedDim: Color.fromARGB(255, 244, 253, 250),
          onPrimaryFixedVariant: Color(0xFFF7FDFB),
          secondary: Colors.grey[500],
          secondaryFixed: Colors.grey[200],
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
