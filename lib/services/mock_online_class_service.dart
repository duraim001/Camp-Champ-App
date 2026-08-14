import '../models/online_class.dart';

class MockOnlineClassService {
  static final MockOnlineClassService _instance = MockOnlineClassService._internal();
  factory MockOnlineClassService() => _instance;
  MockOnlineClassService._internal() {
    _initDemoClasses();
  }

  final List<OnlineClassModel> _classes = [];

  void _initDemoClasses() {
    _classes.addAll([
      const OnlineClassModel(
        id: 'ONL001',
        teacherId: 'SEC-TCH-001',
        subject: 'Data Structures',
        className: '3rd Year - CSE - A',
        date: '12 August 2026',
        startTime: '10:00 AM',
        endTime: '11:00 AM',
        platform: 'Google Meet',
        meetingUrl: 'https://meet.google.com/demo-sec-ds',
        description: 'Binary Search Trees & Graph Algorithms Review',
        status: 'LIVE',
      ),
      const OnlineClassModel(
        id: 'ONL002',
        teacherId: 'SEC-TCH-001',
        subject: 'Database Management Systems',
        className: '3rd Year - CSE - B',
        date: '12 August 2026',
        startTime: '02:00 PM',
        endTime: '03:00 PM',
        platform: 'Google Meet',
        meetingUrl: 'https://meet.google.com/demo-sec-dbms',
        description: 'Relational Algebra & Normalization 3NF',
        status: 'UPCOMING',
      ),
      const OnlineClassModel(
        id: 'ONL003',
        teacherId: 'SEC-TCH-001',
        subject: 'Data Structures Lab',
        className: '3rd Year - CSE - A',
        date: '11 August 2026',
        startTime: '11:30 AM',
        endTime: '01:00 PM',
        platform: 'Google Meet',
        meetingUrl: 'https://meet.google.com/demo-sec-dslab',
        description: 'Implementation of AVL Trees in C++',
        status: 'COMPLETED',
      ),
    ]);
  }

  List<OnlineClassModel> getOnlineClasses() {
    return List.from(_classes);
  }

  Future<List<OnlineClassModel>> getTeacherClasses(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _classes.where((c) => c.teacherId == teacherId).toList();
  }

  Future<OnlineClassModel> createOnlineClass({
    required String teacherId,
    required String subject,
    required String className,
    required String date,
    required String startTime,
    required String endTime,
    required String platform,
    required String meetingUrl,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newClass = OnlineClassModel(
      id: 'ONL-${DateTime.now().millisecondsSinceEpoch}',
      teacherId: teacherId,
      subject: subject,
      className: className,
      date: date,
      startTime: startTime,
      endTime: endTime,
      platform: platform,
      meetingUrl: meetingUrl.isEmpty ? 'https://meet.google.com/demo-sec-class' : meetingUrl,
      description: description,
      status: 'UPCOMING',
    );
    _classes.insert(0, newClass);
    return newClass;
  }

  Future<void> updateClassStatus(String classId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _classes.indexWhere((c) => c.id == classId);
    if (index != -1) {
      final old = _classes[index];
      _classes[index] = OnlineClassModel(
        id: old.id,
        teacherId: old.teacherId,
        subject: old.subject,
        className: old.className,
        date: old.date,
        startTime: old.startTime,
        endTime: old.endTime,
        platform: old.platform,
        meetingUrl: old.meetingUrl,
        description: old.description,
        status: newStatus,
      );
    }
  }
}
