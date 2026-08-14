import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// CollegeBranding displays the institutional emblem and college details.
class CollegeBranding extends StatelessWidget {
  const CollegeBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emblem Container with subtle gold halo (Increased size by ~20% for stronger visual focal point)
        Container(
          height: 155,
          width: 155,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.25),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.08),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: AppColors.gold,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/college_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.school_rounded,
                    size: 60,
                    color: AppColors.primaryPurple,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        // College Name
        const Text(
          'SENGUNTHAR ENGINEERING COLLEGE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primaryPurple,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 3),
        // Location & Est.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TIRUCHENGODE',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 3.5,
              height: 3.5,
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
            ),
            const Text(
              'Est. 2001',
              style: TextStyle(
                color: AppColors.secondaryPurple,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
