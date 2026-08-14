enum FeeStatus {
  paid,
  pending,
  partiallyPaid,
  overdue,
}

extension FeeStatusExtension on FeeStatus {
  String get displayName {
    switch (this) {
      case FeeStatus.paid:
        return 'PAID';
      case FeeStatus.pending:
        return 'PENDING';
      case FeeStatus.partiallyPaid:
        return 'PARTIALLY PAID';
      case FeeStatus.overdue:
        return 'OVERDUE';
    }
  }
}

class PaymentTransaction {
  final String transactionId;
  final double amount;
  final DateTime date;
  final String status; // 'SUCCESS', 'FAILED', 'PENDING'
  final String paymentMethod;

  PaymentTransaction({
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.status,
    this.paymentMethod = 'Demo Online Payment',
  });
}

class FeePaymentRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String registerNo;
  final String department;
  final String year;
  final String academicYear;
  final double totalFees;
  final double paidAmount;
  final double pendingAmount;
  final DateTime dueDate;
  final FeeStatus status;
  final List<PaymentTransaction> history;

  FeePaymentRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.registerNo,
    required this.department,
    required this.year,
    required this.academicYear,
    required this.totalFees,
    required this.paidAmount,
    required this.pendingAmount,
    required this.dueDate,
    required this.status,
    required this.history,
  });

  FeePaymentRecord copyWith({
    double? paidAmount,
    double? pendingAmount,
    FeeStatus? status,
    List<PaymentTransaction>? history,
  }) {
    return FeePaymentRecord(
      id: id,
      studentId: studentId,
      studentName: studentName,
      registerNo: registerNo,
      department: department,
      year: year,
      academicYear: academicYear,
      totalFees: totalFees,
      paidAmount: paidAmount ?? this.paidAmount,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      dueDate: dueDate,
      status: status ?? this.status,
      history: history ?? this.history,
    );
  }
}
