import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const FabiNatorRoot());
}

class FabiNatorRoot extends StatelessWidget {
  const FabiNatorRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FabiNator · Faculdade Donaduzzi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C1626)),
        useMaterial3: true,
      ),
      home: const FabiNatorApp(),
    );
  }
}
