import 'dart:math';

import '../data/professors_data.dart';
import '../data/questions_data.dart';
import '../models/answer_option.dart';
import '../models/game_state.dart';
import '../models/professor.dart';
import '../models/question.dart';

class GuessResult {
  final Professor professor;
  final String confidenceLevel; // "alta" | "media" | "baixa"
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
        .map((m) => Question(
              id: m['id'] as String,
              text: m['text'] as String,
              category: m['category'] as String,
              minPhase: m['minPhase'] as int,
              isFixed: (m['isFixed'] as bool?) ?? false,
              funnyQuestion: (m['funnyQuestion'] as bool?) ?? false,
            ))
        .toList();
    return _cachedQuestions!;
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static List<Professor> _buildProfessors() {
    return ProfessorsData.all
        .map((m) => Professor(
              id: m['id'] as String,
              name: m['name'] as String,
              initials: _initials(m['name'] as String),
              answers: Map<String, bool>.from(m['answers'] as Map),
              score: 0.0,
            ))
        .toList();
  }

  // ── Public interface ───────────────────────────────────────────────────

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
    // Pergunta assinatura já confirmada → palpitar imediatamente
    if (state.signatureConfirmed) return null;

    // Pronto para palpitar → força pergunta exclusiva do líder antes de encerrar
    if (shouldGuess(state)) {
      return _signatureQuestion(state); // null → nenhuma exclusiva, palpitar
    }

    final available = _available(state);
    if (available.isEmpty) return null;

    final count = state.questionCount;

    // Pergunta 1 (count=0): sempre R1 (pergunta fixa obrigatória)
    if (count == 0) {
      return available.firstWhere((q) => q.isFixed, orElse: () => available.first);
    }

    // Pergunta 2 (count=1): geral aleatória
    if (count == 1) {
      final gerals = available.where((q) => q.category == 'geral' && !q.isFixed).toList();
      return _pickRandom(gerals.isNotEmpty ? gerals : available);
    }

    // Perguntas 3–6 (count=2..5): intermediárias aleatórias (base para identificar o líder)
    if (count < 6) {
      final inter = available.where((q) => q.category == 'intermediaria').toList();
      return _pickRandom(inter.isNotEmpty ? inter : available);
    }

