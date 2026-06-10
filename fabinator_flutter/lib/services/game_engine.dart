import 'dart:math';

import '../data/professors_data.dart';
import '../data/questions_data.dart';
import '../models/answer_option.dart';
import '../models/game_state.dart';
import '../models/professor.dart';
import '../models/question.dart';

class GuessResult {
  final Professor professor;
  final String confidenceLevel;
  final int questionsUsed;

  const GuessResult({
    required this.professor,
    required this.confidenceLevel,
    required this.questionsUsed,
  });
}

class GameEngine {
  final Random _rng = Random();

  static List<Question>? _cachedQuestions;

  static List<Question> get _questions {
    _cachedQuestions ??= QuestionsData.all
        .map(
          (m) => Question(
            id: m['id'] as String,
            text: m['text'] as String,
            category: m['category'] as String,
            minPhase: m['minPhase'] as int,
            isFixed: (m['isFixed'] as bool?) ?? false,
            funnyQuestion: (m['funnyQuestion'] as bool?) ?? false,
          ),
        )
        .toList();
    return _cachedQuestions!;
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static List<Professor> _buildProfessors() {
    final profs = ProfessorsData.all
        .map(
          (m) => Professor(
            id: m['id'] as String,
            name: m['name'] as String,
            initials: _initials(m['name'] as String),
            answers: Map<String, bool>.from(m['answers'] as Map),
          ),
        )
        .toList();
    final p0 = 1.0 / profs.length;
    for (final p in profs) {
      p.probability = p0;
    }
    return profs;
  }


  GameState startGame() {
    return GameState(
      currentPhase: 1,
      questionCount: 0,
      askedIds: const <String>[],
      professors: _buildProfessors(),
      consecutiveNaoSei: 0,
    );
  }

  Question? nextQuestion(GameState state) {
    if (state.signatureConfirmed) return null;

    if (shouldGuess(state)) {
      return _signatureQuestion(state); 
    }

    final available = _available(state);
    if (available.isEmpty) return null;

    if (state.questionCount == 0) {
      return available.firstWhere(
        (q) => q.isFixed,
        orElse: () => available.first,
      );
    }

    return _pickByGini(state, available, fallback: available);
  }

  static const double _eps = 0.05;

  double _playerLikelihood(AnswerOption answer) {
    switch (answer) {
      case AnswerOption.sim:
        return 1.0 - _eps;
      case AnswerOption.provavelmenteSim:
        return 0.75;
      case AnswerOption.naoSei:
        return 0.5;
      case AnswerOption.provavelmenteNao:
        return 0.25;
      case AnswerOption.nao:
        return _eps;
    }
  }

  static const _categoryWeight = {
    'geral': 1.0,
    'intermediaria': 1.5,
    'quase_especifica': 3.5,
    'definitiva': 6.0,
  };

  static const double _eliminationThreshold = 0.005;

  static const double _confirmProbability = 0.6;

  GameState applyAnswer(GameState state, Question q, AnswerOption answer) {
    final leader = state.leader;

    final pPlayer = _playerLikelihood(answer);
    final weight = _categoryWeight[q.category] ?? 1.0;
    final updated = state.professors.map((p) {
      if (p.eliminated) return p;
      final profIsTrue = p.answers[q.id] ?? false;
      final likelihood = profIsTrue ? pPlayer : (1.0 - pPlayer);
      return Professor(
        id: p.id,
        name: p.name,
        initials: p.initials,
        answers: p.answers,
        probability: p.probability * pow(likelihood, weight),
        eliminated: false,
      );
    }).toList();

    final activeSum = updated
        .where((p) => !p.eliminated)
        .fold<double>(0.0, (s, p) => s + p.probability);
    final renorm = updated.map((p) {
      if (p.eliminated || activeSum <= 0) return p;
      final newProb = p.probability / activeSum;
      return Professor(
        id: p.id,
        name: p.name,
        initials: p.initials,
        answers: p.answers,
        probability: newProb,
        eliminated: newProb < _eliminationThreshold,
      );
    }).toList();

    final sortedActive = renorm.where((p) => p.isActive).toList()
      ..sort((a, b) => b.probability.compareTo(a.probability));
    final newLeader = sortedActive.isNotEmpty ? sortedActive.first : null;
    final newRatio = sortedActive.length >= 2 && sortedActive[1].probability > 0
        ? sortedActive[0].probability / sortedActive[1].probability
        : double.infinity;

    final isSignature =
        leader != null &&
        state.activeProfessors.where((p) => p.answers[q.id] == true).length ==
            1 &&
        (leader.answers[q.id] ?? false);

    final bool confirmedNow;
    if (isSignature &&
        (answer == AnswerOption.sim ||
            answer == AnswerOption.provavelmenteSim)) {
      confirmedNow = true;
    } else if (q.category == 'definitiva' &&
        (leader?.answers[q.id] ?? false) &&
        leader?.id == newLeader?.id &&
        answer == AnswerOption.sim &&
        (newLeader?.probability ?? 0) >= _confirmProbability) {
      confirmedNow = true;
    } else {
      confirmedNow = false;
    }

    final newAsked = [...state.askedIds, q.id];
    final newCount = state.questionCount + 1;
    final newConsecutive = answer == AnswerOption.naoSei
        ? state.consecutiveNaoSei + 1
        : 0;

    final newPhase = _nextPhase(
      current: state.currentPhase,
      count: newCount,
      ratio: newRatio,
      consecutive: newConsecutive,
    );
    final finalConsecutive = newPhase > state.currentPhase ? 0 : newConsecutive;

    return GameState(
      currentPhase: newPhase,
      questionCount: newCount,
      askedIds: newAsked,
      professors: renorm,
      consecutiveNaoSei: finalConsecutive,
      signatureConfirmed: state.signatureConfirmed || confirmedNow,
    );
  }

  GameState eliminateGuess(GameState state, String professorId) {
    final updated = state.professors.map((p) {
      if (p.id == professorId) {
        return Professor(
          id: p.id,
          name: p.name,
          initials: p.initials,
          answers: p.answers,
          probability: 0.0,
          eliminated: true,
        );
      }
      return p;
    }).toList();

    final activeSum = updated
        .where((p) => !p.eliminated)
        .fold<double>(0.0, (s, p) => s + p.probability);
    final renorm = updated.map((p) {
      if (p.eliminated || activeSum <= 0) return p;
      return Professor(
        id: p.id,
        name: p.name,
        initials: p.initials,
        answers: p.answers,
        probability: p.probability / activeSum,
        eliminated: false,
      );
    }).toList();

    return state.copyWith(professors: renorm, signatureConfirmed: false);
  }

  static const double _guessRatio = 2.0;

  static const double _minLeaderProbability = 0.30;

  bool shouldGuess(GameState state) {
    if (state.signatureConfirmed) return true;

    final active = state.activeProfessors; 
    final count = state.questionCount;

    if (_available(state).isEmpty && count > 0) return true;

    if (count < 6 || active.isEmpty) return false;

    if (active.length == 1) return true;

    final leaderProb = active[0].probability;
    final secondProb = active[1].probability;

    if (leaderProb < _minLeaderProbability) return false;

    return leaderProb >= _guessRatio * secondProb;
  }

  GuessResult buildGuess(GameState state) {
    final active = state.activeProfessors;
    final all = List<Professor>.from(state.professors)
      ..sort((a, b) => b.probability.compareTo(a.probability));

    final prof = active.isNotEmpty ? active.first : all.first;
    final count = state.questionCount;
    final leaderProb = active.isNotEmpty ? active[0].probability : 0.0;

    final String level;
    if (state.signatureConfirmed || leaderProb >= 0.6) {
      level = 'alta';
    } else if (leaderProb >= 0.35) {
      level = 'media';
    } else {
      level = 'baixa';
    }

    return GuessResult(
      professor: prof,
      confidenceLevel: level,
      questionsUsed: count,
    );
  }

    Question? _signatureQuestion(GameState state) {
    final leader = state.leader;
    if (leader == null) return null;
    final active = state.activeProfessors;
    for (final q in _questions) {
      if (state.askedIds.contains(q.id)) continue;
      final trueCount = active.where((p) => p.answers[q.id] == true).length;
      if (trueCount == 1 && (leader.answers[q.id] ?? false)) return q;
    }
    return null;
  }

  List<Question> _available(GameState state) {
    return _questions.where((q) {
      if (state.askedIds.contains(q.id)) return false;
      if (q.minPhase > state.currentPhase) return false;
      if (q.funnyQuestion && state.currentPhase < 3) return false;
      return true;
    }).toList();
  }

  Question _pickByGini(
    GameState state,
    List<Question> candidates, {
    required List<Question> fallback,
  }) {
    final pool = candidates.isNotEmpty ? candidates : fallback;
    if (pool.isEmpty) return fallback.first;

    final active = state.activeProfessors;
    final leader = state.leader;
    final applyBias = state.leaderRatio.isFinite && state.leaderRatio >= 1.5;

    double bestScore = -1;
    final topGroup = <Question>[];

    for (final q in pool) {
      double score = _gini(q, active);
      if (applyBias && leader != null && (leader.answers[q.id] ?? false)) {
        score += 0.05;
      }
      if ((score - bestScore).abs() < 0.01) {
        topGroup.add(q);
      } else if (score > bestScore) {
        bestScore = score;
        topGroup
          ..clear()
          ..add(q);
      }
    }

    if (topGroup.isEmpty) return pool.first;
    return topGroup[_rng.nextInt(topGroup.length)];
  }


  double _gini(Question q, List<Professor> candidates) {
    double total = 0;
    double simWeight = 0;
    for (final p in candidates) {
      total += p.probability;
      if (p.answers[q.id] == true) simWeight += p.probability;
    }
    if (total <= 0) return 0;
    final pSim = simWeight / total;
    final pNao = 1.0 - pSim;
    return 1.0 - (pSim * pSim + pNao * pNao);
  }

  int _nextPhase({
    required int current,
    required int count,
    required double ratio,
    required int consecutive,
  }) {
    if (current >= 4) return 4;


    if (consecutive >= 3) return (current + 1).clamp(1, 4);

    switch (current) {
      case 1:
        return count >= 2 ? 2 : 1;
      case 2:
        return count >= 6 ? 3 : 2;
      case 3:
        return (ratio >= 3.0 && count >= 7) || count >= 9 ? 4 : 3;
      default:
        return current;
    }
  }
}
