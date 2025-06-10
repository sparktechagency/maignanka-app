import 'dart:math';
import 'package:flutter/material.dart';

class SemiCircleLoader extends StatefulWidget {
  const SemiCircleLoader({super.key});

  @override
  State<SemiCircleLoader> createState() => _SemiCircleLoaderState();
}

class _SemiCircleLoaderState extends State<SemiCircleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: CustomPaint(
            painter: SemiCirclePainter(),
            size: const Size(70, 70), // Adjust size as needed
          ),
        );
      },
    );
  }
}


class SemiCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 14.0;
    final rect = Offset.zero & size;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: 2 * pi,
        colors: [
          Color(0xffE0001B),
          Color(0xffFFFFFF),
        ],
      ).createShader(rect);

    // Draw arc - adjust angles for "open gap"
    canvas.drawArc(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      pi * 0.05, // start angle
      pi * 1.8, // sweep angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
