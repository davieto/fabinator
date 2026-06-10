enum AnswerOption {
  sim,
  provavelmenteSim,
  naoSei,
  provavelmenteNao,
  nao,
}

extension AnswerOptionLabel on AnswerOption {
  String get label {
    switch (this) {
      case AnswerOption.sim:
        return 'Sim';
      case AnswerOption.provavelmenteSim:
        return 'Provavelmente sim';
      case AnswerOption.naoSei:
        return 'Não sei';
      case AnswerOption.provavelmenteNao:
        return 'Provavelmente não';
      case AnswerOption.nao:
        return 'Não';
    }
  }
}
