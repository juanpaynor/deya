class Payslip {
  final String id;
  final String periodStart;
  final String periodEnd;
  final double netPay;
  final double grossPay;
  final List<PayItem> earnings;
  final List<PayItem> deductions;
  final String status; // 'Paid', 'Processing'

  Payslip({
    required this.id,
    required this.periodStart,
    required this.periodEnd,
    required this.netPay,
    required this.grossPay,
    required this.earnings,
    required this.deductions,
    required this.status,
  });
}

class PayItem {
  final String label;
  final double amount;

  PayItem({required this.label, required this.amount});
}
