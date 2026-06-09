class GameState {
  final Map<String, double> weights;
  final List<String> asked;
  final int step;

  const GameState({
    required this.weights,
    required this.asked,
    required this.step,
  });

  GameState copyWith({
    Map<String, double>? weights,
    List<String>? asked,
    int? step,
  }) {
    return GameState(
      weights: weights ?? Map.from(this.weights),
      asked: asked ?? List.from(this.asked),
      step: step ?? this.step,
    );
  }
}
