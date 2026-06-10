import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/background.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Text('Sobre o projeto',
                          style: GoogleFonts.lilitaOne(
                              fontSize: 22, color: goldLight)),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cream,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFA9741A).withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FabiNator',
                              style: GoogleFonts.lilitaOne(
                                  fontSize: 28, color: wine800)),
                          const SizedBox(height: 8),
                          Text('Jogo de adivinhação de professores',
                              style: GoogleFonts.spectral(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: inkSoft)),
                          const SizedBox(height: 20),
                          Text(
                            'A FabiNator é um projeto acadêmico desenvolvido por alunos da '
                            'Faculdade Donaduzzi. Inspirado no jogo Akinator, o sistema usa '
                            'inteligência artificial para adivinhar qual professor você está pensando, '
                            'fazendo perguntas inteligentes sobre suas características.',
                            style: GoogleFonts.spectral(
                                fontSize: 15, color: ink, height: 1.6),
                          ),
                          const SizedBox(height: 20),
                          Text('Faculdade Donaduzzi',
                              style: GoogleFonts.spectral(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: wine800)),
                          const SizedBox(height: 8),
                          Text(
                            'Curso de Análise e Desenvolvimento de Sistemas',
                            style: GoogleFonts.spectral(
                                fontSize: 15, color: ink),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
