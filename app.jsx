/* global React, ReactDOM */
const { useState, useEffect, useRef, useCallback } = React;
const E = window.FabiEngine;
const { QUESTIONS, PROFESSORS } = window.FabiData;

const FABI_IMGS = {
  confident: 'assets/fabi-confident.png',
  smile:     'assets/fabi-smile.png',
  worried:   'assets/fabi-worried.png',
  shy:       'assets/fabi-shy.png',
};

const ANSWERS = [
  { label: 'Sim',               value: 1 },
  { label: 'Não',               value: 0 },
  { label: 'Não sei',           value: 0.5 },
  { label: 'Provavelmente sim', value: 0.75 },
  { label: 'Provavelmente não', value: 0.25 },
];

const LAST_GAMES = [
  'O professor de banco de dados!', 'Profa. Aline', 'O coordenador',
  'Aquele das redes', 'Prof. Python', 'A professora de gestão',
  'O gamer da turma', 'Seu orientador de TCC', 'Prof. de lógica', 'A sua coordenadora!',
];

/* ----------------------------- Background ----------------------------- */
function Background() {
  const sparks = React.useMemo(() =>
    Array.from({ length: 22 }, () => ({
      left: Math.random() * 100, top: Math.random() * 100,
      size: 6 + Math.random() * 12, delay: Math.random() * 5, dur: 4 + Math.random() * 4,
    })), []);
  return (
    <React.Fragment>
      <svg className="bg-waves" viewBox="0 0 1440 900" preserveAspectRatio="xMidYMid slice" aria-hidden="true">
        <path d="M-40,160 C300,60 520,260 760,180 C1020,90 1240,240 1500,150 L1500,-40 L-40,-40 Z"
              fill="#7A1B2E" opacity="0.35" />
        <path d="M-40,300 C260,210 560,400 820,300 C1080,200 1300,360 1500,280 L1500,0 L-40,0 Z"
              fill="#6E1423" opacity="0.4" />
        <path d="M-40,760 C260,860 520,640 820,740 C1100,830 1320,660 1500,740 L1500,940 L-40,940 Z"
              fill="#4A1120" opacity="0.55" />
        <path d="M-40,840 C320,760 600,900 900,820 C1160,750 1320,860 1500,800 L1500,940 L-40,940 Z"
              fill="#3A0E18" opacity="0.6" />
      </svg>
      <div className="bg-glow" />
      <div className="sparkles">
        {sparks.map((s, i) => (
          <span key={i} className="sparkle"
            style={{ left: s.left + '%', top: s.top + '%', animationDelay: s.delay + 's', animationDuration: s.dur + 's' }}>
            <svg width={s.size} height={s.size} viewBox="0 0 24 24">
              <path d="M12 0 L14 10 L24 12 L14 14 L12 24 L10 14 L0 12 L10 10 Z" fill="currentColor" />
            </svg>
          </span>
        ))}
      </div>
    </React.Fragment>
  );
}

/* ----------------------------- Wordmark ----------------------------- */
function Wordmark({ size = 'clamp(34px,6vw,86px)' }) {
  return (
    <div className="wordmark" style={{ fontSize: size }}>
      <span className="layer stroke" aria-hidden="true">FabiNator</span>
      <span className="layer fill">FabiNator</span>
      <span className="layer shine" aria-hidden="true">FabiNator</span>
    </div>
  );
}

/* ----------------------------- Character ----------------------------- */
function Fabi({ mood, className = '' }) {
  return (
    <div className={'fabi-wrap ' + className} style={{ aspectRatio: '1056 / 1489' }}>
      {Object.entries(FABI_IMGS).map(([k, src]) => (
        <img key={k} className={'fabi-img' + (k === mood ? ' active' : '')} src={src} alt={k === mood ? 'FabiNator' : ''} />
      ))}
    </div>
  );
}

/* ----------------------------- Bubble ----------------------------- */
function Bubble({ side, children }) {
  return <div className={'bubble ' + side}>{children}</div>;
}

