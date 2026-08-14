import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// FooterPainter renders a dark purple curved banner at the bottom
/// with a gold accent curve along the top edge.
class FooterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Purple Curved Footer Fill (Fills completely from gold curve line down to bottom)
    final Paint purplePaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.secondaryPurple, AppColors.primaryPurple],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Path purplePath = Path();
    purplePath.moveTo(0, size.height * 0.30);
    purplePath.cubicTo(
      size.width * 0.35,
      size.height * 0.00,
      size.width * 0.65,
      size.height * 0.50,
      size.width,
      size.height * 0.20,
    );
    purplePath.lineTo(size.width, size.height);
    purplePath.lineTo(0, size.height);
    purplePath.close();

    canvas.drawPath(purplePath, purplePaint);

    // 2. Draw Gold Accent Curve Line (Exact boundary line along top edge of purple fill)
    final Paint goldPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final Path goldPath = Path();
    goldPath.moveTo(0, size.height * 0.30);
    goldPath.cubicTo(
      size.width * 0.35,
      size.height * 0.00,
      size.width * 0.65,
      size.height * 0.50,
      size.width,
      size.height * 0.20,
    );
    canvas.drawPath(goldPath, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CurvedFooterWidget extends StatelessWidget {
  final double height;
  final String text;

  const CurvedFooterWidget({
    super.key,
    this.height = 90,
    this.text = 'Empowering Education with AI',
  });

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double totalHeight = height + bottomPadding;

    return SizedBox(
      width: double.infinity,
      height: totalHeight,
      child: CustomPaint(
        painter: FooterPainter(),
        child: Padding(
          padding: EdgeInsets.only(
            top: 36,
            bottom: bottomPadding > 0 ? bottomPadding : 14,
            left: 20,
            right: 20,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
