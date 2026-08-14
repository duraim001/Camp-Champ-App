import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_parent_teacher_meeting_service.dart';

class BookMeetingDialog extends StatefulWidget {
  final String teacherId;
  final String teacherName;
  final String subject;
  final String date;
  final String startTime;
  final String endTime;

  const BookMeetingDialog({
    super.key,
    required this.teacherId,
    required this.teacherName,
    required this.subject,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<BookMeetingDialog> createState() => _BookMeetingDialogState();
}

class _BookMeetingDialogState extends State<BookMeetingDialog> {
  final _notesController = TextEditingController();
  bool _isBooking = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _confirmBooking() async {
    setState(() {
      _isBooking = true;
    });

    await MockParentTeacherMeetingService().bookMeeting(
      parentId: 'SEC-PAR-001',
      studentId: '1',
      studentName: 'Arun Kumar',
      registerNumber: 'SEC2024001',
      teacherId: widget.teacherId,
      teacherName: widget.teacherName,
      subject: widget.subject,
      date: widget.date,
      startTime: widget.startTime,
      endTime: widget.endTime,
      notes: _notesController.text.trim().isEmpty
          ? 'Parent requested session regarding academic performance.'
          : _notesController.text.trim(),
    );

    if (!mounted) return;

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.gold),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Meeting request submitted successfully.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_available_rounded,
                    color: AppColors.primaryPurple,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Book Parent–Teacher Meeting',
                    style: TextStyle(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Meeting Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Student:', 'Arun Kumar (SEC2024001)'),
                  const SizedBox(height: 4),
                  _buildDetailRow('Teacher:', widget.teacherName),
                  const SizedBox(height: 4),
                  _buildDetailRow('Subject:', widget.subject),
                  const SizedBox(height: 4),
                  _buildDetailRow('Date:', widget.date),
                  const SizedBox(height: 4),
                  _buildDetailRow('Time:', '${widget.startTime} – ${widget.endTime}'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'Agenda / Notes for Teacher (Optional):',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: _notesController,
              maxLines: 2,
              style: const TextStyle(fontSize: 12.5),
              decoration: InputDecoration(
                hintText: 'e.g. Discuss CIA 3 marks and attendance progress...',
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.primaryPurple.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isBooking ? null : () => Navigator.pop(context, false),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isBooking ? null : _confirmBooking,
                  icon: _isBooking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.white),
                  label: Text(
                    _isBooking ? 'Booking...' : 'CONFIRM MEETING',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: AppColors.darkText, fontSize: 12.5),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