/* ----------------------------- Lang pill ----------------------------- */
function LangPill() {
  const [open, setOpen] = useState(false);
  return (
    <div style={{ position: 'relative' }}>
      <button className="lang-pill" onClick={() => setOpen(o => !o)}>
        <span className="flag">🇧🇷</span> Português <span style={{ fontSize: 11, marginLeft: 2 }}>▾</span>
      </button>
      {open && (
        <div className="card fade-in" style={{ position: 'absolute', top: 48, left: 0, zIndex: 30, minWidth: 160, padding: 6 }}>
          {['🇧🇷 Português', '🇺🇸 English', '🇪🇸 Español'].map(l => (
            <div key={l} className="answer" style={{ padding: '10px 14px', fontSize: 15 }} onClick={() => setOpen(false)}>{l}</div>
          ))}
        </div>
      )}
    </div>
  );
}

/* ----------------------------- Confetti ----------------------------- */
function Confetti() {
  const pieces = React.useMemo(() => {
    const cols = ['#F6D879', '#E0A92E', '#C42943', '#A41E34', '#FCF6EA', '#6E1423'];
    return Array.from({ length: 70 }, () => ({
      left: Math.random() * 100, delay: Math.random() * 1.2, dur: 2.4 + Math.random() * 2,
      col: cols[Math.floor(Math.random() * cols.length)], rot: Math.random() * 360,
    }));
  }, []);
  return (
    <div className="confetti">
      {pieces.map((p, i) => (
        <i key={i} style={{ left: p.left + '%', background: p.col, animationDelay: p.delay + 's',
          animationDuration: p.dur + 's', transform: `rotate(${p.rot}deg)` }} />
      ))}
    </div>
  );
}

/* ----------------------------- Professor card pieces ----------------------------- */
function ProfPhoto({ prof, h = 200 }) {
  return (
    <div className="prof-photo" style={{ width: h * 0.82, height: h }}>
      <div className="prof-monogram">{prof.initials}</div>
      <span className="prof-tag">foto do professor</span>
    </div>
  );
}

/* ----------------------------- Side card ----------------------------- */
function LastGames({ onClose }) {
  return (
    <div style={{ position: 'relative' }}>
      <div className="side-card">
        <button className="close" onClick={onClose}>×</button>
        <h3>Os últimos 10 jogos</h3>
        <div className="rule" />
        <ul>{LAST_GAMES.map((g, i) => <li key={i}>{g}</li>)}</ul>
      </div>
    </div>
  );
}

/* =============================== HOME =============================== */
function Home({ onPlay }) {
  const [showGames, setShowGames] = useState(false);
  return (
    <div className="screen-home fade-in">
      <div className="home-side">
        {showGames
          ? <LastGames onClose={() => setShowGames(false)} />
          : <button className="games-pill" onClick={() => setShowGames(true)}>📜 Últimos jogos</button>}
      </div>
      <div className="home-center">
        <Wordmark />
        <div className="home-row">
          <Bubble side="right">Olá, eu sou a <strong>FabiNator</strong> ✨</Bubble>
          <Fabi mood="confident" className="fabi-home" />
          <Bubble side="left">Pense em um <strong>professor</strong> que já te deu aula.<br />Eu vou tentar adivinhar quem é!</Bubble>
        </div>
        <button className="btn btn-play" onClick={onPlay}>JOGAR</button>
        <div className="stats">
          <div>137 alunos estão jogando agora.</div>
          <div>8 942 partidas jogadas hoje na Donaduzzi.</div>
        </div>
      </div>
    </div>
  );
}

/* =============================== GAME =============================== */
function Game({ state, question, mood, onAnswer, onUndo, canUndo }) {
  const num = state.step + 1;
  return (
    <div className="screen-game fade-in">
      <div className="game-fabi">
        <Fabi mood={mood} className="fabi-game" />
      </div>
      <div className="game-main">
        <div className="qrow">
          <div className="qnum">{num}</div>
          <div className="qtext">{question.text}</div>
        </div>
        <div className="answers" style={{ marginTop: 22, maxWidth: 560 }}>
          {ANSWERS.map(a => (
            <div key={a.label} className="answer" onClick={() => onAnswer(a.value)}>
              {a.label}<span className="chev">»</span>
            </div>
          ))}
        </div>
        <div className="game-foot">
          <div className="progress">
            {Array.from({ length: Math.min(state.step, 12) }).map((_, i) => <i key={i} className="on" />)}
            {state.step < 12 && <i />}
          </div>
          <button className="corrigir" onClick={onUndo} disabled={!canUndo} style={{ opacity: canUndo ? 1 : .4 }}>
            <span className="arrow">←</span> CORRIGIR
          </button>
        </div>
      </div>
    </div>
  );
}

