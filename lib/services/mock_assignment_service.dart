import '../models/assignment.dart';

class MockAssignmentService {
  static final MockAssignmentService _instance = MockAssignmentService._internal();
  factory MockAssignmentService() => _instance;
  MockAssignmentService._internal() {
    _initDemoAssignments();
  }

  final List<AssignmentModel> _assignments = [];

  void _initDemoAssignments() {
    _assignments.addAll([
      const AssignmentModel(
        id: 'ASN001',
        teacherId: 'SEC-TCH-001',
        title: 'Assignment 1: Trees and Graphs',
        subject: 'Data Structures',
        className: '3rd Year - CSE - A',
        description: 'Solve the algorithms for Dijkstra and Minimum Spanning Trees.',
        questions: '1. Explain AVL tree rotations.\n2. Implement BFS & DFS in C++.',
        assignedDate: '08 Aug 2026',
        dueDate: '15 Aug 2026',
        maximumMarks: 50,
        status: 'Active',
        submissionsCount: 38,
      ),
      const AssignmentModel(
        id: 'ASN002',
        teacherId: 'SEC-TCH-001',
        title: 'Assignment 2: SQL Normalization',
        subject: 'Database Management Systems',
        className: '3rd Year - CSE - B',
        description: 'Normalize given schema up to BCNF with functional dependencies.',
        questions: '1. Define 1NF, 2NF, 3NF, BCNF.\n2. Decompose R(A,B,C,D,E) given FDs.',
        assignedDate: '05 Aug 2026',
        dueDate: '12 Aug 2026',
        maximumMarks: 50,
        status: 'Active',
        submissionsCount: 40,
      ),
    ]);
  }

  List<AssignmentModel> getAssignments() {
    return List.from(_assignments);
  }

  Future<List<AssignmentModel>> getTeacherAssignments(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _assignments.where((a) => a.teacherId == teacherId).toList();
  }

  Future<AssignmentModel> createAssignment({
    required String teacherId,
    required String title,
    required String subject,
    required String className,
    required String description,
    required String questions,
    required String assignedDate,
    required String dueDate,
    required int maximumMarks,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newAssignment = AssignmentModel(
      id: 'ASN-${DateTime.now().millisecondsSinceEpoch}',
      teacherId: teacherId,
      title: title,
      subject: subject,
      className: className,
      description: description,
      questions: questions,
      assignedDate: assignedDate,
      dueDate: dueDate,
      maximumMarks: maximumMarks,
      status: 'Active',
      submissionsCount: 0,
    );
    _assignments.insert(0, newAssignment);
    return newAssignment;
  }
}
