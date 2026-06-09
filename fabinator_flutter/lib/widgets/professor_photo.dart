import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/professor.dart';
import '../theme/colors.dart';

class ProfessorPhoto extends StatelessWidget {
  final Professor prof;
  final double height;

  const ProfessorPhoto({super.key, required this.prof, this.height = 200});

  @override
  Widget build(BuildContext context) {
    final w = height * 0.82;
    return Container(
      width: w,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: gold, width: 3),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE9D7B6), Color(0xFFE3CFA8)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: w * 0.46,
            height: w * 0.46,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment(-0.3, -0.4),
                radius: 0.8,
                colors: [crimsonBright, wine700],
              ),
              boxShadow: [
                BoxShadow(color: Colors.black38, blurRadius: 16, offset: Offset(0, 8)),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              prof.initials,
              style: GoogleFonts.lilitaOne(fontSize: height * 0.18, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'foto do professor',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  letterSpacing: 1,
                  color: const Color(0xFF8A6516),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
