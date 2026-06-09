class Professor {
  final String id;
  final String name;
  final String initials;
  final String area;
  final String tagline;
  final Map<String, double> attributes;

  const Professor({
    required this.id,
    required this.name,
    required this.initials,
    required this.area,
    required this.tagline,
    required this.attributes,
  });

  double attr(String qid) => attributes[qid] ?? 0.0;
}
