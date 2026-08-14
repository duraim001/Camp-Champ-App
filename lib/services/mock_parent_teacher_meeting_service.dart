import '../models/parent_teacher_meeting.dart';

class MockParentTeacherMeetingService {
  static final MockParentTeacherMeetingService _instance = MockParentTeacherMeetingService._internal();
  factory MockParentTeacherMeetingService() => _instance;
  MockParentTeacherMeetingService._internal() {
    _initDemoMeetings();
  }

  final List<ParentTeacherMeetingModel> _myMeetings = [];

  void _initDemoMeetings() {
    _myMeetings.addAll([
      const ParentTeacherMeetingModel(
        id: 'PTM001',
        parentId: 'SEC-PAR-001',
        studentId: '1',
        studentName: 'Arun Kumar',
        registerNumber: 'SEC2024001',
        teacherId: 'SEC-TCH-001',
        teacherName: 'Dr. Ravi Kumar',
        subject: 'Data Structures',
        date: '15 August 2026',
        startTime: '02:00 PM',
        endTime: '02:15 PM',
        status: MeetingStatus.confirmed,
        meetingType: 'Online - Google Meet',
        notes: 'Discussion on CIA 2 progress and upcoming lab practical exams.',
        meetingLink: 'https://meet.google.com/ptm-sec-demo',
      ),
      const ParentTeacherMeetingModel(
        id: 'PTM002',
        parentId: 'SEC-PAR-001',
        studentId: '1',
        studentName: 'Arun Kumar',
        registerNumber: 'SEC2024001',
        teacherId: 'SEC-TCH-001',
        teacherName: 'Dr. Ravi Kumar',
        subject: 'Database Management Systems',
        date: '01 August 2026',
        startTime: '11:00 AM',
        endTime: '11:15 AM',
        status: MeetingStatus.completed,
        meetingType: 'In-Person (Room CSE-301)',
        notes: 'Reviewed 1st semester performance and attendance guidelines.',
      ),
    ]);
  }

  List<Map<String, dynamic>> getAvailableSlots() {
    return [
      {
        'teacherId': 'SEC-TCH-001',
        'teacherName': 'Dr. Ravi Kumar',
        'subject': 'Data Structures',
        'date': '20 August 2026',
        'timeSlots': [
          {'start': '10:00 AM', 'end': '10:15 AM', 'isBooked': false},
          {'start': '10:15 AM', 'end': '10:30 AM', 'isBooked': false},
          {'start': '10:30 AM', 'end': '10:45 AM', 'isBooked': false},
          {'start': '11:00 AM', 'end': '11:15 AM', 'isBooked': false},
        ],
      },
      {
        'teacherId': 'SEC-TCH-001',
        'teacherName': 'Dr. Ravi Kumar',
        'subject': 'Database Management Systems',
        'date': '22 August 2026',
        'timeSlots': [
          {'start': '02:00 PM', 'end': '02:15 PM', 'isBooked': false},
          {'start': '02:15 PM', 'end': '02:30 PM', 'isBooked': false},
        ],
      },
    ];
  }

  Future<List<ParentTeacherMeetingModel>> getMyMeetings(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _myMeetings.where((m) => m.parentId == parentId).toList();
  }

  Future<ParentTeacherMeetingModel> bookMeeting({
    required String parentId,
    required String studentId,
    required String studentName,
    required String registerNumber,
    required String teacherId,
    required String teacherName,
    required String subject,
    required String date,
    required String startTime,
    required String endTime,
    String notes = 'Parent requested session regarding academic performance.',
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newMeeting = ParentTeacherMeetingModel(
      id: 'PTM-${DateTime.now().millisecondsSinceEpoch}',
      parentId: parentId,
      studentId: studentId,
      studentName: studentName,
      registerNumber: registerNumber,
      teacherId: teacherId,
      teacherName: teacherName,
      subject: subject,
      date: date,
      startTime: startTime,
      endTime: endTime,
      status: MeetingStatus.requested,
      meetingType: 'Online - Google Meet',
      notes: notes,
    );
    _myMeetings.insert(0, newMeeting);
    return newMeeting;
  }

  Future<bool> cancelMeeting(String meetingId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _myMeetings.indexWhere((m) => m.id == meetingId);
    if (index != -1 && _myMeetings[index].status == MeetingStatus.requested) {
      _myMeetings[index] = _myMeetings[index].copyWith(status: MeetingStatus.cancelled);
      return true;
    }
    return false;
  }
}
