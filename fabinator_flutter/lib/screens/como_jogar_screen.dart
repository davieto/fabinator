import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/background.dart';

class ComoJogarScreen extends StatelessWidget {
  const ComoJogarScreen({super.key});

  static const _steps = [
    (
      icon: Icons.lightbulb_outline,
      title: 'Pense em um professor',
      desc: 'Escolha mentalmente um professor que já te deu aula na Faculdade Donaduzzi. Não revele o nome!',
    ),
    (
      icon: Icons.quiz_outlined,
      title: 'Responda as perguntas',
      desc: 'A FabiNator vai fazer uma série de perguntas sobre o professor que você está pensando.',
    ),
    (
      icon: Icons.touch_app_outlined,
      title: 'Use as 5 opções',
      desc: 'Para cada pergunta, escolha a resposta mais honesta entre as cinco disponíveis.',
    ),
    (
      icon: Icons.auto_awesome,
      title: 'A FabiNator adivinha!',
      desc: 'Com base nas suas respostas, a FabiNator vai tentar adivinhar quem é o professor — até 2 tentativas!',
    ),
    (
      icon: Icons.replay_outlined,
      title: 'Corrija ou jogue de novo',
      desc: 'Usou o botão CORRIGIR para desfazer a última resposta. Ao final, jogue de novo com outro professor!',
    ),
  ];

  static const _answers = [
    ('Sim', 'Certeza que sim.', gold),
    ('Não', 'Certeza que não.', crimson),
    ('Provavelmente sim', 'Mais sim do que não.', Color(0xFF8BC34A)),
    ('Provavelmente não', 'Mais não do que sim.', Color(0xFFFF7043)),
    ('Não sei', 'Dúvida total — não altera o raciocínio.', inkSoft),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Background(),
          Column(
            children: [
              _topBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Como funciona'),
                          const SizedBox(height: 16),
                          ..._steps.map((s) => _stepCard(s.icon, s.title, s.desc)),
                          const SizedBox(height: 24),
                          _sectionTitle('As 5 respostas possíveis'),
                          const SizedBox(height: 16),
                          _answersCard(),
                          const SizedBox(height: 24),
                          _tipCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: wine800.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: cream, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Text('Como Jogar',
                style: GoogleFonts.lilitaOne(fontSize: 26, color: goldLight)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: GoogleFonts.lilitaOne(fontSize: 20, color: goldLight, letterSpacing: 0.5));
  }

  Widget _stepCard(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCF6EA), Color(0xFFF1E2C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA9741A).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [crimsonBright, wine800]),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 15, color: wine800)),
                const SizedBox(height: 4),
                Text(desc,
                    style: GoogleFonts.spectral(fontSize: 14, color: ink, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _answersCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCF6EA), Color(0xFFF1E2C8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA9741A).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: List.generate(_answers.length, (i) {
            final (label, desc, color) = _answers[i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: i > 0
                    ? Border(top: BorderSide(color: const Color(0xFFA9741A).withValues(alpha: 0.15)))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: GoogleFonts.spectral(
                                fontWeight: FontWeight.w600, fontSize: 15, color: wine800)),
                        Text(desc,
                            style: GoogleFonts.spectral(fontSize: 13, color: inkSoft)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _tipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: wine800.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: goldLight.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.tips_and_updates_outlined, color: goldLight, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Dica: seja honesto nas respostas! Quanto mais preciso você for, mais chances a FabiNator tem de acertar.',
              style: GoogleFonts.spectral(fontSize: 15, color: cream, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
