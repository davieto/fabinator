import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/fabi_mood.dart';
import '../theme/colors.dart';
import '../widgets/fabi_character.dart';
import '../widgets/speech_bubble.dart';

const _lastGames = [
  'O professor de banco de dados!', 'Profa. Aline', 'O coordenador',
  'Aquele das redes', 'Prof. Python', 'A professora de gestão',
  'O gamer da turma', 'Seu orientador de TCC', 'Prof. de lógica', 'A sua coordenadora!',
];

class HomeScreen extends StatefulWidget {
  final VoidCallback onPlay;

  const HomeScreen({super.key, required this.onPlay});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showGames = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 700;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: isWide ? _wideLayout(context) : _narrowLayout(context),
    );
  }

  Widget _wideLayout(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpeechBubble(
                  side: BubbleSide.right,
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.spectral(fontSize: 17, color: ink, height: 1.45),
                      children: [
                        const TextSpan(text: 'Olá, eu sou a '),
                        TextSpan(text: 'FabiNator', style: GoogleFonts.spectral(fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' ✨'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                FabiCharacter(mood: FabiMood.confident, height: 420),
                const SizedBox(width: 24),
                SpeechBubble(
                  side: BubbleSide.left,
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.spectral(fontSize: 17, color: ink, height: 1.45),
                      children: [
                        const TextSpan(text: 'Pense em um '),
                        TextSpan(text: 'professor', style: GoogleFonts.spectral(fontWeight: FontWeight.bold)),
                        const TextSpan(text: ' que já te deu aula.\nEu vou tentar adivinhar quem é!'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _playButton(),
            const SizedBox(height: 16),
            _stats(),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          child: _showGames ? _lastGamesCard() : _lastGamesPill(),
        ),
      ],
    );
  }

  Widget _narrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_showGames) _lastGamesCard() else _lastGamesPill(),
          const SizedBox(height: 12),
          FabiCharacter(mood: FabiMood.confident, height: 280),
          const SizedBox(height: 12),
          SpeechBubble(
            side: BubbleSide.right,
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.spectral(fontSize: 16, color: ink, height: 1.45),
                children: [
                  const TextSpan(text: 'Pense em um '),
                  TextSpan(text: 'professor', style: GoogleFonts.spectral(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' que já te deu aula.\nEu vou tentar adivinhar quem é!'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _playButton(),
          const SizedBox(height: 16),
          _stats(),
        ],
      ),
    );
  }

  Widget _playButton() {
    return GestureDetector(
      onTap: widget.onPlay,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 14),
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
            BoxShadow(color: Color(0xFFA9741A), offset: Offset(0, 8), blurRadius: 0, spreadRadius: 0),
            BoxShadow(color: Colors.black45, blurRadius: 26, offset: Offset(0, 18)),
          ],
        ),
        child: Text(
          'JOGAR',
          style: GoogleFonts.lilitaOne(
            fontSize: 28,
            color: wine900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _stats() {
    return Column(
      children: [
        Text('Consigo adivinhar seu professor em até 15 perguntas.',
            style: GoogleFonts.spectral(color: goldLight, fontSize: 15, height: 1.6),
            textAlign: TextAlign.center),
        Text('Topa o desafio?',
            style: GoogleFonts.spectral(
                color: goldLight, fontSize: 15, height: 1.6,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _lastGamesPill() {
    return GestureDetector(
      onTap: () => setState(() => _showGames = true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFCF6EA), Color(0xFFEBD9B6)],
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFA9741A).withValues(alpha:0.45), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          '📜 Últimos jogos',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: wine800,
          ),
        ),
      ),
    );
  }

  Widget _lastGamesCard() {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFCF6EA), Color(0xFFF3E2CB)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA9741A).withValues(alpha:0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.5),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Os últimos 10 jogos',
                  style: GoogleFonts.spectral(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: wine800,
                  )),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xFFA9741A), Colors.transparent],
                  ),
                ),
              ),
              ..._lastGames.map((g) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(g,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spectral(fontSize: 14, color: crimson)),
              )),
            ],
          ),
          Positioned(
            top: -24,
            right: -24,
            child: GestureDetector(
              onTap: () => setState(() => _showGames = false),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: crimson,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 8)],
                ),
                alignment: Alignment.center,
                child: const Text('×',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
