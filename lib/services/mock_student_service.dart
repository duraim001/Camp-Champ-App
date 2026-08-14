import '../models/student.dart';

class MockStudentService {
  static final MockStudentService _instance = MockStudentService._internal();
  factory MockStudentService() => _instance;
  MockStudentService._internal();

  final List<StudentModel> _students = [
    const StudentModel(
      id: '1',
      name: 'Arun Kumar',
      registerNumber: 'SEC2024001',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'arun.sec2024001@smartsec.demo',
      phone: '+91 90000 00001',
      attendancePercentage: 87.5,
      status: 'Active',
    ),
    const StudentModel(
      id: '2',
      name: 'Priya S',
      registerNumber: 'SEC2024002',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'priya.sec2024002@smartsec.demo',
      phone: '+91 90000 00004',
      attendancePercentage: 92.0,
      status: 'Active',
    ),
    const StudentModel(
      id: '3',
      name: 'Karthik M',
      registerNumber: 'SEC2024003',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'karthik.sec2024003@smartsec.demo',
      phone: '+91 90000 00005',
      attendancePercentage: 78.0,
      status: 'Active',
    ),
    const StudentModel(
      id: '4',
      name: 'Divya R',
      registerNumber: 'SEC2024004',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'divya.sec2024004@smartsec.demo',
      phone: '+91 90000 00006',
      attendancePercentage: 94.5,
      status: 'Active',
    ),
    const StudentModel(
      id: '5',
      name: 'Vignesh P',
      registerNumber: 'SEC2024005',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'vignesh.sec2024005@smartsec.demo',
      phone: '+91 90000 00007',
      attendancePercentage: 74.0,
      status: 'Active',
    ),
    const StudentModel(
      id: '6',
      name: 'Anitha K',
      registerNumber: 'SEC2024006',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'anitha.sec2024006@smartsec.demo',
      phone: '+91 90000 00008',
      attendancePercentage: 91.0,
      status: 'Active',
    ),
    const StudentModel(
      id: '7',
      name: 'Rahul V',
      registerNumber: 'SEC2024007',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'rahul.sec2024007@smartsec.demo',
      phone: '+91 90000 00009',
      attendancePercentage: 86.0,
      status: 'Active',
    ),
    const StudentModel(
      id: '8',
      name: 'Sneha M',
      registerNumber: 'SEC2024008',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'sneha.sec2024008@smartsec.demo',
      phone: '+91 90000 00010',
      attendancePercentage: 95.0,
      status: 'Active',
    ),
    const StudentModel(
      id: '9',
      name: 'Deepak S',
      registerNumber: 'SEC2024009',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'deepak.sec2024009@smartsec.demo',
      phone: '+91 90000 00011',
      attendancePercentage: 89.0,
      status: 'Active',
    ),
    const StudentModel(
      id: '10',
      name: 'Kavitha N',
      registerNumber: 'SEC2024010',
      department: 'CSE',
      course: 'B.E. Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      semester: 'V',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'kavitha.sec2024010@smartsec.demo',
      phone: '+91 90000 00012',
      attendancePercentage: 93.0,
      status: 'Active',
    ),
  ];

  StudentModel getDemoStudentProfile() {
    return _students[0];
  }

  List<StudentModel> getAllStudents() {
    return List.from(_students);
  }

  Future<List<StudentModel>> getAssignedStudents(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_students);
  }

  List<StudentModel> searchStudents(String query, {String? department}) {
    final q = query.toLowerCase().trim();
    return _students.where((s) {
      final matchesQuery = q.isEmpty || s.name.toLowerCase().contains(q) || s.registerNumber.toLowerCase().contains(q);
      final matchesDept = department == null || department == 'All' || s.department == department;
      return matchesQuery && matchesDept;
    }).toList();
  }

  Future<StudentModel?> getStudentByRegisterNumber(String registerNumber) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _students.firstWhere((s) => s.registerNumber == registerNumber);
    } catch (_) {
      return null;
    }
  }
}
