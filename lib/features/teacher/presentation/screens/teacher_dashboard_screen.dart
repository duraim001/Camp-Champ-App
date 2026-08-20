import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/teacher.dart';
import '../../../../services/mock_teacher_service.dart';
import '../../../../services/session_manager.dart';
import '../../../admin/presentation/screens/admin_library_screen.dart';
import '../../../admin/presentation/screens/admin_settings_screen.dart';
import '../../../admin/presentation/screens/announcements_screen.dart';
import '../../../parent/presentation/screens/parent_teacher_meetings_screen.dart';
import 'class_details_screen.dart';
import 'teacher_attendance_screen.dart';
import 'teacher_exams_screen.dart';
import 'teacher_grievance_screen.dart';
import 'teacher_notifications_screen.dart';
import 'teacher_parent_details_screen.dart';
import 'teacher_profile_screen.dart';
import 'teacher_students_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int _currentIndex = 0;
  bool _hasUnreadNotifications = true;
  TeacherModel? _teacher;

  @override
  void initState() {
    super.initState();
    _loadTeacherProfile();
  }

  Future<void> _loadTeacherProfile() async {
    final userId = SessionManager().currentUserId ?? 'SEC-TCH-001';
    final profile = await MockTeacherService().getTeacherProfile(userId);
    if (mounted) {
      setState(() {
        _teacher = profile;
      });
    }
  }

  TeacherModel get _currentTeacher => _teacher ?? const TeacherModel(
    id: 'SEC-TCH-001',
    name: 'Faculty Member',
    facultyId: 'SEC-TCH-001',
    department: 'Artificial Intelligence and Data Science',
    designation: 'Assistant Professor',
    degree: 'M.Tech',
    classAdvisor: '2nd Year AI&DS',
    subjects: ['Engineering Topics'],
    email: 'faculty@sengunthar.ac.in',
    phone: '+91 90000 00002',
    college: 'Sengunthar Engineering College',
    location: 'Tiruchengode, Tamil Nadu',
    isPresent: true,
    attendancePercentage: 96.5,
    status: 'Active',
  );

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
        drawer: _buildTeacherDrawer(context),
        body: _buildPage(_currentIndex),
      ),
    );
  }

  // --- PAGE ROUTER FOR 7 TEACHER SECTIONS ---
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return _buildHeaderWrapper(
          title: 'Attendance Marking',
          subtitle: 'Student Attendance & Absent Alerts',
          child: const TeacherAttendanceScreen(),
        );
      case 2:
        return _buildHeaderWrapper(
          title: 'Campus Circulars',
          subtitle: 'Faculty Directives & Announcements',
          child: const AnnouncementsScreen(),
        );
      case 3:
        return _buildHeaderWrapper(
          title: 'Faculty Library',
          subtitle: 'Digital Book Catalog & Academic Resources',
          child: const AdminLibraryScreen(),
        );
      case 4:
        return _buildHeaderWrapper(
          title: 'Examinations & Marks',
          subtitle: 'Subject CIA Tests & Internal Marks',
          child: const TeacherExamsScreen(),
        );
      case 5:
        return _buildHeaderWrapper(
          title: 'Student Grievance & AI Analysis',
          subtitle: 'Grievance Redressal & Academic Prediction',
          child: const TeacherGrievanceScreen(),
        );
      case 6:
        return _buildHeaderWrapper(
          title: 'Teacher Settings',
          subtitle: 'Portal Preferences & Configurations',
          child: const AdminSettingsScreen(),
        );
      default:
        return _buildDashboardHome();
    }
  }

  // --- HEADER WRAPPER FOR SECONDARY TEACHER SECTIONS ---
  Widget _buildHeaderWrapper({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final teacher = _currentTeacher;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildTeacherDrawer(context),
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
              teacher.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              '${teacher.designation} • ${teacher.department}',
              style: const TextStyle(fontSize: 10, color: AppColors.gold),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.gold),
                onPressed: () {
                  setState(() {
                    _hasUnreadNotifications = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherNotificationsScreen(),
                    ),
                  );
                },
              ),
              if (_hasUnreadNotifications)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: child,
    );
  }

  // --- TEACHER HAMBURGER MENU DRAWER (7 SECTIONS) ---
  Widget _buildTeacherDrawer(BuildContext context) {
    final teacher = _currentTeacher;

    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          // Faculty Profile Header
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
              teacher.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
            accountEmail: Text(
              '${teacher.designation} • Camp Champ Faculty',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Category Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primaryPurple.withValues(alpha: 0.06),
            child: const Row(
              children: [
                Icon(Icons.menu_open_rounded, color: AppColors.primaryPurple, size: 18),
                SizedBox(width: 8),
                Text(
                  'TEACHER MENU',
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

          // Exactly 7 Ordered Navigation Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                _buildDrawerTile(0, 'Dashboard', Icons.dashboard_rounded),
                _buildDrawerTile(1, 'Attendance', Icons.fact_check_rounded),
                _buildDrawerTile(2, 'Circular', Icons.campaign_rounded),
                _buildDrawerTile(3, 'Library', Icons.menu_book_rounded),
                _buildDrawerTile(4, 'Exams', Icons.assignment_turned_in_rounded),
                _buildDrawerTile(5, 'Student Grievance', Icons.report_problem_rounded),
                _buildDrawerTile(6, 'Settings', Icons.settings_rounded),
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

  // --- SECTION 0: TEACHER DASHBOARD HOME ---
  Widget _buildDashboardHome() {
    final teacher = _currentTeacher;
    final isSaturday = DateTime.now().weekday == DateTime.saturday;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildTeacherDrawer(context),
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
              teacher.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${teacher.designation} • ${teacher.department}',
              style: const TextStyle(fontSize: 10, color: AppColors.gold),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.gold),
                onPressed: () {
                  setState(() {
                    _hasUnreadNotifications = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherNotificationsScreen(),
                    ),
                  );
                },
              ),
              if (_hasUnreadNotifications)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherProfileScreen(),
                ),
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
              // 1. FACULTY IDENTITY BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryPurple,
                      AppColors.primaryPurple.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.gold,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                teacher.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.gold,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  teacher.designation,
                                  style: const TextStyle(
                                    color: AppColors.primaryPurple,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.school_rounded,
                                size: 14,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Class Advisor: ${teacher.classAdvisor}',
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Department of ${teacher.department}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content Body
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. NEXT CLASS REMINDER
                    const Text(
                      'NEXT CLASS',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
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
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.access_time_filled_rounded,
                              color: AppColors.primaryPurple,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '2nd Year CSE',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '10:00 AM • Data Structures',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.secondaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSaturday
                                  ? AppColors.gold.withValues(alpha: 0.2)
                                  : Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSaturday ? AppColors.gold : Colors.green,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: isSaturday ? AppColors.primaryPurple : Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isSaturday ? 'ONLINE CLASS' : 'OFFLINE CLASS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isSaturday ? AppColors.primaryPurple : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // 3. MY CLASS SECTION (Horizontal Tile Cards Grid)
                    const Text(
                      'MY CLASS',
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
                        childAspectRatio: 2.1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      children: [
                        _buildFeatureCard(
                          title: 'My Classes',
                          subtitle: '3 Active Sections',
                          icon: Icons.class_outlined,
                          color: AppColors.primaryPurple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ClassDetailsScreen(
                                  className: '2nd Year CSE',
                                  department: 'Computer Science',
                                  year: '2nd Year',
                                  section: 'A',
                                  totalStudents: 42,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          title: 'Attendance',
                          subtitle: 'Mark Daily Roll',
                          icon: Icons.fact_check_outlined,
                          color: AppColors.secondaryPurple,
                          onTap: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                        ),
                        _buildFeatureCard(
                          title: 'Student Info',
                          subtitle: '42 Registered Students',
                          icon: Icons.people_outline,
                          color: AppColors.primaryPurple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TeacherStudentsScreen(),
                              ),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          title: 'Parent Info',
                          subtitle: 'Parent Contacts & Chat',
                          icon: Icons.contact_phone_outlined,
                          color: AppColors.gold,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TeacherParentDetailsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // 4. ACADEMICS & PARENT ENGAGEMENT
                    const Text(
                      'ACADEMICS & MEETINGS',
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            title: 'Exams & Marks',
                            subtitle: 'CIA Tests & Exams',
                            icon: Icons.assignment_outlined,
                            color: AppColors.primaryPurple,
                            onTap: () {
                              setState(() {
                                _currentIndex = 4;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFeatureCard(
                            title: 'PT Meetings',
                            subtitle: 'Schedule Meetings',
                            icon: Icons.handshake_outlined,
                            color: AppColors.secondaryPurple,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ParentTeacherMeetingsScreen(),
                                ),
                              );
                            },
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
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.04),
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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
}
