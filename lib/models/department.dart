class DepartmentModel {
  final String id;
  final String name;
  final String code;
  final int studentCount;
  final int teacherCount;
  final bool isActive;

  const DepartmentModel({
    required this.id,
    required this.name,
    required this.code,
    required this.studentCount,
    required this.teacherCount,
    this.isActive = true,
  });
}
