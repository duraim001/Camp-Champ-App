import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/faculty_request_service.dart';

class FacultyRegistrationScreen extends StatefulWidget {
  const FacultyRegistrationScreen({super.key});

  @override
  State<FacultyRegistrationScreen> createState() => _FacultyRegistrationScreenState();
}

class _FacultyRegistrationScreenState extends State<FacultyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _degreeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedDepartment = 'Artificial Intelligence and Data Science';
  String _selectedDesignation = 'Assistant Professor';

  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool _isSubmitting = false;

  final List<String> _departments = [
    'Artificial Intelligence and Data Science',
    'Computer Science & Engineering',
    'Information Technology',
    'Electronics & Comm. Engg.',
    'Electrical & Elec. Engg.',
    'Mechanical Engineering',
    'Civil Engineering',
  ];

  final List<String> _designations = [
    'Assistant Professor',
    'Associate Professor',
    'Professor',
    'HOD',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employeeIdController.dispose();
    _degreeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitFacultyRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final result = await FacultyRequestService().submitRequest(
      fullName: _fullNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      employeeId: _employeeIdController.text,
      department: _selectedDepartment,
      designation: _selectedDesignation,
      degree: _degreeController.text.trim().isNotEmpty ? _degreeController.text.trim() : 'M.Tech',
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (result['success'] == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text(
                'Request Submitted',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your faculty account request has been submitted successfully.\n\nYour account is now PENDING and waiting for Admin approval before you can log in.',
            style: TextStyle(color: AppColors.darkText, fontSize: 13, height: 1.4),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(); // Return to Teacher Login Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      );
    } else {
      final errorMsg = result['error'] ?? 'Failed to submit registration request.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Create Faculty Account'),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.gold),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.how_to_reg_rounded, color: AppColors.primaryPurple, size: 36),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Faculty Account Request',
                              style: TextStyle(
                                color: AppColors.primaryPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Fill in your details. Account requires Admin approval before access is granted.',
                              style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- SECTION 1: PERSONAL INFORMATION ---
                _buildSectionHeader('Personal Information', Icons.person_outline),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  hint: 'Dr. / Prof. Full Name',
                  icon: Icons.badge_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your full name' : null,
                ),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'faculty@sengunthar.ac.in',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter email address';
                    if (!val.contains('@') || !val.contains('.')) return 'Please enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: '10-digit mobile number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter phone number';
                    final digitsOnly = val.replaceAll(RegExp(r'\D'), '');
                    if (digitsOnly.length < 10) return 'Please enter valid 10-digit phone number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // --- SECTION 2: PROFESSIONAL INFORMATION ---
                _buildSectionHeader('Professional Information', Icons.work_outline),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: _employeeIdController,
                  label: 'Employee ID / Faculty ID',
                  hint: 'e.g. SEC-AIDS-01',
                  icon: Icons.card_membership_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter employee ID' : null,
                ),
                const SizedBox(height: 12),

                // Department Dropdown
                const Text(
                  'Department',
                  style: TextStyle(color: AppColors.primaryPurple, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDepartment,
                  decoration: _inputDecoration(Icons.domain_outlined),
                  isExpanded: true,
                  items: _departments.map((dept) => DropdownMenuItem(
                    value: dept,
                    child: Text(dept, style: const TextStyle(fontSize: 13)),
                  )).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDepartment = val);
                  },
                ),
                const SizedBox(height: 12),

                // Designation Dropdown
                const Text(
                  'Designation',
                  style: TextStyle(color: AppColors.primaryPurple, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDesignation,
                  isExpanded: true,
                  decoration: _inputDecoration(Icons.workspace_premium_outlined),
                  items: _designations.map((desig) => DropdownMenuItem(
                    value: desig,
                    child: Text(desig, style: const TextStyle(fontSize: 13)),
                  )).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDesignation = val);
                  },
                ),
                const SizedBox(height: 12),

                // Degree / Qualification Input
                _buildTextField(
                  controller: _degreeController,
                  label: 'Degree / Qualification',
                  hint: 'e.g. M.Tech, Ph.D., MCA, M.Sc., B.E., MBA',
                  icon: Icons.school_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter degree / qualification' : null,
                ),
                const SizedBox(height: 24),

                // --- SECTION 3: LOGIN INFORMATION ---
                _buildSectionHeader('Login Credentials', Icons.lock_outline),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'Choose a unique username',
                  icon: Icons.account_circle_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please choose a username' : null,
                ),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Minimum 6 characters',
                  icon: Icons.lock_clock_outlined,
                  obscureText: _isObscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_isObscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.secondaryText),
                    onPressed: () => setState(() => _isObscurePassword = !_isObscurePassword),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter password';
                    if (val.trim().length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  icon: Icons.lock_reset_outlined,
                  obscureText: _isObscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_isObscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: AppColors.secondaryText),
                    onPressed: () => setState(() => _isObscureConfirmPassword = !_isObscureConfirmPassword),
                  ),
                  validator: (val) {
                    if (val != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitFacultyRegistration,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded, color: AppColors.white),
                    label: Text(
                      _isSubmitting ? 'SUBMITTING REQUEST...' : 'REQUEST FACULTY ACCOUNT',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AppColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.gold, width: 1.5),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryPurple, size: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider(color: AppColors.gold, thickness: 1)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.primaryPurple, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: _inputDecoration(icon, hint: hint, suffixIcon: suffixIcon),
          validator: validator,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(IconData prefixIcon, {String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.secondaryText.withValues(alpha: 0.6), fontSize: 13),
      prefixIcon: Icon(prefixIcon, color: AppColors.primaryPurple, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.gold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
