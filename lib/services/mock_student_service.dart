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
      rollNumber: '01',
      dateOfBirth: '15/06/2005',
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
      rollNumber: '02',
      dateOfBirth: '22/08/2005',
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
      rollNumber: '03',
      dateOfBirth: '10/01/2005',
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
      rollNumber: '04',
      dateOfBirth: '05/11/2005',
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
      rollNumber: '05',
      dateOfBirth: '18/03/2005',
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
      rollNumber: '06',
      dateOfBirth: '30/07/2005',
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
      rollNumber: '07',
      dateOfBirth: '14/09/2005',
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
      rollNumber: '08',
      dateOfBirth: '25/12/2005',
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
      rollNumber: '09',
      dateOfBirth: '08/04/2005',
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
      rollNumber: '10',
      dateOfBirth: '19/10/2005',
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
      status: 'Inactive',
    ),
    const StudentModel(
      id: '11',
      name: 'Arun Kumar',
      registerNumber: '23AIDS001',
      rollNumber: '01',
      dateOfBirth: '15/06/2005',
      department: 'AI & DS',
      course: 'B.Tech Artificial Intelligence and Data Science',
      year: '2nd Year',
      section: 'A',
      semester: 'III',
      college: 'Sengunthar Engineering College',
      location: 'Tiruchengode',
      email: 'arunkumar.23aids001@smartsec.demo',
      phone: '+91 90000 00001',
      attendancePercentage: 88.0,
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
      final matchesQuery = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.registerNumber.toLowerCase().contains(q) ||
          s.rollNumber.toLowerCase().contains(q);
      final matchesDept = department == null || department == 'All' || s.department == department;
      return matchesQuery && matchesDept;
    }).toList();
  }

  Future<StudentModel?> getStudentByRegisterNumber(String registerNumber) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final trimmed = registerNumber.trim().toLowerCase();
    try {
      return _students.firstWhere((s) => s.registerNumber.toLowerCase() == trimmed);
    } catch (_) {
      return null;
    }
  }

  /// Normalizes date string into YYYY-MM-DD format for robust comparison
  static String? normalizeDate(String input) {
    final clean = input.trim();
    if (clean.isEmpty) return null;

    // Matches DD/MM/YYYY or DD-MM-YYYY
    final dmyRegex = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$');
    final dmyMatch = dmyRegex.firstMatch(clean);
    if (dmyMatch != null) {
      final day = int.parse(dmyMatch.group(1)!);
      final month = int.parse(dmyMatch.group(2)!);
      final year = int.parse(dmyMatch.group(3)!);
      return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
    }

    // Matches YYYY-MM-DD or YYYY/MM/DD
    final ymdRegex = RegExp(r'^(\d{4})[/-](\d{1,2})[/-](\d{1,2})$');
    final ymdMatch = ymdRegex.firstMatch(clean);
    if (ymdMatch != null) {
      final year = int.parse(ymdMatch.group(1)!);
      final month = int.parse(ymdMatch.group(2)!);
      final day = int.parse(ymdMatch.group(3)!);
      return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
    }

    return clean;
  }

  /// Authenticate student by Register Number OR Roll Number + Date of Birth
  Future<Map<String, dynamic>> authenticateStudent({
    required String identifier,
    required String dateOfBirth,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

    final trimmedIdentifier = identifier.trim().toLowerCase();
    final trimmedDob = dateOfBirth.trim();

    if (trimmedIdentifier.isEmpty || trimmedDob.isEmpty) {
      return {
        'success': false,
        'error': 'Please enter your Register Number/Roll Number and Date of Birth.',
      };
    }

    final normalizedInputDob = normalizeDate(trimmedDob);

    // Find student matching register number OR roll number
    StudentModel? matchedStudent;
    for (final s in _students) {
      final regMatch = s.registerNumber.toLowerCase() == trimmedIdentifier;
      final rollMatch = s.rollNumber.isNotEmpty &&
          (s.rollNumber.toLowerCase() == trimmedIdentifier ||
              int.tryParse(s.rollNumber)?.toString() == trimmedIdentifier ||
              s.rollNumber.padLeft(2, '0') == trimmedIdentifier.padLeft(2, '0'));

      if (regMatch || rollMatch) {
        matchedStudent = s;
        break;
      }
    }

    if (matchedStudent == null) {
      return {
        'success': false,
        'error': 'Invalid Register Number/Roll Number or Date of Birth.',
      };
    }

    // Verify Date of Birth
    final normalizedStudentDob = normalizeDate(matchedStudent.dateOfBirth);
    if (normalizedInputDob == null || normalizedInputDob != normalizedStudentDob) {
      return {
        'success': false,
        'error': 'Invalid Register Number/Roll Number or Date of Birth.',
      };
    }

    // Check account active status
    if (matchedStudent.status.toLowerCase() != 'active') {
      return {
        'success': false,
        'error': 'Your account is currently inactive. Please contact the administrator.',
      };
    }

    // Return authenticated student info (do NOT expose DOB or sensitive fields)
    return {
      'success': true,
      'access_token': 'mock-jwt-token-${matchedStudent.registerNumber}',
      'token_type': 'bearer',
      'user': {
        'id': matchedStudent.id,
        'register_number': matchedStudent.registerNumber,
        'roll_number': matchedStudent.rollNumber,
        'name': matchedStudent.name,
        'role': 'STUDENT',
      },
    };
  }
}

