import '../models/timetable_entry.dart';

class MockTimetableService {
  static final MockTimetableService _instance = MockTimetableService._internal();
  factory MockTimetableService() => _instance;
  MockTimetableService._internal();

  final List<TimetableEntryModel> _teacherTimetable = [
    const TimetableEntryModel(
      id: 'TT001',
      day: 'Monday',
      period: '1st Period',
      timeSlot: '09:00 AM - 10:00 AM',
      subject: 'Data Structures',
      faculty: 'Dr. Ravi Kumar',
      room: 'CSE-301',
    ),
    const TimetableEntryModel(
      id: 'TT002',
      day: 'Monday',
      period: '2nd Period',
      timeSlot: '10:00 AM - 11:00 AM',
      subject: 'Database Management Systems',
      faculty: 'Dr. Ravi Kumar',
      room: 'CSE-302',
    ),
    const TimetableEntryModel(
      id: 'TT003',
      day: 'Tuesday',
      period: '3rd Period',
      timeSlot: '11:15 AM - 12:15 PM',
      subject: 'Data Structures Lab',
      faculty: 'Dr. Ravi Kumar',
      room: 'Lab-CSE-2',
    ),
    const TimetableEntryModel(
      id: 'TT004',
      day: 'Wednesday',
      period: '1st Period',
      timeSlot: '09:00 AM - 10:00 AM',
      subject: 'Data Structures',
      faculty: 'Dr. Ravi Kumar',
      room: 'CSE-301',
    ),
    const TimetableEntryModel(
      id: 'TT005',
      day: 'Thursday',
      period: '5th Period',
      timeSlot: '02:00 PM - 03:00 PM',
      subject: 'Database Management Systems',
      faculty: 'Dr. Ravi Kumar',
      room: 'CSE-302',
    ),
    const TimetableEntryModel(
      id: 'TT006',
      day: 'Friday',
      period: '2nd Period',
      timeSlot: '10:00 AM - 11:00 AM',
      subject: 'Data Structures',
      faculty: 'Dr. Ravi Kumar',
      room: 'CSE-301',
    ),
  ];

  List<TimetableEntryModel> getTimetableForDay(String day) {
    return _teacherTimetable.where((t) => t.day.toLowerCase() == day.toLowerCase()).toList();
  }

  Future<List<TimetableEntryModel>> getTeacherTimetable(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_teacherTimetable);
  }
}
