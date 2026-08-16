import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_parent_service.dart';
import '../../../../services/mock_sms_service.dart';

class SmsParentDialog extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String registerNumber;
  final String subject;
  final String date;

  const SmsParentDialog({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.registerNumber,
    required this.subject,
    required this.date,
  });

  @override
  State<SmsParentDialog> createState() => _SmsParentDialogState();
}

class _SmsParentDialogState extends State<SmsParentDialog> {
  bool _isLoading = true;
  bool _isSending = false;
  String _parentName = '';
  String _parentPhone = '';
  String _parentId = '';
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _loadParentInfo();
  }

  void _loadParentInfo() async {
    final parent = await MockParentService().getParentByStudentId(widget.studentId);
    if (mounted) {
      setState(() {
        _parentName = parent?.name ?? 'Parent/Guardian';
        _parentPhone = parent?.phone ?? '+91 90000 00003';
        _parentId = parent?.id ?? 'PAR001';
        _messageController.text =
            'Dear Parent/Guardian, your ward ${widget.studentName} (${widget.registerNumber}) was marked ABSENT for ${widget.subject} class on ${widget.date}. Please contact the college if necessary. - Camp Champ';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendSms() async {
    setState(() {
      _isSending = true;
    });

    await MockSmsService().sendParentAbsenceSms(
      studentId: widget.studentId,
      studentName: widget.studentName,
      parentId: _parentId,
      parentName: _parentName,
      parentPhone: _parentPhone,
      teacherId: 'SEC-TCH-001',
      subject: widget.subject,
      date: widget.date,
      message: _messageController.text,
    );

    if (!mounted) return;

    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.gold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'SMS Sent Successfully! $_parentName ($_parentPhone) notified.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
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
        child: _isLoading
            ? const SizedBox(
                height: 140,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primaryPurple),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dialog Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sms_outlined,
                          color: AppColors.primaryPurple,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Notify Parent?',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context, false),
                        icon: const Icon(Icons.close_rounded),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Student & Parent details
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: AppColors.darkText, fontSize: 13),
                            children: [
                              const TextSpan(
                                text: 'Student: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${widget.studentName} (${widget.registerNumber})'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: AppColors.darkText, fontSize: 13),
                            children: [
                              const TextSpan(
                                text: 'Parent: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '$_parentName  |  $_parentPhone'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'Suggested Message:',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),

                  TextField(
                    controller: _messageController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12.5),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
                        onPressed: _isSending ? null : () => Navigator.pop(context, false),
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _isSending ? null : _sendSms,
                        icon: _isSending
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send_rounded, size: 16, color: AppColors.white),
                        label: Text(
                          _isSending ? 'Sending...' : 'SEND SMS',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
}
