import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../models/fee_payment.dart';
import '../../../../services/mock_fee_service.dart';
import 'parent_fee_receipt_screen.dart';

class ParentFeePaymentScreen extends StatefulWidget {
  final String studentId;

  const ParentFeePaymentScreen({
    super.key,
    this.studentId = 'STU001',
  });

  @override
  State<ParentFeePaymentScreen> createState() => _ParentFeePaymentScreenState();
}

class _ParentFeePaymentScreenState extends State<ParentFeePaymentScreen> {
  late FeePaymentRecord _feeRecord;

  @override
  void initState() {
    super.initState();
    _loadFeeRecord();
  }

  void _loadFeeRecord() {
    setState(() {
      _feeRecord = MockFeeService().getFeeRecord(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPending = _feeRecord.pendingAmount > 0;
    final formattedDueDate =
        '${_feeRecord.dueDate.day} ${_monthName(_feeRecord.dueDate.month)} ${_feeRecord.dueDate.year}';

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Student Fee Payment',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Student Info Details Card
              _buildStudentDetailsCard(),

              const SizedBox(height: 20),

              // 2. Fee Summary Card
              _buildFeeSummaryCard(isPending, formattedDueDate),

              const SizedBox(height: 24),

              // 3. Payment History Section
              const Text(
                'PAYMENT HISTORY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              _buildPaymentHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  // --- STUDENT DETAILS CARD ---
  Widget _buildStudentDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.1),
                child: const Icon(Icons.school, color: AppColors.primaryPurple, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _feeRecord.studentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                    Text(
                      'Reg No: ${_feeRecord.registerNo}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _feeRecord.academicYear,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem('Department', _feeRecord.department),
              _buildDetailItem('Year', _feeRecord.year),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }

  // --- FEE SUMMARY CARD ---
  Widget _buildFeeSummaryCard(bool isPending, String formattedDueDate) {
    final statusColor = _getStatusColor(_feeRecord.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STUDENT FEE DETAILS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondaryText,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _feeRecord.status.displayName,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total Fees, Paid, Pending Grid
          Row(
            children: [
              Expanded(
                child: _buildAmountTile(
                  'Total Fees',
                  '₹${_feeRecord.totalFees.toStringAsFixed(0)}',
                  AppColors.primaryPurple,
                ),
              ),
              Expanded(
                child: _buildAmountTile(
                  'Paid',
                  '₹${_feeRecord.paidAmount.toStringAsFixed(0)}',
                  Colors.green.shade700,
                ),
              ),
              Expanded(
                child: _buildAmountTile(
                  'Pending',
                  '₹${_feeRecord.pendingAmount.toStringAsFixed(0)}',
                  isPending ? Colors.orange.shade900 : Colors.green.shade700,
                  isHighlight: isPending,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.event, size: 16, color: AppColors.secondaryText),
              const SizedBox(width: 6),
              Text(
                'Due Date: ',
                style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
              ),
              Text(
                formattedDueDate,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Button
          if (isPending)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showPaymentConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'PAY ₹${_feeRecord.pendingAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.green.shade700, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    '✓ Fees Fully Paid',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmountTile(String label, String amount, Color color,
      {bool isHighlight = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isHighlight ? color.withValues(alpha: 0.1) : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(10),
        border: isHighlight ? Border.all(color: color.withValues(alpha: 0.3)) : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.secondaryText, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // --- PAYMENT HISTORY LIST ---
  Widget _buildPaymentHistoryList() {
    if (_feeRecord.history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No payment history records found.',
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
        ),
      );
    }

    return Column(
      children: _feeRecord.history.map((txn) {
        final isSuccess = txn.status == 'SUCCESS';
        final formattedTxnDate =
            '${txn.date.day} ${_monthName(txn.date.month)} ${txn.date.year}';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.08)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                color: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                size: 22,
              ),
            ),
            title: Text(
              '₹${txn.amount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.primaryPurple,
              ),
            ),
            subtitle: Text(
              '$formattedTxnDate • ${txn.transactionId}',
              style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isSuccess ? '✓ Paid' : 'Failed',
                    style: TextStyle(
                      color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isSuccess) ...[
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.receipt_long_rounded, color: AppColors.primaryPurple, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ParentFeeReceiptScreen(
                            feeRecord: _feeRecord,
                            transaction: txn,
                          ),
                        ),
                      );
                    },
                    tooltip: 'View Receipt',
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- PAYMENT CONFIRMATION DIALOG ---
  void _showPaymentConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.payment, color: AppColors.primaryPurple),
            ),
            const SizedBox(width: 10),
            const Text(
              'CONFIRM FEE PAYMENT',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 8),
            _buildDialogRow('Student', _feeRecord.studentName),
            _buildDialogRow('Register No', _feeRecord.registerNo),
            _buildDialogRow('Academic Year', _feeRecord.academicYear),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildDialogRow(
              'Pending Fee',
              '₹${_feeRecord.pendingAmount.toStringAsFixed(0)}',
              isBold: true,
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PAYABLE AMOUNT',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primaryPurple),
                  ),
                  Text(
                    '₹${_feeRecord.pendingAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _startDemoPaymentFlow();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('PROCEED TO PAYMENT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- DEMO PAYMENT PROCESSING FLOW ---
  void _startDemoPaymentFlow() {
    bool simulateSuccess = true;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(color: AppColors.primaryPurple),
                  const SizedBox(height: 20),
                  const Text(
                    'Processing Secure Payment...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Please do not close or refresh this page.',
                    style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Testing Mode Toggle for Demo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Simulation Mode: ', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                      ChoiceChip(
                        label: const Text('Success', style: TextStyle(fontSize: 10)),
                        selected: simulateSuccess,
                        selectedColor: Colors.green.shade100,
                        onSelected: (val) {
                          setModalState(() => simulateSuccess = true);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Simulate Fail', style: TextStyle(fontSize: 10)),
                        selected: !simulateSuccess,
                        selectedColor: Colors.red.shade100,
                        onSelected: (val) {
                          setModalState(() => simulateSuccess = false);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await MockFeeService().processDemoPayment(
                          studentId: widget.studentId,
                          amountToPay: _feeRecord.pendingAmount,
                          simulateSuccess: simulateSuccess,
                        );

                        if (context.mounted) {
                          Navigator.pop(modalCtx);
                          if (result.success) {
                            _loadFeeRecord();
                            _showPaymentSuccessDialog(result);
                          } else {
                            _loadFeeRecord();
                            _showPaymentFailedDialog(result.errorMessage);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'CONFIRM TRANSACTION',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- PAYMENT SUCCESS DIALOG ---
  void _showPaymentSuccessDialog(PaymentResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded, color: Colors.green.shade700, size: 54),
            ),
            const SizedBox(height: 14),
            Text(
              '✓ PAYMENT SUCCESSFUL',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Colors.green.shade800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Payment of ₹${_feeRecord.paidAmount.toStringAsFixed(0)} was successfully completed.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildDialogRow('Transaction ID', result.transactionId ?? 'N/A'),
            _buildDialogRow('Student', _feeRecord.studentName),
            _buildDialogRow('New Pending', '₹0', isBold: true),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryPurple),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('CLOSE', style: TextStyle(color: AppColors.primaryPurple, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      final latestTxn = result.record?.history.first;
                      if (latestTxn != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ParentFeeReceiptScreen(
                              feeRecord: _feeRecord,
                              transaction: latestTxn,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('VIEW RECEIPT', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- PAYMENT FAILED DIALOG ---
  void _showPaymentFailedDialog(String? errorMsg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cancel_rounded, color: Colors.red.shade700, size: 54),
            ),
            const SizedBox(height: 14),
            Text(
              'PAYMENT FAILED',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Colors.red.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMsg ?? 'Your fee payment could not be completed. Please try again.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('TRY AGAIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: AppColors.primaryPurple,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(FeeStatus status) {
    switch (status) {
      case FeeStatus.paid:
        return Colors.green.shade700;
      case FeeStatus.pending:
        return Colors.orange.shade900;
      case FeeStatus.partiallyPaid:
        return Colors.blue.shade700;
      case FeeStatus.overdue:
        return Colors.red.shade700;
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
