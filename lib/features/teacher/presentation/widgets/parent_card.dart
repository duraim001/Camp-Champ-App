import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/parent.dart';

class ParentCard extends StatelessWidget {
  final ParentModel parent;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onSms;

  const ParentCard({
    super.key,
    required this.parent,
    required this.onTap,
    required this.onCall,
    required this.onSms,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryPurple.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.gold.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.family_restroom_rounded,
                    color: AppColors.primaryPurple,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parent.name,
                        style: const TextStyle(
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${parent.relationship} of ${parent.studentName} (${parent.registerNumber})',
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.phone_rounded, size: 14, color: AppColors.secondaryText),
                    const SizedBox(width: 6),
                    Text(
                      parent.phone,
                      style: const TextStyle(
                        color: AppColors.darkText,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // CALL action
                    IconButton(
                      icon: const Icon(Icons.call_rounded, color: Colors.green, size: 20),
                      onPressed: onCall,
                      tooltip: 'Call Parent',
                    ),
                    // SMS action
                    IconButton(
                      icon: const Icon(Icons.sms_rounded, color: AppColors.primaryPurple, size: 20),
                      onPressed: onSms,
                      tooltip: 'SMS Parent',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
