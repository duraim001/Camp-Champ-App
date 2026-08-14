import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_online_class_service.dart';

class CreateOnlineClassScreen extends StatefulWidget {
  const CreateOnlineClassScreen({super.key});

  @override
  State<CreateOnlineClassScreen> createState() => _CreateOnlineClassScreenState();
}

class _CreateOnlineClassScreenState extends State<CreateOnlineClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController(text: 'Data Structures');
  final _classController = TextEditingController(text: '3rd Year - CSE - A');
  final _dateController = TextEditingController(text: '14 August 2026');
  final _startTimeController = TextEditingController(text: '10:00 AM');
  final _endTimeController = TextEditingController(text: '11:00 AM');
  final _platformController = TextEditingController(text: 'Google Meet');
  final _meetingUrlController = TextEditingController(text: 'https://meet.google.com/sec-ds-class');
  final _descriptionController = TextEditingController(text: 'Graph Theory & Shortest Path Algorithms');

  bool _isCreating = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _classController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _platformController.dispose();
    _meetingUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitClass() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
    });

    await MockOnlineClassService().createOnlineClass(
      teacherId: 'SEC-TCH-001',
      subject: _subjectController.text.trim(),
      className: _classController.text.trim(),
      date: _dateController.text.trim(),
      startTime: _startTimeController.text.trim(),
      endTime: _endTimeController.text.trim(),
      platform: _platformController.text.trim(),
      meetingUrl: _meetingUrlController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Online Class Created Successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Create Online Class'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Subject', _subjectController, Icons.book_rounded),
                const SizedBox(height: 14),
                _buildTextField('Class / Section', _classController, Icons.class_rounded),
                const SizedBox(height: 14),
                _buildTextField('Date', _dateController, Icons.calendar_today_rounded),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Start Time', _startTimeController, Icons.access_time_rounded)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('End Time', _endTimeController, Icons.access_time_filled_rounded)),
                  ],
                ),
                const SizedBox(height: 14),
                _buildTextField('Platform', _platformController, Icons.video_camera_front_rounded),
                const SizedBox(height: 14),
                _buildTextField('Meeting Link', _meetingUrlController, Icons.link_rounded),
                const SizedBox(height: 14),
                _buildTextField('Description / Topics', _descriptionController, Icons.description_rounded, maxLines: 3),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : _submitClass,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
                          )
                        : const Text(
                            'CREATE CLASS',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1.0,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (val) => val == null || val.trim().isEmpty ? 'Please enter $label' : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryPurple, size: 20),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
            ),
          ),
        ),
      ],
    );
  }
}
