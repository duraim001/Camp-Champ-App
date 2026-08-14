import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_admin_service.dart';
import '../../../../services/session_manager.dart';
import 'access_control_screen.dart';
import 'admin_profile_screen.dart';
import 'announcements_screen.dart';
import 'attendance_management_screen.dart';
import 'department_details_screen.dart';
import 'department_management_screen.dart';
import 'parent_management_screen.dart';
import 'student_management_screen.dart';
import 'teacher_management_screen.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/management_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardHome(context),
      _buildManagementOverview(context),
      const AttendanceManagementScreen(),
      const AnnouncementsScreen(),
    ];

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
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryPurple,
          unselectedItemColor: AppColors.secondaryText,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Management',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fact_check_outlined),
              activeIcon: Icon(Icons.fact_check),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              activeIcon: Icon(Icons.campaign),
              label: 'Notice',
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: DASHBOARD OVERVIEW HOME ---
  Widget _buildDashboardHome(BuildContext context) {
    final admin =
        MockAdminService().getAdminProfile(SessionManager().currentUserId);
    final departments = MockAdminService().getDepartments();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Dashboard',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white),
            ),
            Text(
              'Smart SEC Administration Center',
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new administrative alerts.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SYSTEM CONTROL CENTER IDENTITY BANNER (Sitting directly below header)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryPurple,
                      AppColors.secondaryPurple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.gold,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/college_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'SYSTEM CONTROL CENTER',
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: AppColors.gold,
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Sengunthar Engineering College',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Full Campus Administration Rights Enabled',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content Padding Container
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. LOGGED-IN ADMINISTRATOR IDENTITY SECTION (Normal & Unique, Non-button)
                    const Text(
                      'LOGGED-IN ADMINISTRATOR',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.gold.withValues(alpha: 0.4),
                              ),
                            ),
                            child: const Icon(
                              Icons.person_pin_rounded,
                              color: AppColors.primaryPurple,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  admin.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  admin.designation,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Active',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. STATS OVERVIEW SECTION
                    const Text(
                      'CAMPUS OVERVIEW',
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
                        childAspectRatio: 2.2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      children: [
                        AdminStatCard(
                          title: 'TOTAL STUDENTS',
                          value: '2,450',
                          icon: Icons.school_outlined,
                          accentColor: AppColors.primaryPurple,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const StudentManagementScreen())),
                        ),
                        AdminStatCard(
                          title: 'TOTAL TEACHERS',
                          value: '145',
                          icon: Icons.badge_outlined,
                          accentColor: AppColors.secondaryPurple,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TeacherManagementScreen())),
                        ),
                        AdminStatCard(
                          title: 'TOTAL PARENTS',
                          value: '2,100',
                          icon: Icons.family_restroom_outlined,
                          accentColor: const Color(0xFFD97706),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ParentManagementScreen())),
                        ),
                        AdminStatCard(
                          title: 'DEPARTMENTS',
                          value: '8',
                          icon: Icons.account_balance_outlined,
                          accentColor: Colors.blueAccent,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DepartmentManagementScreen())),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 4. ATTENDANCE OVERVIEW CARD
                    const Text(
                      'ATTENDANCE OVERVIEW',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryPurple.withValues(alpha: 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('Student Attendance',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.secondaryText,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(
                                            value: 0.87,
                                            backgroundColor: AppColors.lightBackground,
                                            color: AppColors.primaryPurple,
                                            strokeWidth: 6,
                                          ),
                                        ),
                                        const Text('87%',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: AppColors.primaryPurple)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    const Text('Present: 2,180 | Absent: 270',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.darkText)),
                                  ],
                                ),
                              ),
                              Container(
                                  height: 60,
                                  width: 1,
                                  color:
                                      AppColors.secondaryText.withValues(alpha: 0.2)),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('Teacher Attendance',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.secondaryText,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(
                                            value: 0.92,
                                            backgroundColor: AppColors.lightBackground,
                                            color: AppColors.gold,
                                            strokeWidth: 6,
                                          ),
                                        ),
                                        const Text('92%',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: AppColors.primaryPurple)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    const Text('Present: 133 | Absent: 12',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.darkText)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex = 2; // Navigate to Attendance tab
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.primaryPurple, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('View Detailed Attendance',
                                  style: TextStyle(
                                      color: AppColors.primaryPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 5. DEPARTMENT OVERVIEW (Simple & clean department summary)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'DEPARTMENT OVERVIEW',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DepartmentManagementScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.tune, size: 14, color: AppColors.primaryPurple),
                          label: const Text(
                            'Manage',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: departments.length,
                      itemBuilder: (context, index) {
                        final dept = departments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: AppColors.primaryPurple.withValues(alpha: 0.12),
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DepartmentDetailsScreen(department: dept),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                children: [
                                  // Department Icon Container
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPurple.withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.gold.withValues(alpha: 0.5),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_outlined,
                                      color: AppColors.primaryPurple,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Department Name & Strengths
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                dept.name,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primaryPurple,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 7, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.gold.withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                dept.code,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.primaryPurple,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.school_outlined,
                                              size: 13,
                                              color: AppColors.secondaryText,
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'Students: ',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                            Text(
                                              '${dept.studentCount}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.darkText,
                                              ),
                                            ),
                                            const SizedBox(width: 18),
                                            const Icon(
                                              Icons.badge_outlined,
                                              size: 13,
                                              color: AppColors.secondaryText,
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'Teachers: ',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                            Text(
                                              '${dept.teacherCount}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.darkText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: AppColors.secondaryText.withValues(alpha: 0.6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TAB 2: MANAGEMENT QUICK ACCESS ---
  Widget _buildManagementOverview(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Management Center'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ManagementCard(
              title: 'Student Management',
              description: 'View 2,450 registered students',
              icon: Icons.school_outlined,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StudentManagementScreen())),
            ),
            const SizedBox(height: 12),
            ManagementCard(
              title: 'Teacher Management',
              description: 'View 145 faculty members',
              icon: Icons.badge_outlined,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TeacherManagementScreen())),
            ),
            const SizedBox(height: 12),
            ManagementCard(
              title: 'Parent Management',
              description: 'View 2,100 parent contacts',
              icon: Icons.family_restroom_outlined,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ParentManagementScreen())),
            ),
            const SizedBox(height: 12),
            ManagementCard(
              title: 'Department Management',
              description: 'Manage 8 college departments',
              icon: Icons.account_balance_outlined,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const DepartmentManagementScreen())),
            ),
            const SizedBox(height: 12),
            ManagementCard(
              title: 'Access Control',
              description: 'Manage role permission toggles',
              icon: Icons.security_rounded,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccessControlScreen())),
            ),
            const SizedBox(height: 12),
            ManagementCard(
              title: 'Announcements',
              description: 'Post updates for campus',
              icon: Icons.campaign_outlined,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnnouncementsScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