/* =============================== GUESS =============================== */
function Guess({ prof, mood, onYes, onNo }) {
  return (
    <div className="screen-guess fade-in">
      <div className="game-fabi">
        <Fabi mood={mood} className="fabi-game" />
      </div>
      <div className="guess-main">
        <div className="card" style={{ maxWidth: 560 }}>
          <div className="panel-head">Eu acho que…</div>
          <div style={{ padding: '22px 24px 26px', textAlign: 'center' }}>
            <div style={{ fontFamily: "'Lilita One'", fontSize: 'clamp(26px,3vw,38px)', color: 'var(--wine-800)' }}>{prof.name}</div>
            <div style={{ fontFamily: "'Spectral'", fontStyle: 'italic', color: 'var(--ink-soft)', marginTop: 2 }}>{prof.area} · {prof.tagline}</div>
            <div style={{ display: 'flex', justifyContent: 'center', margin: '20px 0 22px' }}>
              <ProfPhoto prof={prof} h={210} />
            </div>
            <div style={{ display: 'flex', gap: 16, justifyContent: 'center' }}>
              <button className="btn btn-yn gold" onClick={onYes}>Sim, é ele(a)!</button>
              <button className="btn btn-yn" onClick={onNo}>Não</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

/* =============================== WIN =============================== */
function Win({ prof, onReplay }) {
  return (
    <div className="screen-result fade-in">
      <Confetti />
      <div className="game-fabi">
        <Fabi mood="smile" className="fabi-game" />
      </div>
      <div className="result-main">
        <div className="card" style={{ maxWidth: 520 }}>
          <div className="panel-head">Acertei! 🎉</div>
          <div style={{ padding: '24px', textAlign: 'center' }}>
            <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 16 }}>
              <ProfPhoto prof={prof} h={200} />
            </div>
            <div style={{ fontFamily: "'Lilita One'", fontSize: 'clamp(24px,3vw,34px)', color: 'var(--wine-800)' }}>{prof.name}</div>
            <div style={{ fontFamily: "'Spectral'", fontStyle: 'italic', color: 'var(--ink-soft)', margin: '4px 0 20px' }}>
              Mais uma vez a magia da Donaduzzi venceu!
            </div>
            <button className="btn btn-play" onClick={onReplay}>JOGAR DE NOVO</button>
          </div>
        </div>
      </div>
    </div>
  );
}

/* =============================== LOSE =============================== */
function Lose({ onReplay }) {
  const [name, setName] = useState('');
  const [sent, setSent] = useState(false);
  return (
    <div className="screen-result fade-in">
      <div className="game-fabi">
        <Fabi mood="shy" className="fabi-game" />
      </div>
      <div className="result-main">
        <div className="card" style={{ maxWidth: 520 }}>
          <div className="panel-head">Você me venceu… 😳</div>
          <div style={{ padding: '24px', textAlign: 'center' }}>
            <div style={{ fontFamily: "'Spectral'", fontSize: 18, color: 'var(--ink)', lineHeight: 1.5, marginBottom: 18 }}>
              Não consegui adivinhar dessa vez!<br />Me conta: <strong>quem era o seu professor?</strong>
            </div>
            {!sent ? (
              <div style={{ display: 'flex', gap: 10, justifyContent: 'center', flexWrap: 'wrap', marginBottom: 20 }}>
                <input value={name} onChange={e => setName(e.target.value)} placeholder="Nome do professor"
                  style={{ fontFamily: "'Spectral'", fontSize: 16, padding: '11px 16px', borderRadius: 10,
                    border: '1.5px solid rgba(169,116,26,.5)', background: '#fff', color: 'var(--ink)', minWidth: 200 }} />
                <button className="btn btn-yn gold" onClick={() => name.trim() && setSent(true)}>Enviar</button>
              </div>
            ) : (
              <div style={{ fontFamily: "'Spectral'", fontStyle: 'italic', color: 'var(--crimson)', marginBottom: 20 }}>
                Obrigada! Vou aprender com <strong>{name}</strong> para a próxima. 💪
              </div>
            )}
            <button className="btn btn-play" onClick={onReplay}>JOGAR DE NOVO</button>
          </div>
        </div>
      </div>
    </div>
  );
}

