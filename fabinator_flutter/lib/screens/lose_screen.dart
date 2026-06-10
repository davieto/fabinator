import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/fabi_mood.dart';
import '../theme/colors.dart';
import '../widgets/fabi_character.dart';

class LoseScreen extends StatefulWidget {
  final VoidCallback onReplay;
  final String? message;

  const LoseScreen({super.key, required this.onReplay, this.message});

  @override
  State<LoseScreen> createState() => _LoseScreenState();
}

class _LoseScreenState extends State<LoseScreen> {
  final _ctrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 700;

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FabiCharacter(mood: FabiMood.shy, height: 380),
          const SizedBox(width: 40),
          Flexible(child: _card()),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FabiCharacter(mood: FabiMood.shy, height: 220),
          const SizedBox(height: 8),
          _card(),
        ],
      ),
    );
  }

  Widget _card() {
    final customMsg = widget.message;
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
              customMsg != null
                  ? _panelHead('Ops! 😅')
                  : _panelHead('Você me venceu… 😳'),
              Padding(
                padding: const EdgeInsets.all(24),
                child: customMsg != null
                    ? _customContent(customMsg)
                    : _defaultContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customContent(String msg) {
    return Column(
      children: [
        Text(
          msg,
          style: GoogleFonts.spectral(fontSize: 17, color: ink, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _playAgainBtn(),
      ],
    );
  }

  Widget _defaultContent() {
    return Column(
      children: [
        Text(
          'Não consegui adivinhar dessa vez!\nMe conta: ',
          style: GoogleFonts.spectral(fontSize: 17, color: ink, height: 1.5),
          textAlign: TextAlign.center,
        ),
        Text(
          'quem era o seu professor?',
          style: GoogleFonts.spectral(
              fontSize: 17, fontWeight: FontWeight.bold, color: ink),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        if (!_sent) ...[
          _inputRow(),
          const SizedBox(height: 20),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'Obrigada! Vou aprender com ${_ctrl.text} para a próxima. 💪',
              style: GoogleFonts.spectral(
                fontStyle: FontStyle.italic,
                color: crimson,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        _playAgainBtn(),
      ],
    );
  }

  Widget _inputRow() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: 220,
          child: TextField(
            controller: _ctrl,
            style: GoogleFonts.spectral(fontSize: 16, color: ink),
            decoration: InputDecoration(
              hintText: 'Nome do professor',
              hintStyle: GoogleFonts.spectral(color: inkSoft),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: const Color(0xFFA9741A).withValues(alpha:0.5), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: gold, width: 1.5),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_ctrl.text.trim().isNotEmpty) {
              setState(() => _sent = true);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF6D879), Color(0xFFE0A92E)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFB9821F), width: 1.5),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 4)),
              ],
            ),
            child: Text(
              'Enviar',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 15, color: wine900),
            ),
          ),
        ),
      ],
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

  Widget _playAgainBtn() {
    return GestureDetector(
      onTap: widget.onReplay,
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
