import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../services/session_manager.dart';
import 'parent_fee_payment_screen.dart';

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  bool _feeAlerts = true;
  bool _examAlerts = true;
  bool _ptmNotifications = true;

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
                    'Enter your current password and set a new password for your parent account.',
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
                        'PARENT ACCOUNT SETTINGS',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Fee Payments & Account Security',
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

          // SECTION 1: PARENT ACTIONS & FEE PAYMENT
          const Text(
            'PARENT ACTIONS & FEE PAYMENTS',
            style: TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),

          // Fee Payment Action Card
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
                  MaterialPageRoute(builder: (context) => const ParentFeePaymentScreen()),
                );
              },
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primaryPurple, size: 22),
              ),
              title: const Text(
                'Pay Child Fees',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkText),
              ),
              subtitle: const Text(
                'View fee breakdown, pay pending balance, & receipts',
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'PAY ₹15,000',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
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
                'Update parent account password securely',
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
            ),
          ),
          const SizedBox(height: 20),

          // SECTION 2: PARENT NOTIFICATION PREFERENCES
          const Text(
            'NOTIFICATION PREFERENCES',
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
                  title: const Text('Fee Payment Reminders', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Receive alerts when fee due date approaches', style: TextStyle(fontSize: 11)),
                  value: _feeAlerts,
                  activeTrackColor: AppColors.primaryPurple,
                  onChanged: (val) => setState(() => _feeAlerts = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Child Exam Schedule Alerts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Notify when CIA & semester exam dates are released', style: TextStyle(fontSize: 11)),
                  value: _examAlerts,
                  activeTrackColor: AppColors.primaryPurple,
                  onChanged: (val) => setState(() => _examAlerts = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Parent – Teacher Meeting Alerts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Notify when academic meet is scheduled', style: TextStyle(fontSize: 11)),
                  value: _ptmNotifications,
                  activeTrackColor: AppColors.primaryPurple,
                  onChanged: (val) => setState(() => _ptmNotifications = val),
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
                'LOGOUT FROM PARENT',
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
