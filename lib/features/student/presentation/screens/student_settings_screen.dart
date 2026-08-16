import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../services/mock_document_request_service.dart';
import '../../../../services/session_manager.dart';
import 'student_profile_screen.dart';

class StudentSettingsScreen extends StatefulWidget {
  const StudentSettingsScreen({super.key});

  @override
  State<StudentSettingsScreen> createState() => _StudentSettingsScreenState();
}

class _StudentSettingsScreenState extends State<StudentSettingsScreen> {
  final MockDocumentRequestService _docService = MockDocumentRequestService();
  bool _examReminders = true;
  bool _circularNotifications = true;
  bool _biometricLogin = false;

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.lock_reset_rounded, color: AppColors.primaryPurple),
              SizedBox(width: 8),
              Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter your current password and set a new password for your student account.',
                    style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: const Icon(Icons.key_rounded, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter new password';
                      }
                      if (val.trim().length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      prefixIcon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    validator: (val) {
                      if (val != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Password updated successfully! Please re-login if prompted.'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('UPDATE PASSWORD', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showUploadDialog(BuildContext context, DocumentRequestModel req) {
    final fileNameController = TextEditingController(
      text: '${req.id.toLowerCase().replaceAll('-', '_')}_scan.pdf',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              const Icon(Icons.upload_file_rounded, color: AppColors.primaryPurple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Upload: ${req.title}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Requested by: ${req.requestedBy}',
                style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                req.instructions,
                style: const TextStyle(fontSize: 12, color: AppColors.darkText),
              ),
              const SizedBox(height: 14),
              const Text(
                'Selected Document File:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: fileNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.insert_drive_file_rounded, color: AppColors.gold),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final fileName = fileNameController.text.trim();
                if (fileName.isNotEmpty) {
                  setState(() {
                    _docService.submitDocument(requestId: req.id, fileName: fileName);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✓ Document "$fileName" submitted successfully to faculty!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.cloud_upload_rounded, color: AppColors.white, size: 18),
              label: const Text('SUBMIT DOCUMENT', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDocumentRequestsModal(BuildContext context) {
    final requestedDocs = _docService.getRequestsForStudent('SEC-STD-001');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Icon(Icons.assignment_turned_in_outlined, color: AppColors.primaryPurple),
                      SizedBox(width: 8),
                      Text(
                        'Teacher Document Requests',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Upload files explicitly requested by your faculty. Unrequested uploads are restricted.',
                    style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: requestedDocs.isEmpty
                        ? const Center(
                            child: Text(
                              'No pending document requests from faculty.',
                              style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
                            ),
                          )
                        : ListView.builder(
                            itemCount: requestedDocs.length,
                            itemBuilder: (context, index) {
                              final req = requestedDocs[index];
                              final isSubmitted = req.status == 'Submitted';
                              final isRequested = req.status == 'Requested';

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: isSubmitted ? Colors.green.withValues(alpha: 0.3) : AppColors.primaryPurple.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              req.title,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryPurple,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: isSubmitted
                                                  ? Colors.green.withValues(alpha: 0.12)
                                                  : Colors.orange.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: isSubmitted ? Colors.green : Colors.orange,
                                              ),
                                            ),
                                            child: Text(
                                              req.status.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                color: isSubmitted ? Colors.green : Colors.orange.shade900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Requested By: ${req.requestedBy} • ${req.requestedDate}',
                                        style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        req.instructions,
                                        style: const TextStyle(fontSize: 12, color: AppColors.darkText),
                                      ),
                                      const SizedBox(height: 10),
                                      if (isRequested)
                                        SizedBox(
                                          width: double.infinity,
                                          height: 36,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              _showUploadDialog(context, req);
                                              setModalState(() {});
                                            },
                                            icon: const Icon(Icons.upload_file_rounded, size: 16, color: AppColors.primaryPurple),
                                            label: const Text(
                                              'Upload Document',
                                              style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.gold,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                          ),
                                        )
                                      else if (isSubmitted)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Submitted file: ${req.uploadedFileName ?? "document.pdf"} (${req.uploadedDate ?? "Today"})',
                                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                                              ),
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.settings_suggest_rounded, color: AppColors.gold, size: 26),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STUDENT ACCOUNT SETTINGS',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'System Preferences & Security',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SECTION 1: ACCOUNT & DOCUMENT ACTIONS
          const Text(
            'ACCOUNT SERVICES & DOCUMENTS',
            style: TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),

          // Upload Documents Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
            ),
            child: ListTile(
              onTap: () => _showDocumentRequestsModal(context),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.upload_file_rounded, color: AppColors.primaryPurple, size: 22),
              ),
              title: const Text(
                'Upload Documents',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkText),
              ),
              subtitle: const Text(
                'View & submit document requests issued by faculty',
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gold),
                ),
                child: const Text(
                  '1 PENDING',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Change Password Card
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
            ),
            child: ListTile(
              onTap: () => _showChangePasswordDialog(context),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_reset_rounded, color: AppColors.primaryPurple, size: 22),
              ),
              title: const Text(
                'Change Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkText),
              ),
              subtitle: const Text(
                'Update account password securely',
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
            ),
          ),
          const SizedBox(height: 10),

          // View Personal Profile Tile
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentProfileScreen()),
                );
              },
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_outline_rounded, color: AppColors.primaryPurple, size: 22),
              ),
              title: const Text(
                'View Personal Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkText),
              ),
              subtitle: const Text(
                'View registered student personal & academic details',
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
            ),
          ),
          const SizedBox(height: 20),

          // SECTION 2: APPLICATION PREFERENCES & SECURITY
          const Text(
            'PREFERENCES & SECURITY',
            style: TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),

          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Exam Schedule Alerts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Receive notifications for upcoming CIA & semester exams', style: TextStyle(fontSize: 11)),
                  value: _examReminders,
                  activeTrackColor: AppColors.primaryPurple,
                  onChanged: (val) => setState(() => _examReminders = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Campus Circular Notifications', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Notify when new circulars are published', style: TextStyle(fontSize: 11)),
                  value: _circularNotifications,
                  activeTrackColor: AppColors.primaryPurple,
                  onChanged: (val) => setState(() => _circularNotifications = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Biometric Quick Authentication', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Use fingerprint/face lock for app sign-in', style: TextStyle(fontSize: 11)),
                  value: _biometricLogin,
                  activeTrackColor: AppColors.primaryPurple,
                  onChanged: (val) => setState(() => _biometricLogin = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // LOGOUT BUTTON
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                SessionManager().clearSession();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.loginSelection,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.white, size: 18),
              label: const Text(
                'LOGOUT FROM STUDENT',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
