class FacultyAccountRequestModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String employeeId;
  final String department;
  final String designation;
  final String username;
  final String passwordHash;
  final String status; // 'PENDING', 'APPROVED', 'REJECTED'
  final DateTime requestedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? rejectionReason;

  FacultyAccountRequestModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.employeeId,
    required this.department,
    required this.designation,
    required this.username,
    required this.passwordHash,
    this.status = 'PENDING',
    DateTime? requestedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
  }) : requestedAt = requestedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'employee_id': employeeId,
      'department': department,
      'designation': designation,
      'username': username,
      'password_hash': passwordHash,
      'status': status,
      'requested_at': requestedAt.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
      'reviewed_by': reviewedBy,
      'rejection_reason': rejectionReason,
    };
  }

  factory FacultyAccountRequestModel.fromJson(Map<String, dynamic> json) {
    return FacultyAccountRequestModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      employeeId: json['employee_id'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      username: json['username'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      status: json['status'] ?? 'PENDING',
      requestedAt: json['requested_at'] != null
          ? DateTime.tryParse(json['requested_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.tryParse(json['reviewed_at'].toString())
          : null,
      reviewedBy: json['reviewed_by'],
      rejectionReason: json['rejection_reason'],
    );
  }

  FacultyAccountRequestModel copyWith({
    String? status,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
  }) {
    return FacultyAccountRequestModel(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      employeeId: employeeId,
      department: department,
      designation: designation,
      username: username,
      passwordHash: passwordHash,
      status: status ?? this.status,
      requestedAt: requestedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
