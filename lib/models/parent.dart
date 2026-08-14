class ParentModel {
  final String id;
  final String parentId;
  final String name;
  final String relationship;
  final String phone;
  final String email;
  final String emergencyContact;
  final String address;
  final List<String> childrenIds;
  final String studentId;
  final String studentName;
  final String registerNumber;
  final String status;

  const ParentModel({
    required this.id,
    this.parentId = 'SEC-PAR-001',
    required this.name,
    required this.relationship,
    required this.phone,
    required this.email,
    this.emergencyContact = '+91 90000 00099',
    this.address = 'No. 42, Main Road, Tiruchengode, Tamil Nadu',
    this.childrenIds = const ['1'],
    required this.studentId,
    required this.studentName,
    required this.registerNumber,
    this.status = 'Active',
  });
}
