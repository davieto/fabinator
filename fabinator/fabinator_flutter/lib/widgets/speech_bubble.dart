import 'package:flutter/material.dart';

enum BubbleSide { left, right }

class SpeechBubble extends StatelessWidget {
  final BubbleSide side;
  final Widget child;
  const SpeechBubble({super.key, required this.side, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFCF6EA), Color(0xFFEBD9B6)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFA9741A).withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
          Positioned(
            top: 20,
            left: side == BubbleSide.right ? null : -10,
            right: side == BubbleSide.right ? -10 : null,
            child: CustomPaint(
              size: const Size(12, 18),
              painter: _TrianglePainter(side: side),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final BubbleSide side;
  const _TrianglePainter({required this.side});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEBD9B6)
      ..style = PaintingStyle.fill;
    final path = Path();
    if (side == BubbleSide.right) {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.side != side;
}
