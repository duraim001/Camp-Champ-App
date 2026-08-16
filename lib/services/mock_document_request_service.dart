class DocumentRequestModel {
  final String id;
  final String title;
  final String requestedBy;
  final String studentId;
  final String studentName;
  final String instructions;
  final String requestedDate;
  String status; // 'Requested', 'Submitted', 'Under Review', 'Approved', 'Rejected'
  String? uploadedFileName;
  String? uploadedDate;

  DocumentRequestModel({
    required this.id,
    required this.title,
    required this.requestedBy,
    required this.studentId,
    required this.studentName,
    required this.instructions,
    required this.requestedDate,
    this.status = 'Requested',
    this.uploadedFileName,
    this.uploadedDate,
  });
}

class MockDocumentRequestService {
  static final MockDocumentRequestService _instance =
      MockDocumentRequestService._internal();
  factory MockDocumentRequestService() => _instance;
  MockDocumentRequestService._internal();

  final List<DocumentRequestModel> _requests = [
    DocumentRequestModel(
      id: 'REQ-DOC-001',
      title: 'Signed Bonafide Certificate Application',
      requestedBy: 'Karthik (Assistant Professor • CSE)',
      studentId: 'SEC-STD-001',
      studentName: 'Arun Kumar',
      instructions:
          'Upload scanned copy of your signed Bonafide Application form for scholarship verification.',
      requestedDate: '15 Aug 2026',
      status: 'Requested',
    ),
    DocumentRequestModel(
      id: 'REQ-DOC-002',
      title: 'Data Structures Lab Record Index Scan',
      requestedBy: 'Karthik (Assistant Professor • CSE)',
      studentId: 'SEC-STD-001',
      studentName: 'Arun Kumar',
      instructions:
          'Upload PDF scan of completed Data Structures Lab Index page signed by lab instructor.',
      requestedDate: '10 Aug 2026',
      status: 'Submitted',
      uploadedFileName: 'ds_lab_index_arun.pdf',
      uploadedDate: '12 Aug 2026',
    ),
  ];

  List<DocumentRequestModel> getRequestsForStudent(String studentId) {
    return _requests.where((r) => r.studentId == studentId).toList();
  }

  List<DocumentRequestModel> getAllRequests() {
    return List.unmodifiable(_requests);
  }

  bool submitDocument({
    required String requestId,
    required String fileName,
  }) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _requests[index].status = 'Submitted';
      _requests[index].uploadedFileName = fileName;
      _requests[index].uploadedDate = '16 Aug 2026';
      return true;
    }
    return false;
  }

  void createRequest({
    required String title,
    required String requestedBy,
    required String studentId,
    required String studentName,
    required String instructions,
  }) {
    _requests.add(
      DocumentRequestModel(
        id: 'REQ-DOC-${100 + _requests.length + 1}',
        title: title,
        requestedBy: requestedBy,
        studentId: studentId,
        studentName: studentName,
        instructions: instructions,
        requestedDate: '16 Aug 2026',
        status: 'Requested',
      ),
    );
  }
}
