class Question {
  final String id;
  final String text;
  final String category;
  final int minPhase;
  final bool isFixed;
  final bool funnyQuestion;

  const Question({
    required this.id,
    required this.text,
    this.category = 'geral',
    this.minPhase = 1,
    this.isFixed = false,
    this.funnyQuestion = false,
  });
}
