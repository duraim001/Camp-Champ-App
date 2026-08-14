import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/notification.dart';
import '../../../../services/mock_notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<StudentNotificationModel> notifications;

  @override
  void initState() {
    super.initState();
    notifications = MockNotificationService().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: notifications.isEmpty
              ? const Center(
                  child: Text('No new notifications.'),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: item.isRead
                              ? AppColors.primaryPurple.withValues(alpha: 0.1)
                              : AppColors.gold,
                          width: item.isRead ? 1 : 1.5,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),
                        leading: CircleAvatar(
                          backgroundColor: item.isRead
                              ? AppColors.lightBackground
                              : AppColors.gold.withValues(alpha: 0.2),
                          child: Icon(
                            item.isRead
                                ? Icons.notifications_none
                                : Icons.notifications_active,
                            color: AppColors.primaryPurple,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: item.isRead
                                    ? AppColors.darkText
                                    : AppColors.primaryPurple,
                              ),
                            ),
                            Text(
                              item.date,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            item.message,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.secondaryText),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            MockNotificationService().markAsRead(item.id);
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
