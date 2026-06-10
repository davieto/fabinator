# FabiNator

> Jogo de adivinhação de professores inspirado no Akinator — Faculdade Donaduzzi

**FabiNator** é uma aplicação Flutter que usa inteligência artificial para adivinhar qual professor da Faculdade Donaduzzi o usuário está pensando. O sistema faz perguntas inteligentes sobre as características do professor e, conforme as respostas, direciona o raciocínio até chegar à resposta certa — ou admitir derrota.

---

## Sumário

1. [Sobre o projeto](#sobre-o-projeto)
2. [Tecnologias](#tecnologias)
3. [Estrutura do projeto](#estrutura-do-projeto)
4. [Como executar](#como-executar)
5. [Lógica do motor de jogo](#lógica-do-motor-de-jogo)
   - [Fluxo de perguntas](#fluxo-de-perguntas)
   - [Sistema de pontuação](#sistema-de-pontuação)
   - [Confirmação e palpite](#confirmação-e-palpite)
   - [Modo dirigido ao líder](#modo-dirigido-ao-líder)
6. [Professores cadastrados](#professores-cadastrados)
7. [Banco de perguntas](#banco-de-perguntas)
8. [Desenvolvedores](#desenvolvedores)

---

## Sobre o projeto

O FabiNator foi desenvolvido como projeto acadêmico do curso de **Análise e Desenvolvimento de Sistemas** da **Faculdade Donaduzzi**. A mascote do jogo é a **Fabi**, uma personagem animada que guia o usuário pelas perguntas com expressões diferentes conforme o andamento da partida.

O jogo cadastra **16 professores** e utiliza **52 perguntas** distribuídas em quatro categorias de especificidade crescente. O motor de IA seleciona as perguntas de forma estratégica para isolar o professor pensado no menor número possível de rodadas.

---

## Tecnologias

| Tecnologia | Versão | Uso |
|---|---|---|
| Flutter | ≥ 3.x | Framework principal |
| Dart | ^3.11.4 | Linguagem |
| google_fonts | ^6.2.1 | Fontes (LilitaOne, Spectral, Poppins) |
| Material 3 | — | Design system |

---

## Estrutura do projeto

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # Máquina de estados principal (_Screen enum)
├── exports.dart                 # Barrel de exports
│
├── data/
│   ├── professors_data.dart     # Respostas dos 16 professores (52 booleans cada)
│   └── questions_data.dart      # Banco de 52 perguntas com categoria e minPhase
│
├── models/
│   ├── professor.dart           # Professor (id, nome, score, isActive)
│   ├── game_state.dart          # Estado imutável da partida
│   ├── question.dart            # Pergunta (id, texto, categoria, minPhase)
│   ├── answer_option.dart       # Enum de respostas (Sim..Não)
│   └── fabi_mood.dart           # Enum de humor da mascote
│
├── services/
│   └── game_engine.dart         # Motor de IA — toda a lógica de decisão
│
├── screens/
│   ├── home_screen.dart         # Tela inicial
│   ├── game_screen.dart         # Tela de perguntas
│   ├── guess_screen.dart        # Tela de palpite
│   ├── win_screen.dart          # Tela de vitória (com confetes)
│   ├── lose_screen.dart         # Tela de derrota
│   ├── professores_screen.dart  # Lista de professores
│   ├── como_jogar_screen.dart   # Instruções
│   └── sobre_screen.dart        # Sobre o projeto
│
├── widgets/
│   ├── background.dart          # Gradiente radial de fundo
│   ├── fabi_character.dart      # Mascote animada
│   ├── professor_photo.dart     # Avatar circular do professor
│   ├── speech_bubble.dart       # Balão de fala com ponteiro
│   ├── confetti_overlay.dart    # Animação de confetes (vitória)
│   └── wordmark.dart            # Logo tipográfico "FabiNator"
│
└── theme/
    └── colors.dart              # Paleta de cores (vinho, dourado, creme)

assets/
├── fabi-confident.png           # Mascote — confiante
├── fabi-smile.png               # Mascote — sorrindo
├── fabi-worried.png             # Mascote — preocupada
├── fabi-shy.png                 # Mascote — tímida/perdida
├── logo-donaduzzi.png           # Logo da Faculdade Donaduzzi
└── professores/                 # Fotos dos 16 professores (JPEG)
    └── {id}.jpg
```

---

## Como executar

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e no PATH
- Dart ^3.11.4

### Passos

```bash
# 1. Clone o repositório
git clone <url-do-repositório>
cd fabinator_flutter

# 2. Instale as dependências
flutter pub get

# 3. Execute no navegador (recomendado)
flutter run -d chrome

# 4. Ou gere o build web
flutter build web
```

> O projeto foi desenvolvido e testado primariamente como aplicação **web**. Funciona também em Android e iOS, mas o layout foi otimizado para telas de celular e desktop.

---

## Lógica do motor de jogo

Todo o raciocínio do jogo está em [`lib/services/game_engine.dart`](lib/services/game_engine.dart). O motor é **sem estado** — recebe um `GameState` imutável e devolve um novo estado ou a próxima pergunta, sem efeitos colaterais.

### Fluxo de perguntas

O jogo segue um fluxo estruturado em etapas, controlado por `questionCount`:

```
Pergunta 1  (count=0)  → R1 obrigatória: "O seu professor(a) é professor(a)?"
Pergunta 2  (count=1)  → Geral aleatória (sem filtro)
Perguntas 3–6 (count=2..5) → Intermediárias aleatórias (base para identificar o líder)
─────────────────────────────────────────────────────────────
Pergunta 7+ (count≥6)  → MODO DIRIGIDO AO LÍDER
  count 6–8  → Intermediárias onde o líder responde "sim"
  count 9+   → Quase-específicas → Definitivas onde o líder responde "sim"
─────────────────────────────────────────────────────────────
Penúltima   → Pergunta de assinatura (só o líder responde "sim" entre os ativos)
Fim         → Palpite automático
```

Se o usuário responder **"Não"** na pergunta R1, o jogo vai imediatamente para a tela de derrota com a mensagem especial, pois o sistema só conhece professores.

### Sistema de pontuação

Cada resposta atualiza o `score` de todos os 16 professores. Um professor com `score ≤ -2.0` é considerado **eliminado** (`isActive = false`) e sai da disputa.

#### Multiplicadores por fase

| Fase | Categoria desbloqueada | Multiplicador |
|------|------------------------|---------------|
| 1 | Geral | 1.0× |
| 2 | Intermediária | 1.5× |
| 3 | Quase-específica | 3.5× |
| 4 | Definitiva | 6.0× |

> As fases avançam automaticamente: fase 2 ao 2ª pergunta, fase 3 ao 6ª, fase 4 ao 9ª ou quando o gap do líder supera 14 pontos na 7ª pergunta.

#### Delta por resposta

| Resposta do usuário | Professor responde "sim" | Professor responde "não" |
|---|---|---|
| **Sim** | `+4.0 × m` | `-4.0 × m` |
| **Provavelmente sim** | `+2.5 × m` | `-1.0 × m` |
| **Não sei** | `0` | `0` |
| **Provavelmente não** | `-0.5 × m` | `+1.0 × m` |
| **Não** | `-4.0 × m` | `+4.0 × m` |

> `m` = multiplicador da fase atual. Quando a resposta é "Não", os professores que **também** responderiam "não" àquela pergunta ganham pontos e sobem no ranking — comportamento simétrico e correto.
>
> A fase efetiva usada para calcular o delta é `max(fase_atual, minPhase_da_pergunta)`, garantindo que perguntas definitivas chamadas fora de ordem (ex.: pergunta de assinatura) sempre usem o multiplicador correto.

#### Impureza de Gini (seleção de fallback)

Quando não há perguntas favoráveis ao líder disponíveis, o motor cai no algoritmo de **Gini impurity** para selecionar a pergunta que mais divide o grupo de professores ativos:

```
Gini(q) = 1 − (p_sim² + p_nao²)
```

onde `p_sim` é a proporção de professores ativos que responderiam "sim" à pergunta `q`. O Gini máximo (0.5) indica que a pergunta divide o grupo exatamente ao meio — máxima informação.

### Confirmação e palpite

O motor decide palpitar (`shouldGuess`) quando:

| Condição | Descrição |
|---|---|
| `signatureConfirmed = true` | Pergunta exclusiva do líder confirmada com "Sim" |
| `gap ≥ 16.0 && count ≥ 8` | Líder bem isolado — confiança alta |
| `gap ≥ 10.0 && count ≥ 10` | Líder à frente — confiança média |
| `count ≥ 15` | Esgotamento de perguntas úteis |
| Perguntas disponíveis = 0 | Sem mais opções |

`gap` = diferença de score entre o 1º e o 2º colocados entre os professores ativos.

Antes de exibir o palpite, o motor sempre tenta fazer a **pergunta de assinatura**: a única pergunta que **somente o líder** responde "sim" entre todos os professores ainda ativos. Se confirmada com "sim", `signatureConfirmed` é ativado e o jogo vai direto ao palpite sem mais perguntas.

Uma resposta "sim" a uma pergunta **definitiva** com `gap ≥ 16.0` também ativa `signatureConfirmed` automaticamente.

### Modo dirigido ao líder

A partir da 7ª pergunta, o motor para de escolher por Gini e passa a **direcionar perguntas ao professor em 1º lugar**, buscando confirmação positiva:

```
1. Filtra perguntas disponíveis onde líder.answers[id] == true
2. Ordena por categoria: intermediária → quase_especifica → definitiva
3. Escolhe aleatoriamente dentro da categoria mais prioritária disponível
4. Se o líder não responde "sim" a nenhuma pergunta restante → cai no Gini
```

Se o líder mudar durante esse processo (o usuário respondeu "não" a uma pergunta que o líder responderia "sim"), o motor **automaticamente redireciona** para o novo 1º colocado.

Após uma resposta "Não" na tela de palpite, o professor errado é eliminado (`score = -100`), `signatureConfirmed` é resetado, e o motor recomeça o processo de confirmação para o novo líder — sem reiniciar as perguntas já feitas.

---

## Professores cadastrados

| # | Nome | ID |
|---|---|---|
| 1 | Vander | `vander` |
| 2 | Fabiane Sorbar | `fabiane_sorbar` |
| 3 | Jefferson | `jefferson` |
| 4 | Jhoni Elder | `jhoni_elder` |
| 5 | Willian Mendonça | `willian_mendonca` |
| 6 | Guilherme Alves | `guilherme_alves` |
| 7 | Marcos Guido | `marcos_guido` |
| 8 | Leticia Siguinolfi | `leticia_siguinolfi` |
| 9 | Jefferson Vorpagel | `jefferson_vorpagel` |
| 10 | André Luis Dorr | `andre_luis_dorr` |
| 11 | Renato Estevam | `renato_estevam` |
| 12 | Marcel | `marcel` |
| 13 | Hiago | `hiago` |
| 14 | Allan Escher | `allan_escher` |
| 15 | Fabiano Dicheti | `fabiano_dicheti` |
| 16 | Daniela Wolfart | `daniela_wolfart` |

Cada professor possui **52 respostas booleanas** mapeadas em `professors_data.dart`, cobrindo características físicas, acadêmicas e comportamentais.

---

## Banco de perguntas

As 52 perguntas estão divididas em quatro categorias com especificidade crescente:

| Categoria | Qtd. | minPhase | Exemplos |
|---|---|---|---|
| `geral` | 6 | 1 | "Esse professor ainda está dando aula?" |
| `intermediaria` | 13 | 2 | "Esse professor usa óculos?", "Tem mestrado?" |
| `quase_especifica` | 11 | 3 | "Esse professor é mulher?", "Tem doutorado?" |
| `definitiva` | 22 | 4 | "Dá aula de banco de dados?", "É o menor professor?" |

Perguntas com `funnyQuestion: true` (ex.: "Ama aquário?", "Tem barba grande?") só aparecem a partir da fase 3, para não desconcertar o usuário logo no início.

---

## Desenvolvedores

| Nome | Papel |
|---|---|
| **Davi Chagas** | Desenvolvimento Flutter, motor de IA, arquitetura |
| **Gabriela Pecatoski** | Desenvolvimento Flutter, UI/UX, dados dos professores |

Projeto acadêmico — Curso de Análise e Desenvolvimento de Sistemas  
**Faculdade Donaduzzi** · Toledo, PR
