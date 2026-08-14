class SubjectResultModel {
  final String subjectCode;
  final String subjectName;
  final String grade;
  final int gradePoint;
  final int credits;

  const SubjectResultModel({
    required this.subjectCode,
    required this.subjectName,
    required this.grade,
    required this.gradePoint,
    this.credits = 4,
  });
}

class SemesterResultModel {
  final String id;
  final String studentId;
  final String semester; // 'Semester I', 'Semester II', ..., 'Semester VI'
  final List<SubjectResultModel> subjects;
  final double gpa;
  final double cgpa;
  final String result; // 'PASS', 'FAIL'
  final String publishedDate;

  const SemesterResultModel({
    required this.id,
    required this.studentId,
    required this.semester,
    required this.subjects,
    required this.gpa,
    required this.cgpa,
    this.result = 'PASS',
    this.publishedDate = '10 July 2026',
  });
}
