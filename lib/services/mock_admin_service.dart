import '../models/admin.dart';
import '../models/announcement.dart';
import '../models/department.dart';
import '../models/permission.dart';

class MockAdminService {
  static final MockAdminService _instance = MockAdminService._internal();
  factory MockAdminService() => _instance;
  MockAdminService._internal();

  AdminModel getAdminProfile([String? adminId]) {
    if (adminId == 'santhipriyahod@gmail.com' || adminId == 'SEC-AIDS-HOD') {
      return const AdminModel(
        id: 'SEC-AIDS-HOD',
        name: 'Dr. Santhipriya',
        email: 'santhipriyahod@gmail.com',
        role: 'HOD - AI & Data Science',
        designation: 'Head of Department (AIDS)',
        college: 'Sengunthar Engineering College',
        location: 'Tiruchengode, Namakkal District, Tamil Nadu',
      );
    } else if (adminId == 'HOD-001' || adminId == 'ramesh') {
      return const AdminModel(
        id: 'SEC-HOD-001',
        name: 'Ramesh',
        email: 'ramesh@smartsec.demo',
        role: 'HOD',
        designation: 'HOD',
        college: 'Sengunthar Engineering College',
        location: 'Tiruchengode, Namakkal District, Tamil Nadu',
      );
    } else if (adminId == 'DEAN-001' || adminId == 'kumar') {
      return const AdminModel(
        id: 'SEC-DEN-001',
        name: 'Kumar',
        email: 'kumar@smartsec.demo',
        role: 'Dean',
        designation: 'Dean',
        college: 'Sengunthar Engineering College',
        location: 'Tiruchengode, Namakkal District, Tamil Nadu',
      );
    }

    return const AdminModel(
      id: 'SEC-ADM-001',
      name: 'Sathishkumar',
      email: 'admin@smartsec.demo',
      role: 'Principal',
      designation: 'Principal',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode, Namakkal District, Tamil Nadu',
    );
  }

  final List<DepartmentModel> _departments = [
    const DepartmentModel(
      id: '1',
      name: 'Computer Science & Engineering',
      code: 'CSE',
      studentCount: 480,
      teacherCount: 28,
      isActive: true,
    ),
    const DepartmentModel(
      id: '2',
      name: 'Information Technology',
      code: 'IT',
      studentCount: 360,
      teacherCount: 22,
      isActive: true,
    ),
    const DepartmentModel(
      id: '3',
      name: 'Electronics & Comm. Engg.',
      code: 'ECE',
      studentCount: 420,
      teacherCount: 26,
      isActive: true,
    ),
    const DepartmentModel(
      id: '4',
      name: 'Electrical & Elec. Engg.',
      code: 'EEE',
      studentCount: 300,
      teacherCount: 20,
      isActive: true,
    ),
    const DepartmentModel(
      id: '5',
      name: 'Mechanical Engineering',
      code: 'MECH',
      studentCount: 450,
      teacherCount: 27,
      isActive: true,
    ),
    const DepartmentModel(
      id: '6',
      name: 'Civil Engineering',
      code: 'CIVIL',
      studentCount: 240,
      teacherCount: 16,
      isActive: true,
    ),
  ];

  List<DepartmentModel> getDepartments() => List.unmodifiable(_departments);

  final List<AnnouncementModel> _announcements = [
    const AnnouncementModel(
      id: '1',
      title: 'Internal Examination Schedule Released',
      content: 'The 2nd Internal Examinations for all B.E./B.Tech programs will commence from August 20th.',
      date: 'Aug 10, 2026',
      audience: 'All',
      status: 'Published',
    ),
    const AnnouncementModel(
      id: '2',
      title: 'Placement Training Program for 4th Year Students',
      content: 'Mandatory Aptitude & Soft Skills training starts next Monday at Main Auditorium.',
      date: 'Aug 08, 2026',
      audience: 'Students',
      status: 'Published',
    ),
    const AnnouncementModel(
      id: '3',
      title: 'Faculty Development Program (FDP) Announcement',
      content: 'AI & Data Science Workshop for Teaching Staff scheduled for August 25th.',
      date: 'Aug 05, 2026',
      audience: 'Teachers',
      status: 'Published',
    ),
  ];

  List<AnnouncementModel> getAnnouncements() => List.unmodifiable(_announcements);

  void addAnnouncement(AnnouncementModel announcement) {
    _announcements.insert(0, announcement);
  }

  final List<RolePermissionModel> _rolePermissions = [
    RolePermissionModel(
      roleName: 'Students',
      totalUsers: 2450,
      activeUsers: 2420,
      inactiveUsers: 30,
      isAccessEnabled: true,
    ),
    RolePermissionModel(
      roleName: 'Teachers',
      totalUsers: 145,
      activeUsers: 143,
      inactiveUsers: 2,
      isAccessEnabled: true,
    ),
    RolePermissionModel(
      roleName: 'Parents',
      totalUsers: 2100,
      activeUsers: 2080,
      inactiveUsers: 20,
      isAccessEnabled: true,
    ),
    RolePermissionModel(
      roleName: 'Administrators',
      totalUsers: 5,
      activeUsers: 5,
      inactiveUsers: 0,
      isAccessEnabled: true,
    ),
  ];

  List<RolePermissionModel> getRolePermissions() => _rolePermissions;
}
