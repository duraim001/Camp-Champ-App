import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TeacherParentDetailsScreen extends StatelessWidget {
  const TeacherParentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parents = [
      {
        'studentName': 'Karthik M',
        'regNo': '73222104001',
        'classYear': '2nd Year CSE',
        'parentName': 'Murugan K',
        'relation': 'Father',
        'phone': '+91 98421 12345',
        'email': 'murugan.k@gmail.com',
        'occupation': 'Business',
      },
      {
        'studentName': 'Priya S',
        'regNo': '73222104002',
        'classYear': '2nd Year CSE',
        'parentName': 'Shanmugam P',
        'relation': 'Father',
        'phone': '+91 94432 67890',
        'email': 'shanmugam.p@yahoo.com',
        'occupation': 'Engineer',
      },
      {
        'studentName': 'Arun Kumar V',
        'regNo': '73222104003',
        'classYear': '3rd Year CSE',
        'parentName': 'Velusamy R',
        'relation': 'Father',
        'phone': '+91 98940 54321',
        'email': 'velusamy.r@outlook.com',
        'occupation': 'Government Service',
      },
      {
        'studentName': 'Divya B',
        'regNo': '73222104004',
        'classYear': '3rd Year CSE',
        'parentName': 'Baskaran T',
        'relation': 'Father',
        'phone': '+91 97891 23456',
        'email': 'baskaran.t@gmail.com',
        'occupation': 'Teacher',
      },
      {
        'studentName': 'Suresh R',
        'regNo': '73222104005',
        'classYear': '4th Year CSE',
        'parentName': 'Ramasamy N',
        'relation': 'Father',
        'phone': '+91 99423 89012',
        'email': 'ramasamy.n@gmail.com',
        'occupation': 'Farmer',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Parent Details Directory'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: parents.length,
            itemBuilder: (context, index) {
              final p = parents[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.04),
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
                          radius: 20,
                          backgroundColor:
                              AppColors.primaryPurple.withValues(alpha: 0.1),
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
                                p['parentName']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              Text(
                                '${p['relation']} of ${p['studentName']} (${p['classYear']})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 18),
                    _buildInfoRow(Icons.badge_outlined, 'Student Reg No', p['regNo']!),
                    _buildInfoRow(Icons.phone_outlined, 'Phone', p['phone']!),
                    _buildInfoRow(Icons.email_outlined, 'Email', p['email']!),
                    _buildInfoRow(Icons.work_outline, 'Occupation', p['occupation']!),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryPurple),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.darkText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
