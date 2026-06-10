import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/fabi_mood.dart';
import 'models/answer_option.dart';
import 'models/game_state.dart';
import 'models/professor.dart';
import 'models/question.dart';
import 'screens/como_jogar_screen.dart';
import 'screens/game_screen.dart';
import 'screens/guess_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lose_screen.dart';
import 'screens/professores_screen.dart';
import 'screens/sobre_screen.dart';
import 'screens/win_screen.dart';
import 'services/game_engine.dart';
import 'theme/colors.dart';
import 'widgets/background.dart';
import 'widgets/wordmark.dart';

enum _Screen { home, game, guess, win, lose }

class _HistoryEntry {
  final GameState state;
  final Question question;
  _HistoryEntry(this.state, this.question);
}

class FabiNatorApp extends StatefulWidget {
  const FabiNatorApp({super.key});

  @override
  State<FabiNatorApp> createState() => _FabiNatorAppState();
}

class _FabiNatorAppState extends State<FabiNatorApp> {
  _Screen _screen = _Screen.home;
  GameState? _state;
  Question? _question;
  FabiMood _mood = FabiMood.confident;
  Professor? _guess;
  final List<_HistoryEntry> _history = [];
  int _wrong = 0;
  String? _loseMessage;
  final _engine = GameEngine();

  void _startGame() {
    final s = _engine.startGame();
    final q = _engine.nextQuestion(s);
    setState(() {
      _state = s;
      _question = q;
      _mood = FabiMood.confident;
      _history.clear();
      _wrong = 0;
      _loseMessage = null;
      _guess = null;
      _screen = _Screen.game;
    });
  }

  AnswerOption _toOption(double value) {
    if (value >= 0.9) return AnswerOption.sim;
    if (value >= 0.625) return AnswerOption.provavelmenteSim;
    if (value >= 0.375) return AnswerOption.naoSei;
    if (value >= 0.125) return AnswerOption.provavelmenteNao;
    return AnswerOption.nao;
  }

  FabiMood _moodFor(AnswerOption answer) {
    switch (answer) {
      case AnswerOption.sim:
      case AnswerOption.provavelmenteSim:
        return FabiMood.confident;
      case AnswerOption.naoSei:
        return FabiMood.worried;
      case AnswerOption.provavelmenteNao:
      case AnswerOption.nao:
        return FabiMood.shy;
    }
  }

  void _advance(GameState s) {
    final next = _engine.nextQuestion(s);
    if (next != null) {
      setState(() { _question = next; });
      return;
    }
    // nextQuestion retornou null: hora de palpitar (pergunta assinatura já foi
    // feita, ou não existe nenhuma exclusiva do líder).
    if (s.activeProfessors.isNotEmpty) {
      final result = _engine.buildGuess(s);
      setState(() {
        _guess = result.professor;
        _mood = FabiMood.confident;
        _screen = _Screen.guess;
      });
    } else {
      setState(() { _screen = _Screen.lose; _mood = FabiMood.shy; });
    }
  }

  void _onAnswer(double value) {
    final s = _state!;
    final q = _question!;
    final answer = _toOption(value);

    // Caso especial: primeira pergunta respondida com Não
    if (q.id == 'R1' && answer == AnswerOption.nao) {
      setState(() {
        _loseMessage = 'Infelizmente só temos professores para adivinhar 😢';
        _screen = _Screen.lose;
        _mood = FabiMood.shy;
      });
      return;
    }

    _history.add(_HistoryEntry(s, q));
    var ns = _engine.applyAnswer(s, q, answer);
    // Sync step with questionCount so GameScreen progress dots work correctly
    ns = ns.copyWith(step: ns.questionCount);

    setState(() {
      _state = ns;
      _mood = _moodFor(answer);
    });
    _advance(ns);
  }

  void _onUndo() {
    if (_history.isEmpty) return;
    final last = _history.removeLast();
    setState(() {
      _state = last.state;
      _question = last.question;
      _screen = _Screen.game;
      _mood = FabiMood.confident;
    });
  }

  void _onGuessYes() {
    setState(() { _screen = _Screen.win; _mood = FabiMood.smile; });
  }

  void _onGuessNo() {
    final s = _state!;
    // Elimina o professor do palpite errado e renormaliza as probabilidades dos demais
    final ns = _engine.eliminateGuess(s, _guess!.id);
    final newWrong = _wrong + 1;
    _wrong = newWrong;

    if (newWrong >= 2 || ns.activeProfessors.isEmpty) {
      setState(() { _screen = _Screen.lose; _mood = FabiMood.shy; });
      return;
    }

    setState(() {
      _state = ns;
      _mood = FabiMood.worried;
      _screen = _Screen.game;
    });
    _advance(ns);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Background(),
          Column(
            children: [
              _topBar(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: Padding(
                    key: ValueKey(_screen),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: _screen == _Screen.game
                        ? _currentScreen()
                        : Center(child: _currentScreen()),
                  ),
                ),
              ),
              _footer(),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateDirect(String label) {
    Widget? dest;
    if (label == 'Sobre o projeto') dest = const SobreScreen();
    if (label == 'Como jogar')      dest = const ComoJogarScreen();
    if (label == 'Professores')     dest = const ProfessoresScreen();
    if (dest != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => dest!));
    }
  }

