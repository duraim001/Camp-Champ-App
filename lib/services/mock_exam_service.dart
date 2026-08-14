import '../models/exam.dart';

class MockExamService {
  static final MockExamService _instance = MockExamService._internal();
  factory MockExamService() => _instance;
  MockExamService._internal();

  final List<ExamModel> _exams = const [
    ExamModel(id: 'EX001', examType: 'CIA 3', subject: 'Data Structures', date: '20 August 2026', time: '10:00 AM - 11:30 AM', room: 'CSE-301'),
    ExamModel(id: 'EX002', examType: 'CIA 3', subject: 'Database Management Systems', date: '21 August 2026', time: '10:00 AM - 11:30 AM', room: 'CSE-301'),
    ExamModel(id: 'EX003', examType: 'CIA 3', subject: 'Operating Systems', date: '22 August 2026', time: '10:00 AM - 11:30 AM', room: 'CSE-301'),
    ExamModel(id: 'EX004', examType: 'CIA 3', subject: 'Computer Networks', date: '23 August 2026', time: '10:00 AM - 11:30 AM', room: 'CSE-302'),
    ExamModel(id: 'EX005', examType: 'CIA 3', subject: 'Software Engineering', date: '24 August 2026', time: '10:00 AM - 11:30 AM', room: 'CSE-302'),
    ExamModel(id: 'EX006', examType: 'Semester', subject: 'End Semester Theory Exams', date: '15 September 2026', time: '10:00 AM - 01:00 PM', room: 'Main Exam Hall'),
  ];

  List<ExamModel> getExams() => List.unmodifiable(_exams);
}
