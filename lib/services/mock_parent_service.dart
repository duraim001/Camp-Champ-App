import '../models/parent.dart';

class MockParentService {
  static final MockParentService _instance = MockParentService._internal();
  factory MockParentService() => _instance;
  MockParentService._internal();

  final List<ParentModel> _parents = [
    const ParentModel(
      id: 'PAR001',
      studentId: '1',
      studentName: 'Arun Kumar',
      registerNumber: 'SEC2024001',
      name: 'Mr. Kumar',
      relationship: 'Father',
      phone: '+91 90000 00003',
      email: 'parent.demo@smartsec.demo',
      emergencyContact: '+91 90000 00099',
      address: 'No. 42, Main Road, Tiruchengode, Tamil Nadu',
    ),
    const ParentModel(
      id: 'PAR002',
      studentId: '2',
      studentName: 'Priya S',
      registerNumber: 'SEC2024002',
      name: 'Mr. Sundaram',
      relationship: 'Father',
      phone: '+91 90000 00014',
      email: 'sundaram.p@smartsec.demo',
      emergencyContact: '+91 90000 00098',
      address: '12-A, Anna Nagar, Salem, Tamil Nadu',
    ),
    const ParentModel(
      id: 'PAR003',
      studentId: '3',
      studentName: 'Karthik M',
      registerNumber: 'SEC2024003',
      name: 'Mrs. Meenakshi',
      relationship: 'Mother',
      phone: '+91 90000 00015',
      email: 'meenakshi.m@smartsec.demo',
      emergencyContact: '+91 90000 00097',
      address: '45, West Street, Erode, Tamil Nadu',
    ),
    const ParentModel(
      id: 'PAR004',
      studentId: '4',
      studentName: 'Divya R',
      registerNumber: 'SEC2024004',
      name: 'Mr. Rajan',
      relationship: 'Father',
      phone: '+91 90000 00016',
      email: 'rajan.d@smartsec.demo',
      emergencyContact: '+91 90000 00096',
      address: '78, South Cross Road, Tiruchengode, Tamil Nadu',
    ),
    const ParentModel(
      id: 'PAR005',
      studentId: '5',
      studentName: 'Vignesh P',
      registerNumber: 'SEC2024005',
      name: 'Mr. Periasamy',
      relationship: 'Father',
      phone: '+91 90000 00017',
      email: 'periasamy.v@smartsec.demo',
      emergencyContact: '+91 90000 00095',
      address: '19, Bus Stand Road, Namakkal, Tamil Nadu',
    ),
  ];

  List<ParentModel> searchParents(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return List.from(_parents);
    return _parents.where((p) => p.name.toLowerCase().contains(q) || p.studentName.toLowerCase().contains(q)).toList();
  }

  Future<List<ParentModel>> getAssignedParents(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_parents);
  }

  Future<ParentModel?> getParentByStudentId(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _parents.firstWhere((p) => p.studentId == studentId);
    } catch (_) {
      return ParentModel(
        id: 'PAR-GEN-$studentId',
        studentId: studentId,
        studentName: 'Student $studentId',
        registerNumber: 'SEC2024$studentId',
        name: 'Parent of Student $studentId',
        relationship: 'Guardian',
        phone: '+91 90000 00033',
        email: 'guardian.demo@smartsec.demo',
        emergencyContact: '+91 90000 00099',
        address: 'Tiruchengode, Tamil Nadu',
      );
    }
  }
}
