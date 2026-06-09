import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../engine/fabi_engine.dart';
import '../models/professor.dart';
import '../theme/colors.dart';
import '../widgets/confetti_overlay.dart';
import '../widgets/fabi_character.dart';
import '../widgets/professor_photo.dart';

class WinScreen extends StatelessWidget {
  final Professor prof;
  final VoidCallback onReplay;

  const WinScreen({super.key, required this.prof, required this.onReplay});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 700;

    return Stack(
      children: [
        const ConfettiOverlay(),
        if (isWide)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FabiCharacter(mood: FabiMood.smile, height: 380),
              const SizedBox(width: 40),
              Flexible(child: _card(onReplay)),
            ],
          )
        else
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FabiCharacter(mood: FabiMood.smile, height: 220),
                const SizedBox(height: 8),
                _card(onReplay),
              ],
            ),
          ),
      ],
    );
  }

  Widget _card(VoidCallback onReplay) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
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
              _panelHead('Acertei! 🎉'),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Center(child: ProfessorPhoto(prof: prof, height: 190)),
                    const SizedBox(height: 16),
                    Text(
                      prof.name,
                      style: GoogleFonts.lilitaOne(fontSize: 30, color: wine800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mais uma vez a magia da Donaduzzi venceu!',
                      style: GoogleFonts.spectral(
                          fontStyle: FontStyle.italic, color: inkSoft, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    _playAgainBtn(onReplay),
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
        style: GoogleFonts.lilitaOne(fontSize: 18, color: goldLight, letterSpacing: 1),
      ),
    );
  }

  Widget _playAgainBtn(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8DE8C), Color(0xFFF4C84B), Color(0xFFE0A92E), Color(0xFFC28E22)],
            stops: [0, 0.45, 0.70, 1],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF8A6516), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xFFA9741A), offset: Offset(0, 8)),
            BoxShadow(color: Colors.black45, blurRadius: 26, offset: Offset(0, 18)),
          ],
        ),
        child: Text(
          'JOGAR DE NOVO',
          style: GoogleFonts.lilitaOne(fontSize: 24, color: wine900, letterSpacing: 1),
        ),
      ),
    );
  }
}
