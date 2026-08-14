import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/online_class.dart';
import '../../../../services/mock_online_class_service.dart';
import 'create_online_class_screen.dart';

class TeacherOnlineClassesScreen extends StatefulWidget {
  const TeacherOnlineClassesScreen({super.key});

  @override
  State<TeacherOnlineClassesScreen> createState() => _TeacherOnlineClassesScreenState();
}

class _TeacherOnlineClassesScreenState extends State<TeacherOnlineClassesScreen> {
  List<OnlineClassModel> _classes = [];
  bool _isLoading = true;
  String _selectedTab = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() async {
    final list = await MockOnlineClassService().getTeacherClasses('SEC-TCH-001');
    if (mounted) {
      setState(() {
        _classes = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _classes.where((c) {
      if (_selectedTab == 'LIVE') return c.status == 'LIVE';
      if (_selectedTab == 'UPCOMING') return c.status == 'UPCOMING';
      if (_selectedTab == 'COMPLETED') return c.status == 'COMPLETED';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Online Classes'),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateOnlineClassScreen(),
            ),
          );
          if (result == true) {
            _loadClasses();
          }
        },
        backgroundColor: AppColors.gold,
        icon: const Icon(Icons.add_rounded, color: AppColors.primaryPurple),
        label: const Text(
          'CREATE CLASS',
          style: TextStyle(
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Filter tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['ALL', 'LIVE', 'UPCOMING', 'COMPLETED'].map((tab) {
                    final bool isSelected = _selectedTab == tab;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(tab),
                        selected: isSelected,
                        selectedColor: AppColors.gold,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primaryPurple : AppColors.darkText,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (val) {
                          setState(() {
                            _selectedTab = tab;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple))
                    : filtered.isEmpty
                        ? const Center(
                            child: Text(
                              'No online classes found',
                              style: TextStyle(color: AppColors.secondaryText),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              final bool isLive = item.status == 'LIVE';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isLive
                                        ? Colors.red.withValues(alpha: 0.5)
                                        : AppColors.primaryPurple.withValues(alpha: 0.1),
                                    width: isLive ? 1.5 : 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryPurple.withValues(alpha: 0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryPurple.withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.video_camera_front_rounded,
                                            color: AppColors.primaryPurple,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.subject,
                                                style: const TextStyle(
                                                  color: AppColors.primaryPurple,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                item.className,
                                                style: const TextStyle(
                                                  color: AppColors.secondaryText,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isLive ? Colors.red : AppColors.gold.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            item.status,
                                            style: TextStyle(
                                              color: isLive ? AppColors.white : AppColors.primaryPurple,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Date: ${item.date}  |  ${item.startTime} - ${item.endTime}',
                                      style: const TextStyle(
                                        color: AppColors.darkText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Divider(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Platform: ${item.platform}',
                                          style: const TextStyle(
                                            color: AppColors.secondaryText,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(isLive ? 'Joining live class room...' : 'Starting class room session...'),
                                                backgroundColor: AppColors.primaryPurple,
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            isLive ? Icons.play_arrow_rounded : Icons.launch_rounded,
                                            size: 16,
                                            color: AppColors.primaryPurple,
                                          ),
                                          label: Text(
                                            isLive ? 'JOIN LIVE' : 'START CLASS',
                                            style: const TextStyle(
                                              color: AppColors.primaryPurple,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.gold,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
