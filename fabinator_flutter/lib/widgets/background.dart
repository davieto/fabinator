import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class _Spark {
  final double left, top, size, delay;
  _Spark(Random r)
      : left = r.nextDouble(),
        top = r.nextDouble(),
        size = 6 + r.nextDouble() * 12,
        delay = r.nextDouble() * 5;
}

class Background extends StatefulWidget {
  const Background({super.key});

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  late final List<_Spark> _sparks;
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    final r = Random();
    _sparks = List.generate(22, (_) => _Spark(r));
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.15),
              radius: 1.4,
              colors: [Color(0xFF7A1B2E), wine800, wine900, wine950],
              stops: [0.0, 0.38, 0.72, 1.0],
            ),
          ),
        ),
        CustomPaint(painter: _WavesPainter()),
        Center(
          child: Container(
            width: 800,
            height: 800,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  goldLight.withValues(alpha: 0.30),
                  gold.withValues(alpha: 0.12),
                  gold.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.32, 0.64],
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) => Stack(
            children: _sparks.map((s) {
              final t = (_ctrl.value + s.delay / 10) % 1.0;
              final opacity = t < 0.5
                  ? (t / 0.5) * 0.85
                  : ((1 - t) / 0.5) * 0.85;
              final rotation = t * pi / 4;
              return Positioned(
                left: MediaQuery.sizeOf(context).width * s.left,
                top: MediaQuery.sizeOf(context).height * s.top,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.rotate(
                    angle: rotation,
                    child: Icon(Icons.star, size: s.size, color: goldLight),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void wave(List<Offset> pts, Color color, double opacity) {
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      final path = Path()
        ..moveTo(pts.first.dx * size.width, pts.first.dy * size.height);
      for (var i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx * size.width, pts[i].dy * size.height);
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    wave([
      const Offset(-0.03, 0.18), const Offset(0.21, 0.07), const Offset(0.53, 0.29),
      const Offset(0.72, 0.20), const Offset(1.04, 0.08), const Offset(1.04, -0.04),
      const Offset(-0.03, -0.04),
    ], const Color(0xFF7A1B2E), 0.35);

    wave([
      const Offset(-0.03, 0.33), const Offset(0.18, 0.23), const Offset(0.39, 0.44),
      const Offset(0.57, 0.33), const Offset(0.75, 0.22), const Offset(0.90, 0.40),
      const Offset(1.04, 0.31), const Offset(1.04, 0.0), const Offset(-0.03, 0.0),
    ], const Color(0xFF6E1423), 0.40);

    wave([
      const Offset(-0.03, 0.84), const Offset(0.18, 0.96), const Offset(0.36, 0.71),
      const Offset(0.57, 0.82), const Offset(0.76, 0.92), const Offset(0.92, 0.73),
      const Offset(1.04, 0.82), const Offset(1.04, 1.04), const Offset(-0.03, 1.04),
    ], const Color(0xFF4A1120), 0.55);

    wave([
      const Offset(-0.03, 0.93), const Offset(0.22, 0.84), const Offset(0.42, 1.0),
      const Offset(0.63, 0.91), const Offset(0.80, 0.83), const Offset(0.92, 0.96),
      const Offset(1.04, 0.89), const Offset(1.04, 1.04), const Offset(-0.03, 1.04),
    ], const Color(0xFF3A0E18), 0.60);
  }

  @override
  bool shouldRepaint(_) => false;
}
