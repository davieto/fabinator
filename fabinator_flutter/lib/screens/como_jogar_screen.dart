import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/background.dart';

class ComoJogarScreen extends StatelessWidget {
  const ComoJogarScreen({super.key});

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
                      Text('Como jogar',
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
                          _step('1', 'Pense em um professor',
                              'Escolha qualquer professor que já te deu aula na Faculdade Donaduzzi.'),
                          const SizedBox(height: 20),
                          _step('2', 'Responda as perguntas',
                              'Responda Sim, Não ou Não sei para cada pergunta. Seja honesto!'),
                          const SizedBox(height: 20),
                          _step('3', 'Aguarde o palpite',
                              'Em até 15 perguntas, a FabiNator vai tentar adivinhar quem é o seu professor.'),
                          const SizedBox(height: 20),
                          _step('4', 'Confirme ou negue',
                              'Se acertamos, ótimo! Se erramos, tentamos mais uma vez.'),
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

  Widget _step(String num, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(color: wine800, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(num,
              style: GoogleFonts.lilitaOne(fontSize: 16, color: goldLight)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.spectral(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: wine800)),
              const SizedBox(height: 4),
              Text(desc,
                  style: GoogleFonts.spectral(
                      fontSize: 15, color: ink, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}
