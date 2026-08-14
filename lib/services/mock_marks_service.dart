import '../models/marks.dart';

class MockMarksService {
  static final MockMarksService _instance = MockMarksService._internal();
  factory MockMarksService() => _instance;
  MockMarksService._internal();

  final List<MarksModel> _marksList = const [
    MarksModel(
      subjectCode: 'CS3401',
      subjectName: 'Data Structures',
      cia1: 82,
      cia2: 86,
      cia3: 88,
    ),
    MarksModel(
      subjectCode: 'CS3402',
      subjectName: 'Database Management Systems',
      cia1: 78,
      cia2: 84,
      cia3: 81,
    ),
    MarksModel(
      subjectCode: 'CS3403',
      subjectName: 'Operating Systems',
      cia1: 75,
      cia2: 80,
      cia3: 85,
    ),
    MarksModel(
      subjectCode: 'CS3404',
      subjectName: 'Computer Networks',
      cia1: 88,
      cia2: 90,
      cia3: 87,
    ),
    MarksModel(
      subjectCode: 'CS3405',
      subjectName: 'Software Engineering',
      cia1: 84,
      cia2: 86,
      cia3: 90,
    ),
  ];

  List<MarksModel> getStudentMarks() => List.unmodifiable(_marksList);

  double getOverallCiaPercentage() {
    double totalAvg = 0;
    for (var m in _marksList) {
      totalAvg += m.average;
    }
    return totalAvg / _marksList.length;
  }
}
