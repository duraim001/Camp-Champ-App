import '../models/fee_payment.dart';

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final FeePaymentRecord? record;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.errorMessage,
    this.record,
  });
}

class MockFeeService {
  static final MockFeeService _instance = MockFeeService._internal();
  factory MockFeeService() => _instance;
  MockFeeService._internal() {
    _initDemoData();
  }

  late FeePaymentRecord _demoRecord;

  void _initDemoData() {
    _demoRecord = FeePaymentRecord(
      id: 'FEE-2026-001',
      studentId: 'STU001',
      studentName: 'Rahul Kumar',
      registerNo: 'SEC2026001',
      department: 'Computer Science & Engineering',
      year: '2nd Year',
      academicYear: '2026–2027',
      totalFees: 50000.0,
      paidAmount: 35000.0,
      pendingAmount: 15000.0,
      dueDate: DateTime(2026, 9, 30),
      status: FeeStatus.pending,
      history: [
        PaymentTransaction(
          transactionId: 'TXN202606159821',
          amount: 20000.0,
          date: DateTime(2026, 6, 15),
          status: 'SUCCESS',
          paymentMethod: 'UPI / Online Banking',
        ),
        PaymentTransaction(
          transactionId: 'TXN202608204412',
          amount: 15000.0,
          date: DateTime(2026, 8, 20),
          status: 'SUCCESS',
          paymentMethod: 'Debit Card',
        ),
      ],
    );
  }

  FeePaymentRecord getFeeRecord(String studentId) {
    return _demoRecord;
  }

  Future<PaymentResult> processDemoPayment({
    required String studentId,
    required double amountToPay,
    required bool simulateSuccess,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!simulateSuccess) {
      final failedTxn = PaymentTransaction(
        transactionId: 'TXN-FAIL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        amount: amountToPay,
        date: DateTime.now(),
        status: 'FAILED',
        paymentMethod: 'Demo Payment Gateway',
      );
      final updatedHistory = [failedTxn, ..._demoRecord.history];
      _demoRecord = _demoRecord.copyWith(history: updatedHistory);

      return PaymentResult(
        success: false,
        errorMessage: 'Payment could not be completed by your bank. Please try again.',
        record: _demoRecord,
      );
    }

    final newTxnId = 'TXN202608${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final newPaid = _demoRecord.paidAmount + amountToPay;
    final newPending = (_demoRecord.totalFees - newPaid).clamp(0.0, double.infinity);
    final newStatus = newPending <= 0 ? FeeStatus.paid : FeeStatus.partiallyPaid;

    final successTxn = PaymentTransaction(
      transactionId: newTxnId,
      amount: amountToPay,
      date: DateTime.now(),
      status: 'SUCCESS',
      paymentMethod: 'Demo Secure Gateway',
    );

    _demoRecord = _demoRecord.copyWith(
      paidAmount: newPaid,
      pendingAmount: newPending,
      status: newStatus,
      history: [successTxn, ..._demoRecord.history],
    );

    return PaymentResult(
      success: true,
      transactionId: newTxnId,
      record: _demoRecord,
    );
  }
}
