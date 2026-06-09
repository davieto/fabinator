import '../models/professor.dart';

final professors = [
  Professor(
    id: 'ricardo', name: 'Prof. Ricardo Lima', initials: 'RL',
    area: 'Banco de Dados', tagline: 'O senhor do SQL — e do cafezinho.',
    attributes: {
      'mulher': 0, 'oculos': 1, 'barba': 1, 'jovem': 0, 'veterano': 1,
      'dados': 1, 'programacao': 0.5, 'exigente': 1, 'cafe': 1,
      'pontual': 1, 'grupo': 0.5,
    },
  ),
  Professor(
    id: 'aline', name: 'Profa. Aline Souza', initials: 'AS',
    area: 'Front-end & UX', tagline: 'Pixel perfeito e meme no slide.',
    attributes: {
      'mulher': 1, 'oculos': 1, 'barba': 0, 'jovem': 1, 'veterano': 0,
      'design': 1, 'programacao': 1, 'descontraido': 1, 'memes': 1,
      'cafe': 1, 'tatuagem': 0.5,
    },
  ),
  Professor(
    id: 'bruno', name: 'Prof. Bruno Carvalho', initials: 'BC',
    area: 'Redes & Infraestrutura', tagline: 'Se a rede caiu, a culpa não é dele.',
    attributes: {
      'mulher': 0, 'oculos': 0, 'barba': 0.5, 'jovem': 0, 'veterano': 1,
      'redes': 1, 'careca': 1, 'pontual': 1, 'exigente': 0.5,
    },
  ),
  Professor(
    id: 'camila', name: 'Profa. Camila Rocha', initials: 'CR',
    area: 'Programação Python', tagline: 'Paciência infinita, indentação obrigatória.',
    attributes: {
      'mulher': 1, 'oculos': 1, 'barba': 0, 'jovem': 0, 'veterano': 1,
      'programacao': 1, 'dados': 0.5, 'grupo': 1, 'descontraido': 0.5, 'memes': 0.5,
    },
  ),
  Professor(
    id: 'diego', name: 'Prof. Diego Fernandes', initials: 'DF',
    area: 'Mobile & Games', tagline: 'Entrega o app e o boss final.',
    attributes: {
      'mulher': 0, 'oculos': 0, 'barba': 1, 'jovem': 1, 'veterano': 0,
      'mobile': 1, 'programacao': 1, 'gamer': 1, 'tatuagem': 1,
      'descontraido': 1, 'memes': 1,
    },
  ),
  Professor(
    id: 'helena', name: 'Profa. Helena Martins', initials: 'HM',
    area: 'Engenharia de Software', tagline: 'Cronograma, escopo e zero atraso.',
    attributes: {
      'mulher': 1, 'oculos': 1, 'barba': 0, 'jovem': 0, 'veterano': 1,
      'gestao': 1, 'grupo': 1, 'exigente': 1, 'pontual': 1,
    },
  ),
];
