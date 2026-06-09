import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/background.dart';
import '../widgets/wordmark.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

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
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: const Wordmark(fontSize: 56)),
                          const SizedBox(height: 6),
                          Center(
                            child: Text(
                              'Faculdade Donaduzzi',
                              style: GoogleFonts.spectral(
                                  fontStyle: FontStyle.italic,
                                  color: goldLight.withValues(alpha: 0.8),
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 28),
                          _card(
                            icon: Icons.psychology_outlined,
                            title: 'O que é o FabiNator?',
                            body:
                                'O FabiNator é um jogo de adivinhação inspirado no Akinator. '
                                'Você pensa em um professor da Faculdade Donaduzzi e a personagem '
                                'FabiNator — uma gênia misteriosa — tenta descobrir quem é respondendo '
                                'apenas com perguntas de sim ou não.',
                          ),
                          const SizedBox(height: 16),
                          _card(
                            icon: Icons.auto_graph_outlined,
                            title: 'Como a IA adivinha?',
                            body:
                                'O motor do jogo usa um algoritmo bayesiano: cada professor começa '
                                'com probabilidade igual. A cada resposta, as probabilidades são '
                                'atualizadas — quem combina com a resposta sobe, quem não combina desce. '
                                'A FabiNator chuta quando um professor atinge alta confiança ou após '
                                'várias perguntas.',
                          ),
                          const SizedBox(height: 16),
                          _card(
                            icon: Icons.school_outlined,
                            title: 'Projeto acadêmico',
                            body:
                                'Este app foi desenvolvido como projeto da disciplina de '
                                'Desenvolvimento Mobile na Faculdade Donaduzzi. '
                                'O frontend foi criado originalmente em React/HTML e convertido '
                                'para Flutter, mantendo toda a lógica do motor de adivinhação.',
                          ),
                          const SizedBox(height: 16),
                          _card(
                            icon: Icons.code_outlined,
                            title: 'Tecnologias',
                            body: '',
                            child: _techList(),
                          ),
                          const SizedBox(height: 16),
                          _card(
                            icon: Icons.info_outline,
                            title: 'Versão',
                            body: 'FabiNator v1.0.0 · Flutter 3.x · Dart 3.x\n'
                                'Projeto acadêmico — sem fins comerciais.',
                          ),
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
            Text('Sobre o Projeto',
                style: GoogleFonts.lilitaOne(fontSize: 26, color: goldLight)),
          ],
        ),
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required String body,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCF6EA), Color(0xFFF1E2C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA9741A).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [crimsonBright, wine800]),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: GoogleFonts.lilitaOne(fontSize: 18, color: wine800)),
              ),
            ],
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(body,
                style: GoogleFonts.spectral(
                    fontSize: 15, color: ink, height: 1.55)),
          ],
          if (child != null) ...[
            const SizedBox(height: 12),
            child,
          ],
        ],
      ),
    );
  }

  Widget _techList() {
    final items = [
      (Icons.flutter_dash, 'Flutter + Dart', 'Framework mobile multiplataforma'),
      (Icons.functions, 'Algoritmo Bayesiano', 'Motor de adivinhação probabilístico'),
      (Icons.font_download_outlined, 'Google Fonts', 'Lilita One · Spectral · Poppins'),
      (Icons.image_outlined, 'Assets próprios', 'Personagem e logo Donaduzzi'),
    ];
    return Column(
      children: items.map((item) {
        final (icon, title, sub) = item;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Icon(icon, color: crimson, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: wine800)),
                    Text(sub,
                        style: GoogleFonts.spectral(
                            fontSize: 13, color: inkSoft)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
