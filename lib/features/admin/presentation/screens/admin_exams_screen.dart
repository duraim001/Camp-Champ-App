import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_exam_service.dart';

class AdminExamsScreen extends StatelessWidget {
  const AdminExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = MockExamService().getExams();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.assignment_turned_in_rounded, color: AppColors.gold, size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Examinations & Valuation',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'CIA Internal Tests & End Semester Master Schedules',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.15)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Active Phase', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                          SizedBox(height: 4),
                          Text('CIA 3 & Practical', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryPurple)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Valuation Status', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                          SizedBox(height: 4),
                          Text('88% Completed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Scheduled Examinations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                    label: const Text('Add Exam'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  final exam = exams[index];
                  final isSemester = exam.examType == 'Semester';
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSemester ? AppColors.gold.withValues(alpha: 0.6) : AppColors.primaryPurple.withValues(alpha: 0.12),
                        width: isSemester ? 1.5 : 1.0,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: isSemester ? AppColors.gold.withValues(alpha: 0.2) : AppColors.primaryPurple.withValues(alpha: 0.1),
                        child: Icon(
                          isSemester ? Icons.workspace_premium_rounded : Icons.quiz_rounded,
                          color: isSemester ? AppColors.primaryPurple : AppColors.primaryPurple,
                          size: 20,
                        ),
                      ),
                      title: Text(exam.subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('${exam.examType} • ${exam.date} (${exam.time})\nRoom: ${exam.room}', style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                      isThreeLine: true,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          exam.examType,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
