import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _emailNotifications = true;
  bool _smsAlerts = true;
  bool _twoFactorAuth = true;
  bool _maintenanceMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.settings_rounded, color: AppColors.gold, size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin Portal Settings',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'System Configurations, Security & Preferences',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // System Preferences Group
              _buildSectionTitle('System Preferences'),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      activeTrackColor: AppColors.primaryPurple,
                      title: const Text('Email Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Send automatic administrative email digests', style: TextStyle(fontSize: 12)),
                      value: _emailNotifications,
                      onChanged: (val) => setState(() => _emailNotifications = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      activeTrackColor: AppColors.primaryPurple,
                      title: const Text('Automated SMS Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Send SMS notifications to parents for student absences', style: TextStyle(fontSize: 12)),
                      value: _smsAlerts,
                      onChanged: (val) => setState(() => _smsAlerts = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      activeTrackColor: AppColors.primaryPurple,
                      title: const Text('Maintenance Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Restrict student portal access during system maintenance', style: TextStyle(fontSize: 12)),
                      value: _maintenanceMode,
                      onChanged: (val) => setState(() => _maintenanceMode = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Security & Authentication
              _buildSectionTitle('Security & Authentication'),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      activeTrackColor: AppColors.primaryPurple,
                      title: const Text('Two-Factor Authentication (2FA)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Require OTP verification on Admin login', style: TextStyle(fontSize: 12)),
                      value: _twoFactorAuth,
                      onChanged: (val) => setState(() => _twoFactorAuth = val),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.lock_reset_rounded, color: AppColors.primaryPurple),
                      title: const Text('Change Admin Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Update security password for Principal Account', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password update modal triggered')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // System Information
              _buildSectionTitle('Application & Database Info'),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
                ),
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.info_outline_rounded, color: AppColors.primaryPurple),
                      title: Text('Application Version', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('Camp Champ v2.4.0 (Build 2026.08)', style: TextStyle(fontSize: 12)),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.storage_rounded, color: AppColors.primaryPurple),
                      title: Text('Database Connection Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('Connected to Sengunthar Central Campus Server (Latency: 12ms)', style: TextStyle(fontSize: 12, color: Colors.green)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryPurple,
      ),
    );
  }
}
