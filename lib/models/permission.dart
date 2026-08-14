class RolePermissionModel {
  final String roleName;
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  bool isAccessEnabled;

  RolePermissionModel({
    required this.roleName,
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    this.isAccessEnabled = true,
  });
}
