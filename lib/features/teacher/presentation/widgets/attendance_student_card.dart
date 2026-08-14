import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/attendance_record.dart';

class AttendanceStudentCard extends StatelessWidget {
  final AttendanceRecord record;
  final Function(AttendanceStatus) onStatusChanged;
  final VoidCallback onSmsParentTap;

  const AttendanceStudentCard({
    super.key,
    required this.record,
    required this.onStatusChanged,
    required this.onSmsParentTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPresent = record.status == AttendanceStatus.present;
    final bool isAbsent = record.status == AttendanceStatus.absent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAbsent
              ? Colors.red.withValues(alpha: 0.3)
              : (isPresent
                  ? Colors.green.withValues(alpha: 0.3)
                  : AppColors.primaryPurple.withValues(alpha: 0.08)),
          width: isAbsent || isPresent ? 1.5 : 1.0,
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
          // Student Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isAbsent
                    ? Colors.red.withValues(alpha: 0.1)
                    : (isPresent
                        ? Colors.green.withValues(alpha: 0.1)
                        : AppColors.primaryPurple.withValues(alpha: 0.1)),
                child: Text(
                  record.studentName.isNotEmpty ? record.studentName[0] : 'S',
                  style: TextStyle(
                    color: isAbsent
                        ? Colors.red
                        : (isPresent ? Colors.green : AppColors.primaryPurple),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.studentName,
                      style: const TextStyle(
                        color: AppColors.darkText,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Reg: ${record.registerNumber}',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Status indicator when SMS is sent
              if (isAbsent && record.smsSent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.green, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '✓ SMS Sent',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Checkbox Attendance Options (Present / Absent)
          Row(
            children: [
              // PRESENT Checkbox Option
              Expanded(
                child: InkWell(
                  onTap: () => onStatusChanged(AttendanceStatus.present),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isPresent
                          ? Colors.green.withValues(alpha: 0.1)
                          : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isPresent ? Colors.green : Colors.grey.shade300,
                        width: isPresent ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isPresent ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                          color: isPresent ? Colors.green : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Present',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isPresent ? Colors.green : AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // ABSENT Checkbox Option
              Expanded(
                child: InkWell(
                  onTap: () => onStatusChanged(AttendanceStatus.absent),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isAbsent
                          ? Colors.red.withValues(alpha: 0.1)
                          : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isAbsent ? Colors.red : Colors.grey.shade300,
                        width: isAbsent ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isAbsent ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                          color: isAbsent ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Absent',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isAbsent ? Colors.red : AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // SMS PARENT BUTTON - Appears ONLY when status == ABSENT AND SMS has NOT been sent yet
          if (isAbsent && !record.smsSent) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton.icon(
                onPressed: onSmsParentTap,
                icon: const Icon(Icons.sms_rounded, size: 16, color: AppColors.primaryPurple),
                label: const Text(
                  'Send SMS',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
