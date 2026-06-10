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
      title: 'FabiNator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const FabiNatorApp(),
    );
  }
}
