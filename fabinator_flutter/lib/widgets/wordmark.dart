import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class Wordmark extends StatelessWidget {
  final double fontSize;
  const Wordmark({super.key, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.lilitaOne(fontSize: fontSize, color: Colors.white),
        children: [
          const TextSpan(text: 'Fabi'),
          TextSpan(
            text: 'Nator',
            style: GoogleFonts.lilitaOne(fontSize: fontSize, color: goldLight),
          ),
        ],
      ),
    );
  }
}
