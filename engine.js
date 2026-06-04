/* ===================== FabiNator — motor de adivinhação =====================
   Estado imutável: { weights:{id:peso}, asked:[qid], step:n }.
   Respostas (valor): Sim=1, Provavelmente sim=.75, Não sei=.5, Provavelmente não=.25, Não=0. */
(function () {
  const { QUESTIONS, PROFESSORS } = window.FabiData;

  function attr(prof, qid) {
    const v = prof.a[qid];
    return v === undefined ? 0 : v;
  }

  function init() {
    const weights = {};
    PROFESSORS.forEach(p => { weights[p.id] = 1 / PROFESSORS.length; });
    return { weights, asked: [], step: 0 };
  }

  function total(weights) {
    return Object.values(weights).reduce((a, b) => a + b, 0);
  }

  // escolhe a pergunta que melhor divide a distribuição atual (pYes ~ 0.5)
  function pickQuestion(state) {
    const t = total(state.weights);
    let best = null, bestDist = Infinity;
    for (const q of QUESTIONS) {
      if (state.asked.includes(q.id)) continue;
      let pYes = 0;
      for (const p of PROFESSORS) pYes += state.weights[p.id] * attr(p, q.id);
      pYes /= t || 1;
      const dist = Math.abs(pYes - 0.5);
      if (dist < bestDist) { bestDist = dist; best = q; }
    }
    return best;
  }

  // aplica resposta e devolve novo estado normalizado
  function answer(state, qid, value) {
    const weights = { ...state.weights };
    if (value !== 0.5) { // "Não sei" não altera pesos, só consome a pergunta
      for (const p of PROFESSORS) {
        const v = attr(p, qid);
        const likelihood = 1 - Math.abs(value - v); // 1 = combina, 0 = oposto
        weights[p.id] = state.weights[p.id] * (0.12 + 0.88 * likelihood);
      }
      const t = total(weights);
      for (const id in weights) weights[id] = weights[id] / (t || 1);
    }
    return { weights, asked: [...state.asked, qid], step: state.step + 1 };
  }

  function ranked(state) {
    return PROFESSORS
      .map(p => ({ prof: p, w: state.weights[p.id] }))
      .sort((a, b) => b.w - a.w);
  }

  function confidence(state) {
    const r = ranked(state);
    const t = total(state.weights) || 1;
    return { top: r[0], second: r[1], conf: r[0].w / t, ratio: r[1] ? r[0].w / (r[1].w || 1e-6) : 99 };
  }

  // decide se já é hora de chutar
  function shouldGuess(state) {
    const { conf, ratio } = confidence(state);
    if (state.step >= 4 && conf >= 0.85) return true;
    if (state.step >= 6 && conf >= 0.55 && ratio >= 1.7) return true;
    if (state.step >= QUESTIONS.length) return true;
    if (state.step >= 15) return true;
    return false;
  }

  // expressão da Fabi segundo o estado (após responder)
  function moodFor(state, lastValue) {
    if (lastValue === 0.5) return 'shy';
    const { conf } = confidence(state);
    if (conf >= 0.5) return 'smile';
    if (conf >= 0.32) return 'confident';
    return 'worried';
  }

  window.FabiEngine = { init, pickQuestion, answer, ranked, confidence, shouldGuess, moodFor };
})();
