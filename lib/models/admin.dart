class AdminModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String designation;
  final String college;
  final String location;
  final String avatarUrl;

  const AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    String? designation,
    required this.college,
    required this.location,
    this.avatarUrl = '',
  }) : designation = designation ?? role;
}
