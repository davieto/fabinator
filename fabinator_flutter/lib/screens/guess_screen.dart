import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../engine/fabi_engine.dart';
import '../models/professor.dart';
import '../theme/colors.dart';
import '../widgets/fabi_character.dart';
import '../widgets/professor_photo.dart';

class GuessScreen extends StatelessWidget {
  final Professor prof;
  final FabiMood mood;
  final VoidCallback onYes;
  final VoidCallback onNo;

  const GuessScreen({
    super.key,
    required this.prof,
    required this.mood,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 700;

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FabiCharacter(mood: mood, height: 380),
          const SizedBox(width: 40),
          Flexible(child: _card()),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FabiCharacter(mood: mood, height: 220),
          const SizedBox(height: 8),
          _card(),
        ],
      ),
    );
  }

  Widget _card() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCF6EA), Color(0xFFF1E2C8)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFA9741A).withValues(alpha:0.4)),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 48, offset: Offset(0, 20)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _panelHead('Eu acho que…'),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 26),
                child: Column(
                  children: [
                    Text(
                      prof.name,
                      style: GoogleFonts.lilitaOne(
                        fontSize: 32,
                        color: wine800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${prof.area} · ${prof.tagline}',
                      style: GoogleFonts.spectral(
                        fontStyle: FontStyle.italic,
                        color: inkSoft,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Center(child: ProfessorPhoto(prof: prof, height: 200)),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _btn('Sim, é ele(a)!', gold: true, onTap: onYes),
                        const SizedBox(width: 16),
                        _btn('Não', gold: false, onTap: onNo),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panelHead(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      color: wine800,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.lilitaOne(
          fontSize: 18,
          color: goldLight,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _btn(String label, {required bool gold, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gold
                ? const [Color(0xFFF6D879), Color(0xFFE0A92E)]
                : const [Color(0xFF7C2336), Color(0xFF5C1626)],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: gold
                ? const Color(0xFFB9821F)
                : goldLight.withValues(alpha:0.35),
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: gold ? wine900 : cream,
          ),
        ),
      ),
    );
  }
}
