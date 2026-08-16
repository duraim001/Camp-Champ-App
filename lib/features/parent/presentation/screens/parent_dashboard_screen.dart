import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../models/student.dart';
import '../../../../services/mock_fee_service.dart';
import '../../../../services/mock_student_service.dart';
import '../../../../services/session_manager.dart';
import '../widgets/parent_stat_card.dart';
import 'parent_academic_performance_screen.dart';
import 'parent_attendance_screen.dart';
import 'parent_circular_screen.dart';
import 'parent_exams_screen.dart';
import 'parent_fee_payment_screen.dart';
import 'parent_grievance_screen.dart';
import 'parent_notifications_screen.dart';
import 'parent_profile_screen.dart';
import 'parent_semester_results_screen.dart';
import 'parent_settings_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _currentIndex = 0;
  late StudentModel _selectedChild;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChildrenData();
  }

  void _loadChildrenData() async {
    final demoChild = MockStudentService().getDemoStudentProfile();
    if (mounted) {
      setState(() {
        _selectedChild = demoChild;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Role Authorization Guard
    if (!SessionManager().canAccessParentRoutes()) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gpp_maybe_rounded, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Access Denied',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Your account does not have permission to access this section.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginSelection, (r) => false);
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryPurple)),
      );
    }

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        drawer: _buildParentDrawer(context),
        body: _buildPage(_currentIndex),
      ),
    );
  }

  // --- PAGE ROUTER FOR 5 PARENT SECTIONS ---
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildHomeDashboard(context);
      case 1:
        return _buildHeaderWrapper(
          title: 'Campus Circulars & Notices',
          subtitle: 'Holidays, Reminders & Functions',
          child: const ParentCircularScreen(),
        );
      case 2:
        return _buildHeaderWrapper(
          title: 'Child Exam Schedule & Results',
          subtitle: 'Completed Exams, Next Exam & Timetable',
          child: const ParentExamsScreen(),
        );
      case 3:
        return _buildHeaderWrapper(
          title: 'Grievance & AI Prediction',
          subtitle: 'Requests & Performance Analysis',
          child: const ParentGrievanceScreen(),
        );
      case 4:
        return _buildHeaderWrapper(
          title: 'Parent Account & Settings',
          subtitle: 'Fee Payment, Password & Logout',
          child: const ParentSettingsScreen(),
        );
      default:
        return _buildHomeDashboard(context);
    }
  }

  // --- HEADER WRAPPER FOR SECONDARY PARENT SECTIONS ---
  Widget _buildHeaderWrapper({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildParentDrawer(context),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.gold, size: 26),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sathishkumar',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              'Parent • Child: ${_selectedChild.name}',
              style: const TextStyle(fontSize: 10, color: AppColors.gold),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.gold),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParentNotificationsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParentProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: child,
    );
  }

  // --- PARENT HAMBURGER MENU DRAWER (EXACT 5 SECTIONS) ---
  Widget _buildParentDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          // Parent Profile Drawer Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 2),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Image.asset(
                    'assets/images/college_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.family_restroom_rounded,
                      size: 38,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ),
            ),
            accountName: const Text(
              'Sathishkumar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
            accountEmail: Text(
              'Parent of ${_selectedChild.name} • ${_selectedChild.department}',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Menu Category Subtitle Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primaryPurple.withValues(alpha: 0.06),
            child: const Row(
              children: [
                Icon(Icons.menu_open_rounded, color: AppColors.primaryPurple, size: 18),
                SizedBox(width: 8),
                Text(
                  'PARENT MENU',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryPurple,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Exactly 5 Ordered Navigation Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                _buildDrawerTile(0, 'Dashboard', Icons.dashboard_rounded),
                _buildDrawerTile(1, 'Circular', Icons.campaign_rounded),
                _buildDrawerTile(2, 'Exams', Icons.assignment_turned_in_rounded),
                _buildDrawerTile(3, 'Student Grievance', Icons.report_problem_rounded),
                _buildDrawerTile(4, 'Settings', Icons.settings_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(int index, String title, IconData icon) {
    final isSelected = _currentIndex == index;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primaryPurple : AppColors.secondaryText,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: isSelected ? AppColors.primaryPurple : AppColors.darkText,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primaryPurple.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        Navigator.pop(context); // Close drawer
      },
    );
  }

  // --- SECTION 0: PARENT DASHBOARD HOME OVERVIEW ---
  Widget _buildHomeDashboard(BuildContext context) {
    final feeStatus = MockFeeService().getFeeRecord(_selectedChild.id);
    final bool hasPending = feeStatus.pendingAmount > 0;
    final String formattedPending = '₹${feeStatus.pendingAmount.toInt()}';
    final String formattedTotal = '₹${feeStatus.totalFees.toInt()}';
    final String formattedPaid = '₹${feeStatus.paidAmount.toInt()}';

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildParentDrawer(context),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.gold, size: 26),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sathishkumar',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              'Parent • Child: ${_selectedChild.name}',
              style: const TextStyle(fontSize: 10, color: AppColors.gold),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.gold),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParentNotificationsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParentProfileScreen(),
                ),
              );
            },
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
              // 1. CHILD INFORMATION CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.secondaryPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.white.withValues(alpha: 0.15),
                      child: const Icon(Icons.school_rounded, color: AppColors.gold, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STUDENT: ${_selectedChild.name.toUpperCase()}',
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Reg: ${_selectedChild.registerNumber} • ${_selectedChild.department}',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_selectedChild.year} (Sec ${_selectedChild.section}) • Semester ${_selectedChild.semester}',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. FEE OVERVIEW CARD
              const Text(
                'FEE PAYMENT STATUS',
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
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: hasPending
                        ? Colors.red.withValues(alpha: 0.3)
                        : Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pending Tuition Balance',
                                  style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                              const SizedBox(height: 2),
                              Text(
                                formattedPending,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: hasPending ? Colors.red.shade900 : Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: hasPending
                                  ? Colors.red.withValues(alpha: 0.12)
                                  : Colors.green.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              hasPending ? 'PAYMENT DUE' : 'FULLY PAID',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: hasPending ? Colors.red.shade900 : Colors.green.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total: $formattedTotal',
                              style: const TextStyle(fontSize: 11, color: AppColors.darkText)),
                          Text('Paid: $formattedPaid',
                              style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                          const Text('Due: 30 Sep 2026',
                              style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                        ],
                      ),
                      if (hasPending) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ParentFeePaymentScreen(),
                                ),
                              ).then((_) => setState(() {}));
                            },
                            icon: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primaryPurple, size: 18),
                            label: Text(
                              'PAY PENDING FEES ($formattedPending)',
                              style: const TextStyle(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. ACADEMIC & EXAM METRICS OVERVIEW
              const Text(
                'CHILD ACADEMIC METRICS',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),

              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ParentAttendanceScreen())),
                    child: const ParentStatCard(
                      title: 'ATTENDANCE',
                      value: '87%',
                      subtitle: 'Above 75% Cutoff',
                      icon: Icons.pie_chart_outline,
                      color: Colors.green,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ParentAcademicPerformanceScreen())),
                    child: const ParentStatCard(
                      title: 'CIA MARKS',
                      value: '82%',
                      subtitle: 'CIA 1, 2, 3 Average',
                      icon: Icons.analytics_outlined,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 2; // Switch to Exams tab
                      });
                    },
                    child: const ParentStatCard(
                      title: 'LAST EXAM',
                      value: '86 / 100',
                      subtitle: 'CIA 3 Data Structures',
                      icon: Icons.assignment_turned_in_outlined,
                      color: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ParentSemesterResultsScreen())),
                    child: const ParentStatCard(
                      title: 'SEMESTER',
                      value: 'Grade A',
                      subtitle: 'Passed All Subjects',
                      icon: Icons.workspace_premium_outlined,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 4. QUICK ACCESS ACTIONS
              const Text(
                'QUICK ACCESS',
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),

              _buildQuickActionTile(
                context,
                title: 'Attendance History',
                subtitle: "View subject-wise attendance for ${_selectedChild.name}",
                icon: Icons.fact_check_outlined,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ParentAttendanceScreen())),
              ),
              const SizedBox(height: 10),
              _buildQuickActionTile(
                context,
                title: 'CIA Internal Marks',
                subtitle: 'View CIA 1, CIA 2, & CIA 3 scores',
                icon: Icons.grade_outlined,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ParentAcademicPerformanceScreen())),
              ),
              const SizedBox(height: 10),
              _buildQuickActionTile(
                context,
                title: 'Exam Schedule & Timetable',
                subtitle: 'View completed exams & next upcoming exam',
                icon: Icons.event_note_outlined,
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildQuickActionTile(
                context,
                title: 'Grievance & AI Prediction',
                subtitle: "View child's requests & AI performance trend",
                icon: Icons.auto_awesome_outlined,
                onTap: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: 22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.secondaryText,
            size: 20,
          ),
        ),
      ),
    );
  }
}