/* =============================== APP =============================== */
function App() {
  const [screen, setScreen] = useState('home');
  const [state, setState] = useState(null);
  const [question, setQuestion] = useState(null);
  const [mood, setMood] = useState('confident');
  const [guess, setGuess] = useState(null);
  const [history, setHistory] = useState([]);     // [{state, question}]
  const [wrong, setWrong] = useState(0);
  const minStepRef = useRef(0);

  const renorm = (w) => {
    const t = Object.values(w).reduce((a, b) => a + b, 0) || 1;
    const o = {}; for (const k in w) o[k] = w[k] / t; return o;
  };

  const startGame = useCallback(() => {
    const s = E.init();
    setState(s); setQuestion(E.pickQuestion(s)); setMood('confident');
    setHistory([]); setWrong(0); minStepRef.current = 0; setGuess(null);
    setScreen('game');
  }, []);

  // avança: ou faz pergunta, ou parte para o palpite
  const advance = useCallback((s, lastValue) => {
    const noMoreQ = QUESTIONS.length - s.asked.length <= 0;
    const readyToGuess = (E.shouldGuess(s) && s.step >= minStepRef.current);
    if (noMoreQ || readyToGuess) {
      const top = E.confidence(s).top;
      if (!top || top.w <= 0.0001) { setScreen('lose'); setMood('shy'); return; }
      setGuess(top.prof); setMood('confident'); setScreen('guess');
    } else {
      setQuestion(E.pickQuestion(s));
      if (lastValue !== undefined) setMood(E.moodFor(s, lastValue));
    }
  }, []);

  const onAnswer = useCallback((value) => {
    setHistory(h => [...h, { state, question }]);
    const ns = E.answer(state, question.id, value);
    setState(ns);
    advance(ns, value);
  }, [state, question, advance]);

  const onUndo = useCallback(() => {
    setHistory(h => {
      if (!h.length) return h;
      const last = h[h.length - 1];
      setState(last.state); setQuestion(last.question); setScreen('game'); setMood('confident');
      return h.slice(0, -1);
    });
  }, []);

  const onGuessYes = useCallback(() => { setScreen('win'); setMood('smile'); }, []);

  const onGuessNo = useCallback(() => {
    const w = { ...state.weights }; w[guess.id] = 0;
    const ns = { ...state, weights: renorm(w) };
    setState(ns);
    const remaining = E.ranked(ns).filter(r => r.w > 0.0005);
    const newWrong = wrong + 1;
    setWrong(newWrong);
    if (newWrong >= 2 || remaining.length === 0) { setScreen('lose'); setMood('shy'); return; }
    minStepRef.current = ns.step + 2;
    setMood('worried');
    setScreen('game');
    advance(ns);
  }, [state, guess, wrong, advance]);

  return (
    <div className="stage">
      <Background />
      <div className="topbar">
        <LangPill />
        {screen !== 'home' && <div onClick={() => setScreen('home')} style={{ cursor: 'pointer' }}><Wordmark size="clamp(26px,3.2vw,44px)" /></div>}
        <div className="topbar-logo">
          <img src="assets/logo-donaduzzi.png" alt="Faculdade Donaduzzi" />
        </div>
      </div>

      <div className="content">
        {screen === 'home' && <Home onPlay={startGame} />}
        {screen === 'game' && state && question &&
          <Game state={state} question={question} mood={mood} onAnswer={onAnswer} onUndo={onUndo} canUndo={history.length > 0} />}
        {screen === 'guess' && guess && <Guess prof={guess} mood={mood} onYes={onGuessYes} onNo={onGuessNo} />}
        {screen === 'win' && guess && <Win prof={guess} onReplay={startGame} />}
        {screen === 'lose' && <Lose onReplay={startGame} />}
      </div>

      <div className="footer">
        <div className="topbar-logo"><img src="assets/logo-donaduzzi.png" alt="" style={{ height: 26 }} /></div>
        <a href="#">Sobre o projeto</a><a href="#">Como jogar</a><a href="#">Professores</a>
        <a href="#">Curso de TI</a><a href="#">Contato</a>
        <span style={{ opacity: .6 }}>Projeto acadêmico · Faculdade Donaduzzi</span>
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
