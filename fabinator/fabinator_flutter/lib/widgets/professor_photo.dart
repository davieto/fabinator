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
    final assetPath = 'assets/professores/${prof.id}.jpg';

    return Container(
      width: w,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: gold, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          width: w,
          height: height,
          errorBuilder: (_, error, stack) => _initialsWidget(w),
        ),
      ),
    );
  }

  Widget _initialsWidget(double w) {
    return Container(
      width: w,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE9D7B6), Color(0xFFE3CFA8)],
        ),
      ),
      child: Center(
        child: Container(
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
              BoxShadow(
                  color: Colors.black38, blurRadius: 16, offset: Offset(0, 8)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            prof.initials,
            style:
                GoogleFonts.lilitaOne(fontSize: height * 0.18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
