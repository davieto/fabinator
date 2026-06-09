import 'dart:math';
import 'package:flutter/material.dart';

class _Piece {
  final double left;
  final double delay;
  final double dur;
  final Color color;
  final double rotation;
  _Piece(Random r)
      : left = r.nextDouble(),
        delay = r.nextDouble() * 1.2,
        dur = 2.4 + r.nextDouble() * 2,
        color = _colors[r.nextInt(_colors.length)],
        rotation = r.nextDouble() * 2 * pi;

  static const _colors = [
    Color(0xFFF6D879), Color(0xFFE0A92E), Color(0xFFC42943),
    Color(0xFFA41E34), Color(0xFFFCF6EA), Color(0xFF6E1423),
  ];
}

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with TickerProviderStateMixin {
  late final List<_Piece> _pieces;
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    final r = Random();
    _pieces = List.generate(70, (_) => _Piece(r));
    _controllers = _pieces.map((p) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (p.dur * 1000).toInt()),
      );
      Future.delayed(Duration(milliseconds: (p.delay * 1000).toInt()), () {
        if (mounted) ctrl.forward();
      });
      return ctrl;
    }).toList();
    _anims = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.linear))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return IgnorePointer(
      child: Stack(
        children: List.generate(_pieces.length, (i) {
          final p = _pieces[i];
          return AnimatedBuilder(
            animation: _anims[i],
            builder: (context, child) {
              final y = _anims[i].value * (h + 60) - 12;
              final rot = p.rotation + _anims[i].value * 4 * pi;
              return Positioned(
                left: p.left * w,
                top: y,
                child: Transform.rotate(
                  angle: rot,
                  child: Container(
                    width: 9,
                    height: 14,
                    decoration: BoxDecoration(
                      color: p.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