  void _navigate(String label) {
    Navigator.pop(context);
    Widget? dest;
    if (label == 'Sobre o projeto') dest = const SobreScreen();
    if (label == 'Como jogar')      dest = const ComoJogarScreen();
    if (label == 'Professores')     dest = const ProfessoresScreen();
    if (dest != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => dest!));
    }
  }

  static const _navLinks = [
    (label: 'Sobre o projeto', icon: Icons.info_outline),
    (label: 'Como jogar',      icon: Icons.quiz_outlined),
    (label: 'Professores',     icon: Icons.people_outline),
    (label: 'Curso de TI',     icon: Icons.computer_outlined),
    (label: 'Contato',         icon: Icons.mail_outline),
  ];

  void _openMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCF6EA), Color(0xFFF1E2C8)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: wine800.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Image.asset('assets/logo-donaduzzi.png',
                  height: 28,
                  colorBlendMode: BlendMode.srcIn,
                  color: wine800.withValues(alpha: 0.8)),
              const SizedBox(height: 12),
              ..._navLinks.map((item) => InkWell(
                onTap: () => _navigate(item.label),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 24),
                  child: Row(
                    children: [
                      Icon(item.icon, color: crimson, size: 20),
                      const SizedBox(width: 12),
                      Text(item.label,
                          style: GoogleFonts.spectral(
                              fontSize: 17, fontWeight: FontWeight.w600, color: wine800)),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: inkSoft, size: 18),
                    ],
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                child: Text('Projeto acadêmico · Faculdade Donaduzzi',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: inkSoft.withValues(alpha: 0.7))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    final isWide = MediaQuery.sizeOf(context).width > 500;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            _langPill(compact: !isWide),
            if (_screen != _Screen.home) ...[
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _screen = _Screen.home),
                  child: Center(child: Wordmark(fontSize: isWide ? 36 : 26)),
                ),
              ),
              const SizedBox(width: 8),
            ] else
              const Spacer(),
            if (isWide)
              Image.asset(
                'assets/logo-donaduzzi.png',
                height: 28,
                colorBlendMode: BlendMode.srcIn,
                color: Colors.white.withValues(alpha: 0.92),
              )
            else
              GestureDetector(
                onTap: _openMenu,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.menu, color: Colors.white, size: 26),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _langPill({bool compact = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 16, vertical: compact ? 7 : 9),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCF6EA), Color(0xFFEBD9B6)],
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
            color: const Color(0xFFA9741A).withValues(alpha: 0.45), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🇧🇷', style: TextStyle(fontSize: 16)),
          if (!compact) ...[
            const SizedBox(width: 8),
            Text('Português',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600, color: wine800)),
          ],
        ],
      ),
    );
  }

  Widget _footer() {
    final isWide = MediaQuery.sizeOf(context).width > 500;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: isWide
          ? Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 6,
              children: [
                Image.asset('assets/logo-donaduzzi.png',
                    height: 22,
                    colorBlendMode: BlendMode.srcIn,
                    color: Colors.white.withValues(alpha: 0.7)),
                ..._navLinks.map((item) => GestureDetector(
                    onTap: () => _navigateDirect(item.label),
                    child: Text(item.label,
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: cream.withValues(alpha: 0.7))))),
                Text('Projeto acadêmico · Faculdade Donaduzzi',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: cream.withValues(alpha: 0.5))),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo-donaduzzi.png',
                    height: 20,
                    colorBlendMode: BlendMode.srcIn,
                    color: Colors.white.withValues(alpha: 0.6)),
                const SizedBox(width: 10),
                Text('Projeto acadêmico · Faculdade Donaduzzi',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: cream.withValues(alpha: 0.5))),
              ],
            ),
    );
  }

  Widget _currentScreen() {
    switch (_screen) {
      case _Screen.home:
        return HomeScreen(onPlay: _startGame);
      case _Screen.game:
        return GameScreen(
          state: _state!,
          question: _question!,
          mood: _mood,
          onAnswer: _onAnswer,
          onUndo: _onUndo,
          canUndo: _history.isNotEmpty,
        );
      case _Screen.guess:
        return GuessScreen(
          prof: _guess!,
          mood: _mood,
          onYes: _onGuessYes,
          onNo: _onGuessNo,
        );
      case _Screen.win:
        return WinScreen(prof: _guess!, onReplay: _startGame);
      case _Screen.lose:
        return LoseScreen(onReplay: _startGame, message: _loseMessage);
    }
  }
}
