import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/questions.dart';
import 'engine/fabi_engine.dart';
import 'models/game_state.dart';
import 'models/professor.dart';
import 'models/question.dart';
import 'screens/game_screen.dart';
import 'screens/guess_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lose_screen.dart';
import 'screens/win_screen.dart';
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
  int _minStep = 0;

  void _startGame() {
    final s = FabiEngine.init();
    setState(() {
      _state = s;
      _question = FabiEngine.pickQuestion(s);
      _mood = FabiMood.confident;
      _history.clear();
      _wrong = 0;
      _minStep = 0;
      _guess = null;
      _screen = _Screen.game;
    });
  }

  void _advance(GameState s, [double? lastValue]) {
    final noMoreQ = questions.length - s.asked.length <= 0;
    final readyToGuess = FabiEngine.shouldGuess(s) && s.step >= _minStep;

    if (noMoreQ || readyToGuess) {
      final top = FabiEngine.confidence(s).top;
      if (top == null || top.w <= 0.0001) {
        setState(() { _screen = _Screen.lose; _mood = FabiMood.shy; });
        return;
      }
      setState(() {
        _guess = top.prof;
        _mood = FabiMood.confident;
        _screen = _Screen.guess;
      });
    } else {
      setState(() {
        _question = FabiEngine.pickQuestion(s);
        if (lastValue != null) _mood = FabiEngine.moodFor(s, lastValue);
      });
    }
  }

  void _onAnswer(double value) {
    final s = _state!;
    final q = _question!;
    _history.add(_HistoryEntry(s, q));
    final ns = FabiEngine.answer(s, q.id, value);
    setState(() => _state = ns);
    _advance(ns, value);
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
    final weights = Map<String, double>.from(s.weights);
    weights[_guess!.id] = 0;
    final t = weights.values.fold(0.0, (a, b) => a + b);
    for (final id in weights.keys) {
      weights[id] = weights[id]! / (t == 0 ? 1 : t);
    }
    final ns = s.copyWith(weights: weights);
    setState(() => _state = ns);

    final remaining = FabiEngine.ranked(ns).where((r) => r.w > 0.0005).toList();
    final newWrong = _wrong + 1;
    _wrong = newWrong;

    if (newWrong >= 2 || remaining.isEmpty) {
      setState(() { _screen = _Screen.lose; _mood = FabiMood.shy; });
      return;
    }

    _minStep = ns.step + 2;
    setState(() { _mood = FabiMood.worried; _screen = _Screen.game; });
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
                    child: Center(child: _currentScreen()),
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

  Widget _topBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _langPill(),
            if (_screen != _Screen.home)
              GestureDetector(
                onTap: () => setState(() => _screen = _Screen.home),
                child: const Wordmark(fontSize: 36),
              ),
            Image.asset('assets/logo-donaduzzi.png',
                height: 32,
                colorBlendMode: BlendMode.srcIn,
                color: Colors.white.withValues(alpha: 0.92)),
          ],
        ),
      ),
    );
  }

  Widget _langPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
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
          const SizedBox(width: 8),
          Text('Português',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: wine800)),
        ],
      ),
    );
  }

  Widget _footer() {
    final links = ['Sobre o projeto', 'Como jogar', 'Professores', 'Curso de TI', 'Contato'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 6,
        children: [
          Image.asset('assets/logo-donaduzzi.png',
              height: 24,
              colorBlendMode: BlendMode.srcIn,
              color: Colors.white.withValues(alpha: 0.7)),
          ...links.map((l) => Text(l,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: cream.withValues(alpha: 0.7)))),
          Text('Projeto acadêmico · Faculdade Donaduzzi',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: cream.withValues(alpha: 0.5))),
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
        return LoseScreen(onReplay: _startGame);
    }
  }
}
