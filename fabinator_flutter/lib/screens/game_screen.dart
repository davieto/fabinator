import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../engine/fabi_engine.dart';
import '../models/game_state.dart';
import '../models/question.dart';
import '../theme/colors.dart';
import '../widgets/fabi_character.dart';

class _Answer {
  final String label;
  final double value;
  const _Answer(this.label, this.value);
}

const _answers = [
  _Answer('Sim', 1.0),
  _Answer('Não', 0.0),
  _Answer('Não sei', 0.5),
  _Answer('Provavelmente sim', 0.75),
  _Answer('Provavelmente não', 0.25),
];

class GameScreen extends StatefulWidget {
  final GameState state;
  final Question question;
  final FabiMood mood;
  final void Function(double value) onAnswer;
  final VoidCallback onUndo;
  final bool canUndo;

  const GameScreen({
    super.key,
    required this.state,
    required this.question,
    required this.mood,
    required this.onAnswer,
    required this.onUndo,
    required this.canUndo,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 700;

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FabiCharacter(mood: widget.mood, height: 380),
          const SizedBox(width: 40),
          Flexible(child: _mainContent()),
        ],
      );
    }

    // Narrow: character fixo no topo, perguntas+respostas roláveis,
    // barra de progresso+corrigir sempre visível na parte de baixo
    return Column(
      children: [
        FabiCharacter(mood: widget.mood, height: 160),
        const SizedBox(height: 6),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _questionRow(),
                  const SizedBox(height: 16),
                  _answersPanel(),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
          child: _footer(),
        ),
      ],
    );
  }

  Widget _mainContent() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 580),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _questionRow(),
          const SizedBox(height: 20),
          _answersPanel(),
          const SizedBox(height: 20),
          _footer(),
        ],
      ),
    );
  }

  Widget _questionRow() {
    final num = widget.state.step + 1;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 58,
            decoration: const BoxDecoration(
              color: wine800,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
            ),
            alignment: Alignment.center,
            child: Text(
              '$num',
              style: GoogleFonts.lilitaOne(fontSize: 26, color: goldLight),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFCF6EA), Color(0xFFEFE0C6)],
                ),
                borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, 8)),
                ],
              ),
              child: Text(
                widget.question.text,
                style: GoogleFonts.spectral(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: ink,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _answersPanel() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFCF6EA), Color(0xFFF3E2CB)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA9741A).withValues(alpha:0.4)),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 36, offset: Offset(0, 16)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: List.generate(_answers.length, (i) {
            final a = _answers[i];
            final hovered = _hoveredIndex == i;
            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = i),
              onExit: (_) => setState(() => _hoveredIndex = null),
              child: GestureDetector(
                onTap: () => widget.onAnswer(a.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: hovered
                        ? const Color(0xFFE0A92E).withValues(alpha:0.18)
                        : Colors.transparent,
                    border: i > 0
                        ? Border(
                            top: BorderSide(
                              color: const Color(0xFFA9741A).withValues(alpha:0.18),
                            ),
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        a.label,
                        style: GoogleFonts.spectral(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: hovered ? crimson : wine800,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: hovered ? 1.0 : 0.0,
                        child: Text('»',
                            style: GoogleFonts.spectral(
                              fontSize: 20,
                              color: goldDeep,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _footer() {
    final step = widget.state.step;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // progress dots
        Row(
          children: [
            ...List.generate(step.clamp(0, 12), (_) => _dot(true)),
            if (step < 12) _dot(false),
          ],
        ),
        // undo
        Opacity(
          opacity: widget.canUndo ? 1.0 : 0.4,
          child: GestureDetector(
            onTap: widget.canUndo ? widget.onUndo : null,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: wine800,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 6)),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text('←',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Text('CORRIGIR',
                    style: GoogleFonts.spectral(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: cream,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dot(bool on) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? goldLight : goldLight.withValues(alpha:0.25),
        boxShadow: on
            ? [BoxShadow(color: goldLight.withValues(alpha:0.7), blurRadius: 8)]
            : null,
      ),
    );
  }
}
