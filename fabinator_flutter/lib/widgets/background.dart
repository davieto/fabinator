import 'package:flutter/material.dart';
import '../theme/colors.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.5),
          radius: 1.4,
          colors: [wine800, Color(0xFF2A080F)],
        ),
      ),
    );
  }
}
