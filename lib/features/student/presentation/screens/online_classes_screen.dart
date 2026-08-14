import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/online_class.dart';
import '../../../../services/mock_online_class_service.dart';

class OnlineClassesScreen extends StatelessWidget {
  const OnlineClassesScreen({super.key});

  void _showJoinClassDialog(BuildContext context, OnlineClassModel cls) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.videocam_rounded, color: Colors.green),
            const SizedBox(width: 8),
            Text('Join ${cls.subject}?',
                style: const TextStyle(
                    color: AppColors.primaryPurple, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Faculty: ${cls.faculty}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Platform: ${cls.platform}'),
            const SizedBox(height: 4),
            Text('Time: ${cls.startTime} - ${cls.endTime}'),
            const SizedBox(height: 12),
            const Text(
              'Connecting to virtual classroom meeting link...',
              style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Joined ${cls.subject} live class!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('JOIN NOW', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final classes = MockOnlineClassService().getOnlineClasses();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Online Classes'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final cls = classes[index];
              final isLive = cls.status == 'LIVE';
              final isUpcoming = cls.status == 'UPCOMING';

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isLive
                        ? Colors.green
                        : AppColors.primaryPurple.withValues(alpha: 0.15),
                    width: isLive ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isLive
                                  ? Colors.green.shade50
                                  : (isUpcoming
                                      ? Colors.blue.shade50
                                      : AppColors.lightBackground),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isLive
                                    ? Colors.green
                                    : (isUpcoming
                                        ? Colors.blue
                                        : AppColors.secondaryText),
                              ),
                            ),
                            child: Row(
                              children: [
                                if (isLive)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Text(
                                  cls.status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: isLive
                                        ? Colors.green.shade800
                                        : (isUpcoming
                                            ? Colors.blue.shade800
                                            : AppColors.secondaryText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            cls.platform,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cls.subject,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Faculty: ${cls.faculty}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 16, color: AppColors.primaryPurple),
                          const SizedBox(width: 6),
                          Text(
                            '${cls.date}  •  ${cls.startTime} - ${cls.endTime}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Action Button
                      if (isLive)
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: () => _showJoinClassDialog(context, cls),
                            icon: const Icon(Icons.videocam, color: Colors.white),
                            label: const Text(
                              'JOIN CLASS NOW',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      else if (isUpcoming)
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_none,
                                color: AppColors.primaryPurple),
                            label: const Text(
                              'CLASS DETAILS (UPCOMING)',
                              style: TextStyle(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              side:
                                  const BorderSide(color: AppColors.primaryPurple),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      else
                        const Center(
                          child: Text(
                            'Class Completed',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
