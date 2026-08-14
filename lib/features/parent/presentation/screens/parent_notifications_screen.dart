import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_fee_service.dart';
import 'parent_fee_payment_screen.dart';

class ParentNotificationsScreen extends StatefulWidget {
  const ParentNotificationsScreen({super.key});

  @override
  State<ParentNotificationsScreen> createState() => _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState extends State<ParentNotificationsScreen> {
  late List<Map<String, dynamic>> _notifications;

  @override
  void initState() {
    super.initState();
    _buildNotificationsList();
  }

  void _buildNotificationsList() {
    final feeRecord = MockFeeService().getFeeRecord('STU001');

    final baseNotifications = [
      {
        'id': 'N1',
        'title': 'CIA 3 Marks Published',
        'body': "Your child's CIA 3 marks for Data Structures (88/100) have been published.",
        'time': '10 mins ago',
        'isRead': false,
        'icon': Icons.grade_rounded,
        'color': AppColors.primaryPurple,
        'isFeeNotification': false,
      },
      {
        'id': 'N2',
        'title': 'Meeting Confirmed',
        'body': 'Your meeting with Dr. Ravi Kumar for 15 August 2026 has been confirmed.',
        'time': '2 hours ago',
        'isRead': false,
        'icon': Icons.event_available_rounded,
        'color': Colors.green.shade700,
        'isFeeNotification': false,
      },
      {
        'id': 'N3',
        'title': 'New Parent–Teacher Meeting Session Available',
        'body': 'Dr. Ravi Kumar added new time slots for Data Structures PTM on 20 August.',
        'time': 'Yesterday',
        'isRead': true,
        'icon': Icons.calendar_month_rounded,
        'color': AppColors.gold,
        'isFeeNotification': false,
      },
      {
        'id': 'N4',
        'title': 'New Assignment Added',
        'body': 'Data Structures Assignment 03 assigned by Dr. Ravi Kumar. Due: 17 August.',
        'time': '2 days ago',
        'isRead': true,
        'icon': Icons.assignment_rounded,
        'color': Colors.blue.shade700,
        'isFeeNotification': false,
      },
      {
        'id': 'N5',
        'title': 'Attendance Update',
        'body': "Arun Kumar's overall attendance is currently at 87.5% (Good Standing).",
        'time': '3 days ago',
        'isRead': true,
        'icon': Icons.check_circle_outline_rounded,
        'color': Colors.green.shade700,
        'isFeeNotification': false,
      },
    ];

    if (feeRecord.pendingAmount > 0) {
      _notifications = [
        {
          'id': 'N_FEE_REMINDER',
          'title': '🔔 Fee Payment Reminder',
          'body': "Your child's fee payment of ₹${feeRecord.pendingAmount.toStringAsFixed(0)} is pending. Please complete the payment before the due date.",
          'time': 'Just now',
          'isRead': false,
          'icon': Icons.payment_rounded,
          'color': Colors.orange.shade900,
          'isFeeNotification': true,
        },
        ...baseNotifications,
      ];
    } else {
      _notifications = [
        {
          'id': 'N_FEE_SUCCESS',
          'title': '✓ Fee Payment Successful',
          'body': "Your payment of ₹${feeRecord.paidAmount.toStringAsFixed(0)} was successfully completed.",
          'time': 'Just now',
          'isRead': false,
          'icon': Icons.verified_rounded,
          'color': Colors.green.shade700,
          'isFeeNotification': true,
        },
        ...baseNotifications,
      ];
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Parent Notifications'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: AppColors.gold),
            tooltip: 'Mark all as read',
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final item = _notifications[index];
            final isRead = item['isRead'] as bool;
            final isFeeNotif = item['isFeeNotification'] as bool? ?? false;

            return GestureDetector(
              onTap: () {
                if (isFeeNotif) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ParentFeePaymentScreen(),
                    ),
                  ).then((_) {
                    setState(() {
                      _buildNotificationsList();
                    });
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isRead ? AppColors.white : AppColors.primaryPurple.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isRead
                        ? AppColors.primaryPurple.withValues(alpha: 0.08)
                        : AppColors.primaryPurple.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 22),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isRead ? FontWeight.bold : FontWeight.w900,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                              ),
                              Text(
                                item['time'] as String,
                                style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['body'] as String,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isRead ? AppColors.secondaryText : AppColors.darkText,
                            ),
                          ),
                          if (isFeeNotif) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'VIEW FEE DETAILS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: item['color'] as Color,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward_rounded, size: 14, color: item['color'] as Color),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