    // count ≥ 6: modo dirigido — perguntas cujo líder responde "sim"
    return _pickLeaderDirected(state, available);
  }

  GameState applyAnswer(GameState state, Question q, AnswerOption answer) {
    final leader = state.leader;

    // 1. Atualizar pontuações de todos os professores
    // Usa a fase efetiva = max(fase atual, minPhase da pergunta)
    // Garante que perguntas definitivas feitas como "assinatura" em fase menor
    // sejam sempre pontuadas com o multiplicador correto de categoria.
    final effectivePhase = q.minPhase > state.currentPhase ? q.minPhase : state.currentPhase;
    final updated = state.professors.map((p) {
      final delta = _delta(answer, p.answers[q.id] ?? false, effectivePhase);
      return Professor(
        id: p.id,
        name: p.name,
        initials: p.initials,
        answers: p.answers,
        score: p.score + delta,
      );
    }).toList();

    // 2. Calcular novo gap após atualização (usado para confirmação e fase)
    final sortedActive = updated.where((p) => p.isActive).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    final newLeader = sortedActive.isNotEmpty ? sortedActive.first : null;
    final newGap = sortedActive.length >= 2
        ? sortedActive[0].score - sortedActive[1].score
        : double.infinity;

    // 3. Detectar confirmação
    final isSignature = leader != null &&
        state.activeProfessors.where((p) => p.answers[q.id] == true).length == 1 &&
        (leader.answers[q.id] ?? false);

    final bool confirmedNow;
    if (isSignature &&
        (answer == AnswerOption.sim || answer == AnswerOption.provavelmenteSim)) {
      // Pergunta exclusiva do líder confirmada com sim/provavelmente sim
      confirmedNow = true;
    } else if (q.category == 'definitiva' &&
               (leader?.answers[q.id] ?? false) &&
               leader?.id == newLeader?.id &&
               answer == AnswerOption.sim &&
               newGap >= 16.0) {
      // Pergunta definitiva respondida "sim" com líder bem isolado
      confirmedNow = true;
    } else {
      confirmedNow = false;
    }

    // 4. Atualizar contadores
    final newAsked = [...state.askedIds, q.id];
    final newCount = state.questionCount + 1;
    final newConsecutive =
        answer == AnswerOption.naoSei ? state.consecutiveNaoSei + 1 : 0;

    // 5. Transição de fase
    final newPhase = _nextPhase(
      current: state.currentPhase,
      count: newCount,
      gap: newGap,
      consecutive: newConsecutive,
    );
    final finalConsecutive = newPhase > state.currentPhase ? 0 : newConsecutive;

    return GameState(
      currentPhase: newPhase,
      questionCount: newCount,
      askedIds: newAsked,
      professors: updated,
      consecutiveNaoSei: finalConsecutive,
      signatureConfirmed: state.signatureConfirmed || confirmedNow,
    );
  }

  bool shouldGuess(GameState state) {
    if (state.signatureConfirmed) return true;

    final gap = state.leaderGap;
    final count = state.questionCount;

    if (gap >= 16.0 && count >= 8) return true;   // confiança alta
    if (gap >= 10.0 && count >= 10) return true;  // confiança média
    if (count >= 15) return true;                  // esgotamento
    if (_available(state).isEmpty && count > 0) return true;

    return false;
  }

  GuessResult buildGuess(GameState state) {
    final active = state.activeProfessors;
    final all = List<Professor>.from(state.professors)
      ..sort((a, b) => b.score.compareTo(a.score));

    final prof = active.isNotEmpty ? active.first : all.first;
    final gap = state.leaderGap;
    final count = state.questionCount;

    final String level;
    if (state.signatureConfirmed || (gap >= 16.0 && count >= 8)) {
      level = 'alta';
    } else if (gap >= 10.0 && count >= 10) {
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

  // ── Internal helpers ───────────────────────────────────────────────────

  // Pergunta exclusiva: somente o líder responde "sim" entre os ativos.
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

  // Seleção dirigida: perguntas que o líder atual responde "sim", em ordem de categoria.
  // count 6–8: prioriza intermediárias → depois específicas
  // count ≥ 9: prioriza quase_especifica → definitiva → intermediária (fallback)
  Question _pickLeaderDirected(GameState state, List<Question> available) {
    final leader = state.leader;
    if (leader == null) return _pickByGini(state, available, fallback: available);

    final count = state.questionCount;

    // Filtra perguntas onde o líder responde "sim"
    final leaderYes = available.where((q) => leader.answers[q.id] == true).toList();
    if (leaderYes.isEmpty) {
      // Sem perguntas favoráveis ao líder → Gini para tentar diferenciar
      return _pickByGini(state, available, fallback: available);
    }

    final cats = count < 9
        ? ['intermediaria', 'quase_especifica', 'definitiva']
        : ['quase_especifica', 'definitiva', 'intermediaria'];

    for (final cat in cats) {
      final catQ = leaderYes.where((q) => q.category == cat).toList();
      if (catQ.isNotEmpty) return catQ[_rng.nextInt(catQ.length)];
    }

    return leaderYes[_rng.nextInt(leaderYes.length)];
  }

  List<Question> _available(GameState state) {
    return _questions.where((q) {
      if (state.askedIds.contains(q.id)) return false;
      if (q.minPhase > state.currentPhase) return false;
      if (q.funnyQuestion && state.currentPhase < 3) return false;
      return true;
    }).toList();
  }

  Question? _pickRandom(List<Question> pool) {
    if (pool.isEmpty) return null; // null → nextQuestion devolve null → dispara palpite
    return pool[_rng.nextInt(pool.length)];
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
    final applyBias = state.leaderGap >= 3.0;

    double bestScore = -1;
    final topGroup = <Question>[];

    for (final q in pool) {
      double score = _gini(q, active);
      if (applyBias && leader != null && (leader.answers[q.id] ?? false)) {
        score += 0.15;
      }
      if ((score - bestScore).abs() < 0.05) {
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
    final n = candidates.length;
    if (n == 0) return 0;
    final simCount = candidates.where((p) => p.answers[q.id] == true).length;
    final pSim = simCount / n;
    final pNao = (n - simCount) / n;
    return 1.0 - (pSim * pSim + pNao * pNao);
  }

  // Multiplicadores por fase: fase 2 levemente reduzida para não eliminar professores cedo demais
  static const _phaseMultiplier = {1: 1.0, 2: 1.5, 3: 3.5, 4: 6.0};

  double _delta(AnswerOption answer, bool profAnswerIsTrue, int phase) {
    final m = _phaseMultiplier[phase] ?? 1.0;
    switch (answer) {
      case AnswerOption.sim:
        // "sim": professores com resposta "sim" sobem; com "não" descem muito
        return profAnswerIsTrue ? 4.0 * m : -4.0 * m;
      case AnswerOption.provavelmenteSim:
        return profAnswerIsTrue ? 2.5 * m : -1.0 * m;
      case AnswerOption.naoSei:
        return 0.0;
      case AnswerOption.provavelmenteNao:
        return profAnswerIsTrue ? -0.5 * m : 1.0 * m;
      case AnswerOption.nao:
        // "não": professores com resposta "não" sobem; com "sim" descem muito
        return profAnswerIsTrue ? -4.0 * m : 4.0 * m;
    }
  }

  int _nextPhase({
    required int current,
    required int count,
    required double gap,
    required int consecutive,
  }) {
    if (current >= 4) return 4;

    // 3 "não sei" consecutivos → forçar avanço
    if (consecutive >= 3) return (current + 1).clamp(1, 4);

    switch (current) {
      case 1:
        // Avança para fase 2 (intermediárias) após 2 perguntas gerais
        return count >= 2 ? 2 : 1;
      case 2:
        // Avança para fase 3 (quase_especifica desbloqueada) ao entrar no modo dirigido
        return count >= 6 ? 3 : 2;
      case 3:
        // Avança para fase 4 (definitivas desbloqueadas) com líder isolado ou após 9 perguntas
        return (gap >= 14.0 && count >= 7) || count >= 9 ? 4 : 3;
      default:
        return current;
    }
  }
}
