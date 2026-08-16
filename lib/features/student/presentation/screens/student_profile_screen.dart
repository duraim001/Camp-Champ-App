import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_student_service.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  // Mutable permitted personal details
  late String _email;
  late String _phone;
  late String _dob;
  late String _address;
  late String _parentName;
  late String _parentContact;
  late String _gender;

  @override
  void initState() {
    super.initState();
    final student = MockStudentService().getDemoStudentProfile();
    _email = student.email;
    _phone = student.phone;
    _dob = '14 May 2004';
    _address = '42, College Road, Tiruchengode, Tamil Nadu - 637211';
    _parentName = 'S. Kumar';
    _parentContact = '+91 94433 12345';
    _gender = 'Male';
  }

  void _showEditPersonalDetailsDialog() {
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);
    final dobController = TextEditingController(text: _dob);
    final addressController = TextEditingController(text: _address);
    final parentContactController = TextEditingController(text: _parentContact);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.edit_note_rounded, color: AppColors.primaryPurple),
              SizedBox(width: 8),
              Text(
                'Edit Personal Info',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Update permitted personal and contact details. Official academic fields remain read-only.',
                  style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Student Email',
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: const Icon(Icons.cake_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Residential Address',
                    prefixIcon: const Icon(Icons.home_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: parentContactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Parent Contact Number',
                    prefixIcon: const Icon(Icons.contact_phone_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _email = emailController.text.trim();
                  _phone = phoneController.text.trim();
                  _dob = dobController.text.trim();
                  _address = addressController.text.trim();
                  _parentContact = parentContactController.text.trim();
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✓ Personal contact details updated successfully!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('SAVE CHANGES', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = MockStudentService().getDemoStudentProfile();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Student Personal Profile'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.gold),
            tooltip: 'Edit Personal Details',
            onPressed: _showEditPersonalDetailsDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar & Name Card
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        border: Border.all(color: AppColors.gold, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      student.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gold),
                      ),
                      child: Text(
                        'Reg No: ${student.registerNumber}',
                        style: const TextStyle(
                          color: AppColors.primaryPurple,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // SECTION 1: ACADEMIC & INSTITUTIONAL INFO (READ-ONLY 🔒)
              Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.school_outlined, color: AppColors.primaryPurple, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'ACADEMIC RECORD',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryPurple,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.secondaryText),
                              SizedBox(width: 4),
                              Text(
                                'READ-ONLY',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.badge_outlined, 'Register Number', student.registerNumber, isReadOnly: true),
                      const Divider(height: 1),
                      _buildInfoRow(Icons.menu_book_outlined, 'Course & Dept', '${student.course} (${student.department})', isReadOnly: true),
                      const Divider(height: 1),
                      _buildInfoRow(Icons.calendar_today_outlined, 'Year & Section', '${student.year} (Sec ${student.section}) • Semester ${student.semester}', isReadOnly: true),
                      const Divider(height: 1),
                      _buildInfoRow(Icons.account_balance_outlined, 'College', student.college, isReadOnly: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // SECTION 2: PERSONAL & CONTACT INFORMATION (EDITABLE ✏️)
              Card(
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.person_pin_outlined, color: AppColors.primaryPurple, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'PERSONAL & CONTACT DETAILS',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryPurple,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: _showEditPersonalDetailsDialog,
                            child: const Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryPurple),
                                SizedBox(width: 4),
                                Text(
                                  'EDIT',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.email_outlined, 'Student Email', _email, isReadOnly: false),
                      const Divider(height: 1),
                      _buildInfoRow(Icons.phone_outlined, 'Phone Number', _phone, isReadOnly: false),
                      const Divider(height: 1),
                      _buildInfoRow(Icons.cake_outlined, 'Date of Birth', _dob, isReadOnly: false),
                      const Divider(height: 1),
                      _buildInfoRow(Icons.wc_outlined, 'Gender', _gender, isReadOnly: true),
                      const Divider(height: 1),
                      _buildInfoRow(Icons.home_outlined, 'Residential Address', _address, isReadOnly: false),
                      const Divider(height: 1),
                      _buildInfoRow(Icons.family_restroom_outlined, 'Parent / Guardian Name', _parentName, isReadOnly: true),
                      const Divider(height: 1),
                      _buildInfoRow(Icons.contact_phone_outlined, 'Parent / Guardian Contact', _parentContact, isReadOnly: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {required bool isReadOnly}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
          if (isReadOnly)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.secondaryText),
            )
          else
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryPurple),
            ),
        ],
      ),
    );
  }
}
