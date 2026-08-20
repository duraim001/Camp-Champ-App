import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/mock_student_service.dart';
import '../../../admin/presentation/screens/admin_library_screen.dart';
import '../../../admin/presentation/screens/announcements_screen.dart';
import 'academic_performance_screen.dart';
import 'assignments_screen.dart';
import 'attendance_screen.dart';
import 'exam_schedule_screen.dart';
import 'notifications_screen.dart';
import 'online_classes_screen.dart';
import 'student_grievance_screen.dart';
import 'student_profile_screen.dart';
import 'student_settings_screen.dart';
import '../widgets/student_stat_card.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
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
        drawer: _buildStudentDrawer(context),
        body: _buildPage(_currentIndex),
      ),
    );
  }

  // --- PAGE ROUTER FOR 7 STUDENT SECTIONS ---
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildHomeDashboard(context);
      case 1:
        return _buildHeaderWrapper(
          title: 'Campus Circulars',
          subtitle: 'Official Campus Directives & Notices',
          child: const AnnouncementsScreen(),
        );
      case 2:
        return _buildHeaderWrapper(
          title: 'Student Library',
          subtitle: 'Digital Books & Resource Catalog',
          child: const AdminLibraryScreen(),
        );
      case 3:
        return _buildHeaderWrapper(
          title: 'Academic Overview',
          subtitle: 'Subjects, Schedule & CIA Performance',
          child: const AcademicPerformanceScreen(),
        );
      case 4:
        return _buildHeaderWrapper(
          title: 'Examinations & Timetable',
          subtitle: 'Exam Schedule & CIA Internal Marks',
          child: const ExamScheduleScreen(),
        );
      case 5:
        return _buildHeaderWrapper(
          title: 'Student Grievance & AI Analysis',
          subtitle: 'Redressal & AI Performance Prediction',
          child: const StudentGrievanceScreen(),
        );
      case 6:
        return _buildHeaderWrapper(
          title: 'Student Account & Settings',
          subtitle: 'Upload Documents, Password & Preferences',
          child: const StudentSettingsScreen(),
        );
      default:
        return _buildHomeDashboard(context);
    }
  }

  // --- HEADER WRAPPER FOR SECONDARY STUDENT SECTIONS ---
  Widget _buildHeaderWrapper({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final student = MockStudentService().getDemoStudentProfile();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildStudentDrawer(context),
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
              student.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              '${student.year} • ${student.department}',
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
                  builder: (context) => const NotificationsScreen(),
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
                  builder: (context) => const StudentProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: child,
    );
  }

  // --- STUDENT HAMBURGER MENU DRAWER (7 SECTIONS) ---
  Widget _buildStudentDrawer(BuildContext context) {
    final student = MockStudentService().getDemoStudentProfile();

    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          // Student Profile Drawer Header
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
                      Icons.school_rounded,
                      size: 38,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
              ),
            ),
            accountName: Text(
              student.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
            accountEmail: Text(
              'Reg No: ${student.registerNumber} • Camp Champ Student',
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
                  'STUDENT MENU',
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
                _buildDrawerTile(1, 'Circular', Icons.campaign_rounded),
                _buildDrawerTile(2, 'Library', Icons.menu_book_rounded),
                _buildDrawerTile(3, 'Academics', Icons.school_rounded),
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
        Navigator.pop(context); // Close drawer on tap
      },
    );
  }

  // --- SECTION 0: STUDENT DASHBOARD HOME OVERVIEW ---
  Widget _buildHomeDashboard(BuildContext context) {
    final student = MockStudentService().getDemoStudentProfile();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      drawer: _buildStudentDrawer(context),
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
              student.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              '${student.year} • ${student.department}',
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
                  builder: (context) => const NotificationsScreen(),
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
                  builder: (context) => const StudentProfileScreen(),
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
              // 1. STUDENT IDENTITY BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryPurple,
                      AppColors.secondaryPurple
                    ],
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
                      child: const Icon(Icons.school_rounded,
                          color: AppColors.gold, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REGISTER NO: ${student.registerNumber}',
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${student.course} • ${student.year}',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Sengunthar Engineering College',
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
              const SizedBox(height: 20),

              // 2. ACADEMIC & ATTENDANCE OVERVIEW METRICS
              const Text(
                'ACADEMIC OVERVIEW',
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
                  mainAxisExtent: 82,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AttendanceScreen())),
                    child: const StudentStatCard(
                      title: 'ATTENDANCE',
                      value: '87%',
                      icon: Icons.pie_chart_outline,
                      color: Colors.green,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 3; // Switch to Academics tab
                      });
                    },
                    child: const StudentStatCard(
                      title: 'CIA PERFORMANCE',
                      value: '82%',
                      icon: Icons.analytics_outlined,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AssignmentsScreen())),
                    child: const StudentStatCard(
                      title: 'ASSIGNMENTS',
                      value: '3 Pending',
                      icon: Icons.assignment_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnlineClassesScreen())),
                    child: const StudentStatCard(
                      title: "TODAY'S CLASSES",
                      value: '4 Scheduled',
                      icon: Icons.videocam_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. QUICK ACCESS DIRECTORY
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
                title: 'Attendance Breakdown',
                subtitle: 'View subject-wise attendance (87% Overall)',
                icon: Icons.fact_check_outlined,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AttendanceScreen())),
              ),
              const SizedBox(height: 10),
              _buildQuickActionTile(
                context,
                title: 'Academic Marks & CIA',
                subtitle: 'View CIA 1, CIA 2, CIA 3 subject marks',
                icon: Icons.grade_outlined,
                onTap: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildQuickActionTile(
                context,
                title: 'Assignments & Submissions',
                subtitle: 'View assigned questions and deadlines',
                icon: Icons.assignment_turned_in_outlined,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AssignmentsScreen())),
              ),
              const SizedBox(height: 10),
              _buildQuickActionTile(
                context,
                title: 'Exam Schedule & Results',
                subtitle: 'View upcoming CIA & Semester exam dates',
                icon: Icons.event_note_outlined,
                onTap: () {
                  setState(() {
                    _currentIndex = 4;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildQuickActionTile(
                context,
                title: 'Grievance & AI Prediction',
                subtitle: 'Submit query & view performance analysis',
                icon: Icons.auto_awesome_outlined,
                onTap: () {
                  setState(() {
                    _currentIndex = 5;
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
