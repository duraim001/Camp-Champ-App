import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/parent.dart';
import '../../../../services/mock_parent_service.dart';
import '../widgets/user_status_badge.dart';

class ParentManagementScreen extends StatefulWidget {
  const ParentManagementScreen({super.key});

  @override
  State<ParentManagementScreen> createState() =>
      _ParentManagementScreenState();
}

class _ParentManagementScreenState extends State<ParentManagementScreen> {
  final _searchController = TextEditingController();
  List<ParentModel> _displayedParents = [];

  @override
  void initState() {
    super.initState();
    _filterParents();
  }

  void _filterParents() {
    setState(() {
      _displayedParents =
          MockParentService().searchParents(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Parent Management'),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Parent ready for Step 4')),
          );
        },
        backgroundColor: AppColors.primaryPurple,
        icon: const Icon(Icons.add, color: AppColors.gold),
        label: const Text('Add Parent',
            style: TextStyle(
                color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Field
              TextField(
                controller: _searchController,
                onChanged: (_) => _filterParents(),
                decoration: InputDecoration(
                  hintText: 'Search by parent or student name...',
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.primaryPurple),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Parent List
              Expanded(
                child: _displayedParents.isEmpty
                    ? const Center(
                        child: Text('No matching parents found.'),
                      )
                    : ListView.builder(
                        itemCount: _displayedParents.length,
                        itemBuilder: (context, index) {
                          final parent = _displayedParents[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: AppColors.primaryPurple
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        parent.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.primaryPurple,
                                        ),
                                      ),
                                      UserStatusBadge(status: parent.status),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Parent ID: ${parent.parentId}  •  Relationship: ${parent.relationship}',
                                    style: const TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Student: ${parent.studentName}',
                                    style: const TextStyle(
                                        color: AppColors.darkText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '📞 ${parent.phone}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.secondaryPurple,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.edit_outlined,
                                                size: 18,
                                                color: AppColors.primaryPurple),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.block_outlined,
                                                size: 18,
                                                color: Colors.redAccent),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
