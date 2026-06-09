import '../data/professors.dart';
import '../data/questions.dart';
import '../models/game_state.dart';
import '../models/professor.dart';
import '../models/question.dart';

enum FabiMood { confident, smile, worried, shy }

class RankedProfessor {
  final Professor prof;
  final double w;
  RankedProfessor(this.prof, this.w);
}

class Confidence {
  final RankedProfessor? top;
  final RankedProfessor? second;
  final double conf;
  final double ratio;
  Confidence({this.top, this.second, required this.conf, required this.ratio});
}

class FabiEngine {
  static GameState init() {
    final w = <String, double>{};
    for (final p in professors) {
      w[p.id] = 1.0 / professors.length;
    }
    return GameState(weights: w, asked: [], step: 0);
  }

  static double _total(Map<String, double> weights) =>
      weights.values.fold(0.0, (a, b) => a + b);

  static Question? pickQuestion(GameState state) {
    final t = _total(state.weights);
    Question? best;
    double bestDist = double.infinity;

    for (final q in questions) {
      if (state.asked.contains(q.id)) continue;
      double pYes = 0;
      for (final p in professors) {
        pYes += state.weights[p.id]! * p.attr(q.id);
      }
      pYes /= (t == 0 ? 1 : t);
      final dist = (pYes - 0.5).abs();
      if (dist < bestDist) {
        bestDist = dist;
        best = q;
      }
    }
    return best;
  }

  static GameState answer(GameState state, String qid, double value) {
    final weights = Map<String, double>.from(state.weights);
    if (value != 0.5) {
      for (final p in professors) {
        final v = p.attr(qid);
        final likelihood = 1 - (value - v).abs();
        weights[p.id] = state.weights[p.id]! * (0.12 + 0.88 * likelihood);
      }
      final t = _total(weights);
      for (final id in weights.keys) {
        weights[id] = weights[id]! / (t == 0 ? 1 : t);
      }
    }
    return GameState(
      weights: weights,
      asked: [...state.asked, qid],
      step: state.step + 1,
    );
  }

  static List<RankedProfessor> ranked(GameState state) {
    final list = professors
        .map((p) => RankedProfessor(p, state.weights[p.id] ?? 0))
        .toList();
    list.sort((a, b) => b.w.compareTo(a.w));
    return list;
  }

  static Confidence confidence(GameState state) {
    final r = ranked(state);
    final t = _total(state.weights);
    final tSafe = t == 0 ? 1.0 : t;
    final top = r.isNotEmpty ? r[0] : null;
    final second = r.length > 1 ? r[1] : null;
    final conf = top != null ? top.w / tSafe : 0.0;
    final ratio = (top != null && second != null && second.w > 0)
        ? top.w / second.w
        : 99.0;
    return Confidence(top: top, second: second, conf: conf, ratio: ratio);
  }

  static bool shouldGuess(GameState state) {
    final c = confidence(state);
    if (state.step >= 4 && c.conf >= 0.85) return true;
    if (state.step >= 6 && c.conf >= 0.55 && c.ratio >= 1.7) return true;
    if (state.step >= questions.length) return true;
    if (state.step >= 15) return true;
    return false;
  }

  static FabiMood moodFor(GameState state, double lastValue) {
    if (lastValue == 0.5) return FabiMood.shy;
    final c = confidence(state);
    if (c.conf >= 0.5) return FabiMood.smile;
    if (c.conf >= 0.32) return FabiMood.confident;
    return FabiMood.worried;
  }
}
