import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_admin_service.dart';
import '../../../../services/session_manager.dart';
import 'access_control_screen.dart';
import 'admin_academics_screen.dart';
import 'admin_exams_screen.dart';
import 'admin_grievance_screen.dart';
import 'admin_library_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_settings_screen.dart';
import 'announcements_screen.dart';
import 'attendance_management_screen.dart';
import 'department_details_screen.dart';
import 'department_management_screen.dart';
import 'parent_management_screen.dart';
import 'student_management_screen.dart';
import 'teacher_management_screen.dart';
import 'faculty_requests_screen.dart';
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
        drawer: _buildAdminDrawer(context),
        body: _buildPage(_currentIndex),
      ),
    );
  }

  // --- PAGE ROUTER FOR 10 ADMIN SECTIONS ---
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildDashboardHome(context);
      case 1:
        return _buildManagementOverview(context);
      case 2:
        return _buildHeaderWrapper(
          title: 'Attendance Management',
          subtitle: 'Student & Faculty Attendance Overview',
          child: const AttendanceManagementScreen(),
        );
      case 3:
        return _buildHeaderWrapper(
          title: 'Campus Circulars',
          subtitle: 'Official Directives & Announcements',
          child: const AnnouncementsScreen(),
        );
      case 4:
        return _buildHeaderWrapper(
          title: 'Library Portal',
          subtitle: 'Digital Catalog & Resource Management',
          child: const AdminLibraryScreen(),
        );
      case 5:
        return _buildHeaderWrapper(
          title: 'Academics Portal',
          subtitle: 'Degree Programs & Master Syllabus',
          child: const AdminAcademicsScreen(),
        );
      case 6:
        return _buildHeaderWrapper(
          title: 'Examinations',
          subtitle: 'CIA Tests & Semester Schedules',
          child: const AdminExamsScreen(),
        );
      case 7:
        return _buildHeaderWrapper(
          title: 'Student Grievance',
          subtitle: 'Feedback & Redressal Management',
          child: const AdminGrievanceScreen(),
        );
      case 8:
        return _buildHeaderWrapper(
          title: 'Admin Settings',
          subtitle: 'System Configurations & Preferences',
          child: const AdminSettingsScreen(),
        );
      default:
        return _buildDashboardHome(context);
    }
  }

  // --- WRAPPER FOR SECTIONS WITHOUT CUSTOM APPBAR ---
  Widget _buildHeaderWrapper({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildAdminDrawer(context),
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.gold),
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
                MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: child,
    );
  }

  // --- HAMBURGER MENU DRAWER (10 SECTIONS) ---
  Widget _buildAdminDrawer(BuildContext context) {
    final admin = MockAdminService().getAdminProfile(SessionManager().currentUserId);

    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          // Admin Profile & System Header
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
                      Icons.person_rounded,
                      size: 38,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ),
            ),
            accountName: Text(
              admin.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
            accountEmail: Text(
              '${admin.designation} • Camp Champ Admin',
              style: const TextStyle(
                fontSize: 12,
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
                  'ADMIN MENU',
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

          // Exactly 9 Ordered Navigation Options (Notice removed)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                _buildDrawerTile(0, 'Dashboard', Icons.dashboard_rounded),
                _buildDrawerTile(1, 'Management', Icons.people_alt_rounded),
                _buildDrawerTile(2, 'Attendance', Icons.fact_check_rounded),
                _buildDrawerTile(3, 'Circular', Icons.campaign_rounded),
                _buildDrawerTile(4, 'Library', Icons.menu_book_rounded),
                _buildDrawerTile(5, 'Academics', Icons.school_rounded),
                _buildDrawerTile(6, 'Exams', Icons.assignment_turned_in_rounded),
                _buildDrawerTile(7, 'Student Grievance', Icons.report_problem_rounded),
                _buildDrawerTile(8, 'Settings', Icons.settings_rounded),
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
        Navigator.pop(context); // Close drawer on selection
      },
    );
  }

  // --- SECTION 0: DASHBOARD OVERVIEW HOME ---
  Widget _buildDashboardHome(BuildContext context) {
    final admin = MockAdminService().getAdminProfile(SessionManager().currentUserId);
    final departments = MockAdminService().getDepartments();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildAdminDrawer(context),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.gold, size: 26),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
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
              'Camp Champ Administration Center',
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
              // 1. SYSTEM CONTROL CENTER IDENTITY BANNER
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'SYSTEM CONTROL CENTER',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.gold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.verified_user_rounded,
                                  color: AppColors.gold, size: 12),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            admin.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  admin.designation,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.gold,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Flexible(
                                child: Text(
                                  'CAMPUS ADMIN',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.gold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Body Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Action Management Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'Primary Administration',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1; // Switch to Management
                            });
                          },
                          icon: const Icon(Icons.grid_view_rounded,
                              size: 14, color: AppColors.primaryPurple),
                          label: const Text(
                            'All Controls',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: ManagementCard(
                            title: 'Students',
                            description: '2,450 Registered',
                            icon: Icons.school_outlined,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const StudentManagementScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ManagementCard(
                            title: 'Teachers',
                            description: '145 Faculty',
                            icon: Icons.badge_outlined,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TeacherManagementScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ManagementCard(
                            title: 'Parents',
                            description: '2,100 Contacts',
                            icon: Icons.family_restroom_outlined,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ParentManagementScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ManagementCard(
                            title: 'Departments',
                            description: '8 Branches',
                            icon: Icons.account_balance_outlined,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DepartmentManagementScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ManagementCard(
                            title: 'Faculty Requests',
                            description: 'Approve / Reject Requests',
                            icon: Icons.how_to_reg_outlined,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FacultyRequestsScreen(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(child: SizedBox()),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Institutional Overview Metrics
                    const Text(
                      'Institutional Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: AdminStatCard(
                            title: 'Total Students',
                            value: '2,450',
                            icon: Icons.school_rounded,
                            accentColor: AppColors.primaryPurple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AdminStatCard(
                            title: 'Faculty Members',
                            value: '145',
                            icon: Icons.badge_rounded,
                            accentColor: AppColors.secondaryPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AdminStatCard(
                            title: 'Total Parents',
                            value: '2,100',
                            icon: Icons.family_restroom_rounded,
                            accentColor: AppColors.gold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AdminStatCard(
                            title: 'Departments',
                            value: '8',
                            icon: Icons.account_balance_rounded,
                            accentColor: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Today's Campus Attendance Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.primaryPurple.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.fact_check_rounded,
                                        color: AppColors.primaryPurple, size: 20),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        "Today's Attendance Summary",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryPurple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'LIVE STATS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('Students Attendance',
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
                                            value: 0.89,
                                            backgroundColor: AppColors.lightBackground,
                                            color: AppColors.primaryPurple,
                                            strokeWidth: 6,
                                          ),
                                        ),
                                        const Text('89%',
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
                                color: AppColors.primaryPurple.withValues(alpha: 0.15),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('Faculty Attendance',
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
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Department Overview Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'Department Breakdown',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dept.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.darkText,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Code: ${dept.code}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.secondaryText,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Row(
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
                                                    const SizedBox(width: 14),
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

  // --- SECTION 1: MANAGEMENT QUICK ACCESS ---
  Widget _buildManagementOverview(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildAdminDrawer(context),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.gold, size: 26),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Management Center'),
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
