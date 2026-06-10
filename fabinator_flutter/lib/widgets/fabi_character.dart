import 'package:flutter/material.dart';
import '../models/fabi_mood.dart';

class FabiCharacter extends StatefulWidget {
  final FabiMood mood;
  final double height;

  const FabiCharacter({super.key, required this.mood, this.height = 400});

  @override
  State<FabiCharacter> createState() => _FabiCharacterState();
}

class _FabiCharacterState extends State<FabiCharacter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  static const _assets = {
    FabiMood.confident: 'assets/fabi-confident.png',
    FabiMood.smile:     'assets/fabi-smile.png',
    FabiMood.worried:   'assets/fabi-worried.png',
    FabiMood.shy:       'assets/fabi-shy.png',
  };

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _float,
      builder: (_, child) {
        final offset = -9.0 * _float.value;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: SizedBox(
        height: widget.height,
        child: AspectRatio(
          aspectRatio: 1056 / 1489,
          child: Stack(
            fit: StackFit.expand,
            children: FabiMood.values.map((m) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 550),
                opacity: m == widget.mood ? 1.0 : 0.0,
                child: Image.asset(
                  _assets[m]!,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
