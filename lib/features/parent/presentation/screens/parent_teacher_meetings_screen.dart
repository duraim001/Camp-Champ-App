import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/parent_teacher_meeting.dart';
import '../../../../services/mock_parent_teacher_meeting_service.dart';
import '../widgets/book_meeting_dialog.dart';
import '../widgets/meeting_card.dart';
import 'parent_meeting_details_screen.dart';

class ParentTeacherMeetingsScreen extends StatefulWidget {
  const ParentTeacherMeetingsScreen({super.key});

  @override
  State<ParentTeacherMeetingsScreen> createState() => _ParentTeacherMeetingsScreenState();
}

class _ParentTeacherMeetingsScreenState extends State<ParentTeacherMeetingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<ParentTeacherMeetingModel> _myMeetings = [];
  List<Map<String, dynamic>> _availableSessions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final my = await MockParentTeacherMeetingService().getMyMeetings('SEC-PAR-001');
    final avail = MockParentTeacherMeetingService().getAvailableSlots();

    if (mounted) {
      setState(() {
        _myMeetings = my;
        _availableSessions = avail;
        _isLoading = false;
      });
    }
  }

  void _openBookingDialog({
    required String teacherId,
    required String teacherName,
    required String subject,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final booked = await showDialog<bool>(
      context: context,
      builder: (ctx) => BookMeetingDialog(
        teacherId: teacherId,
        teacherName: teacherName,
        subject: subject,
        date: date,
        startTime: startTime,
        endTime: endTime,
      ),
    );

    if (booked == true) {
      _loadData();
      _tabController.animateTo(1); // Switch to My Meetings tab
    }
  }

  void _confirmCancelMeeting(ParentTeacherMeetingModel meeting) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Cancel Meeting?'),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel your meeting request with ${meeting.teacherName} on ${meeting.date}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await MockParentTeacherMeetingService().cancelMeeting(meeting.id);
              if (success && mounted) {
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Meeting request cancelled.'),
                    backgroundColor: Colors.grey.shade800,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('CONFIRM CANCELLATION', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Parent–Teacher Meetings'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          indicatorWeight: 3,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.white.withValues(alpha: 0.7),
          tabs: const [
            Tab(icon: Icon(Icons.event_available_rounded), text: 'Available Sessions'),
            Tab(icon: Icon(Icons.bookmarks_rounded), text: 'My Meetings'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Available Sessions
            _buildAvailableSessionsTab(),

            // Tab 2: My Meetings
            _buildMyMeetingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableSessionsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple));
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _availableSessions.length,
      itemBuilder: (context, index) {
        final session = _availableSessions[index];
        final slots = session['timeSlots'] as List<Map<String, dynamic>>;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_pin_rounded,
                      color: AppColors.primaryPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session['teacherName'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        Text(
                          'Subject: ${session['subject']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),

              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primaryPurple),
                  const SizedBox(width: 6),
                  Text(
                    'Date: ${session['date']}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Student: Arun Kumar',
                    style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const Text(
                'Available Time Slots:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: slots.map((slot) {
                  return ActionChip(
                    avatar: const Icon(Icons.schedule_rounded, size: 14, color: AppColors.primaryPurple),
                    label: Text(
                      '${slot['start']} – ${slot['end']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                    side: const BorderSide(color: AppColors.gold),
                    onPressed: () {
                      _openBookingDialog(
                        teacherId: session['teacherId'] as String,
                        teacherName: session['teacherName'] as String,
                        subject: session['subject'] as String,
                        date: session['date'] as String,
                        startTime: slot['start'] as String,
                        endTime: slot['end'] as String,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyMeetingsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple));
    }

    if (_myMeetings.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 54, color: AppColors.secondaryText),
            SizedBox(height: 12),
            Text(
              'No Parent–Teacher meetings available.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _myMeetings.length,
      itemBuilder: (context, index) {
        final meeting = _myMeetings[index];
        return MeetingCard(
          meeting: meeting,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ParentMeetingDetailsScreen(meeting: meeting),
              ),
            );
          },
          onCancel: meeting.status == MeetingStatus.requested
              ? () => _confirmCancelMeeting(meeting)
              : null,
        );
      },
    );
  }
}
