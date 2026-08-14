import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TeacherNotificationsScreen extends StatelessWidget {
  const TeacherNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Online Class Starts Soon',
        'desc': 'Data Structures online class starts in 15 minutes.',
        'time': '09:45 AM',
        'icon': Icons.video_camera_front_rounded,
      },
      {
        'title': 'Parent Notification Sent',
        'desc': 'Automated absence SMS delivered to parent of Karthik M.',
        'time': '10:15 AM',
        'icon': Icons.sms_rounded,
      },
      {
        'title': 'New Assignment Submission',
        'desc': 'Priya S submitted Assignment 1: Trees and Graphs.',
        'time': 'Yesterday',
        'icon': Icons.assignment_turned_in_rounded,
      },
      {
        'title': 'Admin Announcement',
        'desc': 'Faculty meeting scheduled for Friday at 03:30 PM.',
        'time': '10 Aug 2026',
        'icon': Icons.campaign_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Faculty Notifications'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.08)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        n['icon'] as IconData,
                        color: AppColors.primaryPurple,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                n['title'] as String,
                                style: const TextStyle(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                n['time'] as String,
                                style: const TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            n['desc'] as String,
                            style: const TextStyle(
                              color: AppColors.darkText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
