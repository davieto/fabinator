class Professor {
  final String id;
  final String name;
  final String initials;
  final String area;
  final String tagline;
  final Map<String, double> attributes;
  final Map<String, bool> answers;
  double probability;
  bool eliminated;

  Professor({
    required this.id,
    required this.name,
    this.initials = '',
    this.area = '',
    this.tagline = '',
    this.attributes = const <String, double>{},
    this.answers = const <String, bool>{},
    this.probability = 0.0,
    this.eliminated = false,
  });

  double attr(String qid) {
    if (attributes.containsKey(qid)) return attributes[qid]!;
    if (answers.containsKey(qid)) return answers[qid]! ? 1.0 : 0.0;
    return 0.5;
  }

  // Eliminação é definitiva: uma vez descartado, o professor não volta a
  // entrar na renormalização de probabilidade mesmo que sua chance relativa
  // pudesse subir depois.
  bool get isActive => !eliminated;
}
