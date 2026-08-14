import '../models/semester_result.dart';

class MockSemesterResultService {
  static final MockSemesterResultService _instance = MockSemesterResultService._internal();
  factory MockSemesterResultService() => _instance;
  MockSemesterResultService._internal();

  final Map<String, SemesterResultModel> _demoResults = {
    'Semester VI': const SemesterResultModel(
      id: 'SEM-06',
      studentId: '1',
      semester: 'Semester VI',
      gpa: 8.6,
      cgpa: 8.4,
      result: 'PASS',
      publishedDate: '10 July 2026',
      subjects: [
        SubjectResultModel(subjectCode: 'CS601', subjectName: 'Data Structures', grade: 'A+', gradePoint: 9, credits: 4),
        SubjectResultModel(subjectCode: 'CS602', subjectName: 'Database Management Systems', grade: 'A', gradePoint: 8, credits: 4),
        SubjectResultModel(subjectCode: 'CS603', subjectName: 'Operating Systems', grade: 'A', gradePoint: 8, credits: 4),
        SubjectResultModel(subjectCode: 'CS604', subjectName: 'Computer Networks', grade: 'A+', gradePoint: 9, credits: 4),
        SubjectResultModel(subjectCode: 'CS605', subjectName: 'Software Engineering', grade: 'A+', gradePoint: 9, credits: 3),
      ],
    ),
    'Semester V': const SemesterResultModel(
      id: 'SEM-05',
      studentId: '1',
      semester: 'Semester V',
      gpa: 8.3,
      cgpa: 8.35,
      result: 'PASS',
      publishedDate: '15 January 2026',
      subjects: [
        SubjectResultModel(subjectCode: 'CS501', subjectName: 'Design and Analysis of Algorithms', grade: 'A', gradePoint: 8, credits: 4),
        SubjectResultModel(subjectCode: 'CS502', subjectName: 'Object Oriented Systems', grade: 'A+', gradePoint: 9, credits: 4),
        SubjectResultModel(subjectCode: 'CS503', subjectName: 'Theory of Computation', grade: 'B+', gradePoint: 7, credits: 4),
        SubjectResultModel(subjectCode: 'CS504', subjectName: 'Web Technology', grade: 'A+', gradePoint: 9, credits: 3),
      ],
    ),
    'Semester IV': const SemesterResultModel(
      id: 'SEM-04',
      studentId: '1',
      semester: 'Semester IV',
      gpa: 8.5,
      cgpa: 8.4,
      result: 'PASS',
      publishedDate: '20 June 2025',
      subjects: [
        SubjectResultModel(subjectCode: 'CS401', subjectName: 'Discrete Mathematics', grade: 'A+', gradePoint: 9, credits: 4),
        SubjectResultModel(subjectCode: 'CS402', subjectName: 'Computer Architecture', grade: 'A', gradePoint: 8, credits: 4),
      ],
    ),
  };

  Future<SemesterResultModel?> getSemesterResult(String studentId, String semester) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _demoResults[semester];
  }
}
