import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rng = Random();
  late final List<_Particle> _particles;

  static const _colors = [
    Color(0xFFE0A92E), Color(0xFFF6D879), Color(0xFF7C2336),
    Color(0xFFD42B42), Color(0xFFFCF6EA), Color(0xFF5C1626),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _particles = List.generate(80, (_) => _Particle(_rng));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, _) => CustomPaint(
        painter: _ConfettiPainter(
          particles: _particles,
          progress: _ctrl.value,
          colors: _colors,
        ),
        size: MediaQuery.sizeOf(ctx),
      ),
    );
  }
}

class _Particle {
  final double x, y, speed, drift, size, rotation;
  final int colorIndex;

  _Particle(Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        speed = 0.1 + rng.nextDouble() * 0.3,
        drift = (rng.nextDouble() - 0.5) * 0.1,
        size = 4 + rng.nextDouble() * 8,
        colorIndex = rng.nextInt(6),
        rotation = rng.nextDouble() * 2 * pi;
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final List<Color> colors;

  const _ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (p.y + progress * p.speed) % 1.0;
      final x = (p.x + progress * p.drift) % 1.0;
      final paint = Paint()
        ..color = colors[p.colorIndex].withValues(alpha: 0.8);
      canvas.save();
      canvas.translate(x * size.width, t * size.height);
      canvas.rotate(p.rotation + progress * 3);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
