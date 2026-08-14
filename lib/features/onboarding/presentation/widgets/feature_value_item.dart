import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class FeatureValueData {
  final IconData icon;
  final String label;

  const FeatureValueData({
    required this.icon,
    required this.label,
  });
}

/// FeatureValueItem renders a simple, non-clickable icon + label informational indicator.
class FeatureValueItem extends StatelessWidget {
  final FeatureValueData data;

  const FeatureValueItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Professional Icon (No button background, card, border or shadow)
        Icon(
          data.icon,
          size: 28,
          color: AppColors.primaryPurple,
        ),
        const SizedBox(height: 6),
        // Feature Title
        Text(
          data.label,
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

/// FeatureValuesRow displays SECURE, SMART, INTELLIGENT informational indicators.
class FeatureValuesRow extends StatelessWidget {
  const FeatureValuesRow({super.key});

  static const List<FeatureValueData> features = [
    FeatureValueData(
      icon: Icons.security_rounded,
      label: 'SECURE',
    ),
    FeatureValueData(
      icon: Icons.school_rounded,
      label: 'SMART',
    ),
    FeatureValueData(
      icon: Icons.psychology_rounded,
      label: 'INTELLIGENT',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: features
            .map((feature) => FeatureValueItem(data: feature))
            .toList(),
      ),
    );
  }
}
