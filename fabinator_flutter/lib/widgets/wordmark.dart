import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class Wordmark extends StatelessWidget {
  final double fontSize;

  const Wordmark({super.key, this.fontSize = 64});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFF3CC),
          Color(0xFFF6D879),
          Color(0xFFF4C84B),
          Color(0xFFE0A92E),
          Color(0xFFB9821F),
          Color(0xFFF4D06A),
        ],
        stops: [0.0, 0.30, 0.48, 0.62, 0.82, 1.0],
      ).createShader(bounds),
      child: Text(
        'FabiNator',
        style: GoogleFonts.lilitaOne(
          fontSize: fontSize,
          color: Colors.white,
          letterSpacing: 0.5,
          shadows: [
            Shadow(
              color: wine950.withValues(alpha: 0.8),
              offset: const Offset(2, 4),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
