import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

enum BubbleSide { left, right }

class SpeechBubble extends StatelessWidget {
  final BubbleSide side;
  final Widget child;

  const SpeechBubble({super.key, required this.side, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TailPainter(side),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: panel,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFA9741A).withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: DefaultTextStyle(
          style: GoogleFonts.spectral(fontSize: 17, color: ink, height: 1.45),
          child: child,
        ),
      ),
    );
  }
}

class _TailPainter extends CustomPainter {
  final BubbleSide side;
  _TailPainter(this.side);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = panel
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = const Color(0xFFA9741A).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path();
    if (side == BubbleSide.right) {
      path
        ..moveTo(size.width, 30)
        ..lineTo(size.width + 18, 44)
        ..lineTo(size.width, 58)
        ..close();
    } else {
      path
        ..moveTo(0, 30)
        ..lineTo(-18, 44)
        ..lineTo(0, 58)
        ..close();
    }
    canvas.drawPath(path, fill);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(_) => false;
}
