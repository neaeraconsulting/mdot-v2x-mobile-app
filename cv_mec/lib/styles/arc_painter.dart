import 'package:flutter/widgets.dart';

class ArcPainter extends CustomPainter {
  final double percent; // 0.0 to 1.0
  final Color color;
  ArcPainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final startAngle = 3 * 3.1416 / 4; // 135 degrees
    final sweepAngle = 3 * 3.1416 / 2 * percent; // up to 270 degrees
    final paint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.drawArc(
      rect.deflate(10), // Padding from edge
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) => oldDelegate.percent != percent || oldDelegate.color != color;
}
