import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// HeaderPainter renders a dark purple curved banner at the top
/// with an elegant flowing gold accent curve underneath.
class HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Purple Curved Header Fill (Fills completely down to the gold curve line)
    final Paint purplePaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Path purplePath = Path();
    purplePath.moveTo(0, 0);
    purplePath.lineTo(0, size.height * 0.70);
    purplePath.cubicTo(
      size.width * 0.35,
      size.height * 1.00,
      size.width * 0.65,
      size.height * 0.50,
      size.width,
      size.height * 0.80,
    );
    purplePath.lineTo(size.width, 0);
    purplePath.close();

    canvas.drawPath(purplePath, purplePaint);

    // 2. Draw Gold Accent Curve Line (Exact boundary line along bottom edge of purple fill)
    final Paint goldPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final Path goldPath = Path();
    goldPath.moveTo(0, size.height * 0.70);
    goldPath.cubicTo(
      size.width * 0.35,
      size.height * 1.00,
      size.width * 0.65,
      size.height * 0.50,
      size.width,
      size.height * 0.80,
    );
    canvas.drawPath(goldPath, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CurvedHeaderWidget extends StatelessWidget {
  final double height;

  const CurvedHeaderWidget({
    super.key,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double totalHeight = height + topPadding;

    return SizedBox(
      width: double.infinity,
      height: totalHeight,
      child: CustomPaint(
        painter: HeaderPainter(),
      ),
    );
  }
}
