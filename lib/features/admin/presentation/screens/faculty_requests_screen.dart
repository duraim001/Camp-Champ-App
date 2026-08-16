import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/faculty_account_request.dart';
import '../../../../services/faculty_request_service.dart';
import '../../../../services/session_manager.dart';

class FacultyRequestsScreen extends StatefulWidget {
  const FacultyRequestsScreen({super.key});

  @override
  State<FacultyRequestsScreen> createState() => _FacultyRequestsScreenState();
}

class _FacultyRequestsScreenState extends State<FacultyRequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _rejectionReasonController = TextEditingController();

  List<FacultyAccountRequestModel> _allRequests = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _rejectionReasonController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    final requests = await FacultyRequestService().fetchRequests(statusFilter: 'ALL');
    if (!mounted) return;
    setState(() {
      _allRequests = requests;
      _isLoading = false;
    });
  }

  List<FacultyAccountRequestModel> _filteredRequests(String statusFilter) {
    return _allRequests.where((req) {
      final matchesStatus = (statusFilter == 'ALL') || (req.status.toUpperCase() == statusFilter.toUpperCase());
      final matchesSearch = _searchQuery.isEmpty ||
          req.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          req.employeeId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          req.department.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  Future<void> _handleApprove(FacultyAccountRequestModel request) async {
    final adminId = SessionManager().currentUserId ?? 'ADMIN';
    final result = await FacultyRequestService().approveRequest(
      requestId: request.id,
      adminId: adminId,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faculty account approved successfully.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _loadRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Approval failed'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleReject(FacultyAccountRequestModel request) async {
    _rejectionReasonController.clear();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reject Faculty Request', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to reject the request for ${request.fullName} (${request.employeeId})?'),
            const SizedBox(height: 14),
            const Text('Reason for rejection (optional):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
            const SizedBox(height: 6),
            TextField(
              controller: _rejectionReasonController,
              decoration: InputDecoration(
                hintText: 'Enter reason for rejection...',
                filled: true,
                fillColor: AppColors.lightBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Confirm Reject'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final adminId = SessionManager().currentUserId ?? 'ADMIN';
    final result = await FacultyRequestService().rejectRequest(
      requestId: request.id,
      adminId: adminId,
      reason: _rejectionReasonController.text,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faculty request rejected.'),
          backgroundColor: Colors.deepOrange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _loadRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Faculty Account Requests'),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.gold),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.white.withValues(alpha: 0.7),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Field Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search by faculty name, ID, or department...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryPurple),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.2)),
                ),
              ),
            ),
          ),

          // Tab Bar Views
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple))
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRequestList(_filteredRequests('ALL')),
                      _buildRequestList(_filteredRequests('PENDING')),
                      _buildRequestList(_filteredRequests('APPROVED')),
                      _buildRequestList(_filteredRequests('REJECTED')),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<FacultyAccountRequestModel> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: AppColors.secondaryText.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text(
              'No faculty requests found',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestCard(request);
      },
    );
  }

  Widget _buildRequestCard(FacultyAccountRequestModel request) {
    Color statusColor;
    IconData statusIcon;

    switch (request.status.toUpperCase()) {
      case 'APPROVED':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'REJECTED':
        statusColor = Colors.redAccent;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_top_rounded;
    }

    final isPending = request.status.toUpperCase() == 'PENDING';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Top Row: Name & Status Tag
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.fullName,
                    style: const TextStyle(
                      color: AppColors.primaryPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        request.status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Designation & Department
            Text(
              '${request.designation} • ${request.department}',
              style: const TextStyle(color: AppColors.darkText, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Details Grid
            _buildDetailRow(Icons.badge_outlined, 'Employee ID', request.employeeId),
            const SizedBox(height: 4),
            _buildDetailRow(Icons.account_circle_outlined, 'Username', request.username),
            const SizedBox(height: 4),
            _buildDetailRow(Icons.email_outlined, 'Email', request.email),
            const SizedBox(height: 4),
            _buildDetailRow(Icons.phone_outlined, 'Phone', request.phone),
            const SizedBox(height: 4),
            _buildDetailRow(Icons.calendar_today_outlined, 'Requested On', '${request.requestedAt.day}/${request.requestedAt.month}/${request.requestedAt.year}'),

            if (request.rejectionReason != null && request.rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: 6),
              _buildDetailRow(Icons.info_outline, 'Rejection Reason', request.rejectionReason!),
            ],

            // Approve / Reject Action Buttons for PENDING Requests
            if (isPending) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _handleReject(request),
                      icon: const Icon(Icons.close_rounded, size: 18, color: Colors.redAccent),
                      label: const Text('REJECT', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleApprove(request),
                      icon: const Icon(Icons.check_rounded, size: 18, color: AppColors.white),
                      label: const Text('APPROVE', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.secondaryText),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.darkText, fontSize: 12, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
