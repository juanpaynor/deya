import 'package:flutter/foundation.dart';
import '../models/payslip.dart';

class PayrollProvider with ChangeNotifier {
  List<Payslip> _payslips = [];

  List<Payslip> get payslips => _payslips;

  PayrollProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _payslips = [
      Payslip(
        id: 'PAY-001',
        periodStart: 'Nov 16, 2025',
        periodEnd: 'Nov 30, 2025',
        netPay: 25450.00,
        grossPay: 30000.00,
        status: 'Paid',
        earnings: [
          PayItem(label: 'Basic Salary', amount: 25000.00),
          PayItem(label: 'Overtime', amount: 3500.00),
          PayItem(label: 'Allowance', amount: 1500.00),
        ],
        deductions: [
          PayItem(label: 'Tax', amount: 2500.00),
          PayItem(label: 'SSS', amount: 1200.00),
          PayItem(label: 'PhilHealth', amount: 450.00),
          PayItem(label: 'Pag-IBIG', amount: 400.00),
        ],
      ),
      Payslip(
        id: 'PAY-002',
        periodStart: 'Nov 01, 2025',
        periodEnd: 'Nov 15, 2025',
        netPay: 24800.00,
        grossPay: 29000.00,
        status: 'Paid',
        earnings: [
          PayItem(label: 'Basic Salary', amount: 25000.00),
          PayItem(label: 'Overtime', amount: 2500.00),
          PayItem(label: 'Allowance', amount: 1500.00),
        ],
        deductions: [
          PayItem(label: 'Tax', amount: 2200.00),
          PayItem(label: 'SSS', amount: 1200.00),
          PayItem(label: 'PhilHealth', amount: 450.00),
          PayItem(label: 'Pag-IBIG', amount: 350.00),
        ],
      ),
    ];
    notifyListeners();
  }
}
