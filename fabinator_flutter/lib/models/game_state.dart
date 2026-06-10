import 'professor.dart';

class GameState {
  final int step;
  final int currentPhase;
  final int questionCount;
  final List<String> askedIds;
  final List<Professor> professors;
  final int consecutiveNaoSei;
  // true quando a pergunta exclusiva do líder foi respondida com sim/provavelmente sim
  final bool signatureConfirmed;

  GameState({
    this.step = 0,
    this.currentPhase = 1,
    this.questionCount = 0,
    this.askedIds = const <String>[],
    this.professors = const <Professor>[],
    this.consecutiveNaoSei = 0,
    this.signatureConfirmed = false,
  });

  List<Professor> get activeProfessors =>
      professors.where((p) => p.isActive).toList()
        ..sort((a, b) => b.score.compareTo(a.score));

  Professor? get leader =>
      activeProfessors.isNotEmpty ? activeProfessors.first : null;

  double get leaderGap {
    final active = activeProfessors;
    if (active.length < 2) return double.infinity;
    return active[0].score - active[1].score;
  }

  GameState copyWith({
    int? step,
    int? currentPhase,
    int? questionCount,
    List<String>? askedIds,
    List<Professor>? professors,
    int? consecutiveNaoSei,
    bool? signatureConfirmed,
  }) {
    return GameState(
      step: step ?? this.step,
      currentPhase: currentPhase ?? this.currentPhase,
      questionCount: questionCount ?? this.questionCount,
      askedIds: askedIds ?? List<String>.from(this.askedIds),
      professors: professors ?? List<Professor>.from(this.professors),
      consecutiveNaoSei: consecutiveNaoSei ?? this.consecutiveNaoSei,
      signatureConfirmed: signatureConfirmed ?? this.signatureConfirmed,
    );
  }
}
