/* ============ FabiNator — professores de exemplo (curso de TI) ============
   Atributos por pergunta: 1 = sim, 0 = não, 0.5 = mais ou menos / indefinido. */
(function () {
  const QUESTIONS = [
    { id: 'mulher',      text: 'O seu professor é uma mulher?' },
    { id: 'oculos',      text: 'O seu professor usa óculos?' },
    { id: 'barba',       text: 'O seu professor tem barba?' },
    { id: 'jovem',       text: 'O seu professor tem menos de 35 anos?' },
    { id: 'veterano',    text: 'O seu professor dá aula há mais de 10 anos?' },
    { id: 'programacao', text: 'O seu professor ensina programação (lógica, código)?' },
    { id: 'dados',       text: 'O seu professor ensina banco de dados?' },
    { id: 'redes',       text: 'O seu professor ensina redes ou infraestrutura?' },
    { id: 'design',      text: 'O seu professor trabalha com front-end, design ou UX?' },
    { id: 'mobile',      text: 'O seu professor ensina desenvolvimento mobile ou games?' },
    { id: 'gestao',      text: 'O seu professor ensina gestão ou engenharia de software?' },
    { id: 'descontraido',text: 'O seu professor é bem descontraído e faz piadas na aula?' },
    { id: 'exigente',    text: 'O seu professor é conhecido por ser exigente nas provas?' },
    { id: 'cafe',        text: 'O seu professor vive com um café na mão?' },
    { id: 'gamer',       text: 'O seu professor é gamer nas horas vagas?' },
    { id: 'pontual',     text: 'O seu professor é pontual e bem sério?' },
    { id: 'careca',      text: 'O seu professor é careca?' },
    { id: 'tatuagem',    text: 'O seu professor tem alguma tatuagem?' },
    { id: 'grupo',       text: 'O seu professor adora passar trabalho em grupo?' },
    { id: 'memes',       text: 'O seu professor usa memes nos slides?' },
  ];

  // a = atributos. faltando => tratado como 0.
  const PROFESSORS = [
    {
      id: 'ricardo', name: 'Prof. Ricardo Lima', initials: 'RL',
      area: 'Banco de Dados', tagline: 'O senhor do SQL — e do cafezinho.',
      a: { mulher:0, oculos:1, barba:1, jovem:0, veterano:1, dados:1, programacao:0.5,
           exigente:1, cafe:1, pontual:1, grupo:0.5 }
    },
    {
      id: 'aline', name: 'Profa. Aline Souza', initials: 'AS',
      area: 'Front-end & UX', tagline: 'Pixel perfeito e meme no slide.',
      a: { mulher:1, oculos:1, barba:0, jovem:1, veterano:0, design:1, programacao:1,
           descontraido:1, memes:1, cafe:1, tatuagem:0.5 }
    },
    {
      id: 'bruno', name: 'Prof. Bruno Carvalho', initials: 'BC',
      area: 'Redes & Infraestrutura', tagline: 'Se a rede caiu, a culpa não é dele.',
      a: { mulher:0, oculos:0, barba:0.5, jovem:0, veterano:1, redes:1, careca:1,
           pontual:1, exigente:0.5 }
    },
    {
      id: 'camila', name: 'Profa. Camila Rocha', initials: 'CR',
      area: 'Programação Python', tagline: 'Paciência infinita, indentação obrigatória.',
      a: { mulher:1, oculos:1, barba:0, jovem:0, veterano:1, programacao:1, dados:0.5,
           grupo:1, descontraido:0.5, memes:0.5 }
    },
    {
      id: 'diego', name: 'Prof. Diego Fernandes', initials: 'DF',
      area: 'Mobile & Games', tagline: 'Entrega o app e o boss final.',
      a: { mulher:0, oculos:0, barba:1, jovem:1, veterano:0, mobile:1, programacao:1,
           gamer:1, tatuagem:1, descontraido:1, memes:1 }
    },
    {
      id: 'helena', name: 'Profa. Helena Martins', initials: 'HM',
      area: 'Engenharia de Software', tagline: 'Cronograma, escopo e zero atraso.',
      a: { mulher:1, oculos:1, barba:0, jovem:0, veterano:1, gestao:1, grupo:1,
           exigente:1, pontual:1 }
    },
  ];

  window.FabiData = { QUESTIONS, PROFESSORS };
})();
