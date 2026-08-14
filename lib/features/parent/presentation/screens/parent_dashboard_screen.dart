import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../models/fee_payment.dart';
import '../../../../models/student.dart';
import '../../../../services/mock_fee_service.dart';
import '../../../../services/mock_student_service.dart';
import '../../../../services/session_manager.dart';
import '../widgets/child_card.dart';
import '../widgets/parent_stat_card.dart';
import 'parent_academic_performance_screen.dart';
import 'parent_assignments_screen.dart';
import 'parent_attendance_screen.dart';
import 'parent_fee_payment_screen.dart';
import 'parent_notifications_screen.dart';
import 'parent_profile_screen.dart';
import 'parent_semester_results_screen.dart';
import 'parent_teacher_meetings_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _currentIndex = 0;
  late StudentModel _selectedChild;
  List<StudentModel> _myChildren = [];
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
        _myChildren = [demoChild];
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

    final List<Widget> pages = [
      _buildHomeTab(),
      const ParentAttendanceScreen(),
      const ParentSemesterResultsScreen(),
      const ParentNotificationsScreen(),
    ];

    final safeIndex = _currentIndex >= pages.length ? 0 : _currentIndex;

    return PopScope(
      canPop: safeIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (safeIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Parent Portal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Smart SEC Parent Portal',
                style: TextStyle(fontSize: 11, color: AppColors.gold),
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
                ).then((_) => setState(() {}));
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
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
        body: pages[safeIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: safeIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: AppColors.primaryPurple,
            unselectedItemColor: AppColors.secondaryText,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            elevation: 8,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline_rounded),
                label: 'ATTENDANCE',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grade_rounded),
                label: 'RESULTS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.campaign_rounded),
                label: 'NOTICE',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Parent Identity Banner (Smart SEC Primary Purple Theme)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryPurple,
                    AppColors.primaryPurple.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    child: const Icon(
                      Icons.family_restroom_outlined,
                      color: AppColors.gold,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Welcome, Mr. Kumar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Demo Account',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Stay connected with your child's academic progress",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Section 1: My Children
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Children',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
                if (_myChildren.length > 1)
                  DropdownButton<String>(
                    value: _selectedChild.id,
                    underline: const SizedBox(),
                    hint: const Text('Select Child', style: TextStyle(fontSize: 12)),
                    items: _myChildren.map((child) {
                      return DropdownMenuItem<String>(
                        value: child.id,
                        child: Text(child.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedChild = _myChildren.firstWhere((c) => c.id == val);
                        });
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (_isLoading)
              const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: AppColors.primaryPurple)))
            else
              ChildCard(student: _selectedChild),

            const SizedBox(height: 20),

            // Section 2: Student Fee Payment Card (Section 22)
            _buildFeePaymentSummaryCard(),

            // Section 3: Summary Dashboard Cards (VIEW ONLY)
            const Text(
              'Academic Overview',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                ParentStatCard(
                  title: 'ATTENDANCE',
                  value: '87%',
                  subtitle: 'Good Standing',
                  icon: Icons.check_circle_outline_rounded,
                  color: Colors.green.shade700,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentAttendanceScreen()));
                  },
                ),
                ParentStatCard(
                  title: 'CIA PERFORMANCE',
                  value: '82%',
                  subtitle: 'Avg CIA 1–3',
                  icon: Icons.analytics_outlined,
                  color: AppColors.primaryPurple,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentAcademicPerformanceScreen()));
                  },
                ),
                ParentStatCard(
                  title: 'SEMESTER RESULT',
                  value: '8.4 CGPA',
                  subtitle: 'Semester VI (Pass)',
                  icon: Icons.grade_rounded,
                  color: AppColors.gold,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentSemesterResultsScreen()));
                  },
                ),
                ParentStatCard(
                  title: 'ASSIGNMENTS',
                  value: '3 Pending',
                  subtitle: 'Data Structures 03',
                  icon: Icons.assignment_rounded,
                  color: Colors.orange.shade800,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentAssignmentsScreen()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section 4: Quick Features Grid
            const Text(
              'Quick Features',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 12),

            _buildQuickActionTile(
              icon: Icons.payments_rounded,
              title: 'Student Fee Payment',
              subtitle: 'View fee details, status & pay pending balance',
              color: Colors.green.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentFeePaymentScreen(),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
            _buildQuickActionTile(
              icon: Icons.event_available_rounded,
              title: 'Parent–Teacher Meeting',
              subtitle: 'Book or view meeting requests with subject teachers',
              color: AppColors.primaryPurple,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentTeacherMeetingsScreen()));
              },
            ),
            _buildQuickActionTile(
              icon: Icons.analytics_outlined,
              title: 'CIA Internal Marks',
              subtitle: 'View detailed CIA 1, CIA 2 & CIA 3 test scores',
              color: AppColors.primaryPurple,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentAcademicPerformanceScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- STUDENT FEE PAYMENT SUMMARY CARD (SECTION 22) ---
  Widget _buildFeePaymentSummaryCard() {
    final feeRecord = MockFeeService().getFeeRecord('STU001');
    final isPending = feeRecord.pendingAmount > 0;
    final formattedDueDate =
        '${feeRecord.dueDate.day} ${_monthName(feeRecord.dueDate.month)} ${feeRecord.dueDate.year}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPending
              ? Colors.orange.shade300
              : AppColors.primaryPurple.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: isPending
                ? Colors.orange.withValues(alpha: 0.08)
                : AppColors.primaryPurple.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isPending ? Colors.orange.shade50 : Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.payment_rounded,
                      color: isPending ? Colors.orange.shade900 : Colors.green.shade700,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'STUDENT FEE PAYMENT',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryPurple,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPending ? Colors.orange.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isPending ? Colors.orange.shade300 : Colors.green.shade300,
                  ),
                ),
                child: Text(
                  feeRecord.status.displayName,
                  style: TextStyle(
                    color: isPending ? Colors.orange.shade900 : Colors.green.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Pending Amount',
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹${feeRecord.pendingAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: isPending ? Colors.orange.shade900 : Colors.green.shade700,
                ),
              ),
              Text(
                'Due Date: $formattedDueDate',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Interactive Action Button ONLY (Card itself is not fully clickable)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParentFeePaymentScreen(),
                  ),
                ).then((_) => setState(() {}));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isPending ? AppColors.primaryPurple : Colors.green.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                isPending
                    ? 'PAY PENDING FEES (₹${feeRecord.pendingAmount.toStringAsFixed(0)})'
                    : 'VIEW FEE RECEIPT & HISTORY',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }



  Widget _buildQuickActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryPurple),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.secondaryText),
        ),
      ),
    );
  }
}
