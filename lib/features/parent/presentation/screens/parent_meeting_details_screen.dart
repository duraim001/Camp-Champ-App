import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/parent_teacher_meeting.dart';
import '../../../../services/mock_parent_teacher_meeting_service.dart';

class ParentMeetingDetailsScreen extends StatefulWidget {
  final ParentTeacherMeetingModel meeting;

  const ParentMeetingDetailsScreen({super.key, required this.meeting});

  @override
  State<ParentMeetingDetailsScreen> createState() => _ParentMeetingDetailsScreenState();
}

class _ParentMeetingDetailsScreenState extends State<ParentMeetingDetailsScreen> {
  late ParentTeacherMeetingModel _meeting;

  @override
  void initState() {
    super.initState();
    _meeting = widget.meeting;
  }

  void _confirmCancelMeeting() {
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
        content: const Text(
          'Are you sure you want to cancel this meeting request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await MockParentTeacherMeetingService().cancelMeeting(_meeting.id);
              if (success && mounted) {
                setState(() {
                  _meeting = _meeting.copyWith(status: MeetingStatus.cancelled);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Meeting status updated to CANCELLED.')),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Meeting Details'),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.gold),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID: ${_meeting.id}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _meeting.status == MeetingStatus.confirmed
                                ? Colors.green.shade100
                                : (_meeting.status == MeetingStatus.requested
                                    ? Colors.orange.shade100
                                    : Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _meeting.status.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: _meeting.status == MeetingStatus.confirmed
                                  ? Colors.green.shade800
                                  : (_meeting.status == MeetingStatus.requested
                                      ? Colors.orange.shade900
                                      : Colors.grey.shade800),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    _buildInfoRow('Parent Name', 'Mr. Kumar'),
                    _buildInfoRow('Student', '${_meeting.studentName} (${_meeting.registerNumber})'),
                    _buildInfoRow('Teacher', _meeting.teacherName),
                    _buildInfoRow('Subject', _meeting.subject),
                    _buildInfoRow('Date', _meeting.date),
                    _buildInfoRow('Time Slot', '${_meeting.startTime} – ${_meeting.endTime}'),
                    _buildInfoRow('Meeting Type', _meeting.meetingType),
                    _buildInfoRow('Notes / Agenda', _meeting.notes),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_meeting.status == MeetingStatus.confirmed) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _meeting.status.description,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text(
                              'Please join using the Google Meet link 5 mins prior.',
                              style: TextStyle(fontSize: 12, color: AppColors.darkText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening Google Meet video room... (Demo Link)')),
                      );
                    },
                    icon: const Icon(Icons.video_call_rounded, color: AppColors.white),
                    label: const Text(
                      'JOIN MEETING',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],

              if (_meeting.status == MeetingStatus.requested)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _confirmCancelMeeting,
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                    label: const Text(
                      'CANCEL MEETING',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
