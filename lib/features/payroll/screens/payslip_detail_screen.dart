import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payslip.dart';

class PayslipDetailScreen extends StatelessWidget {
  final Payslip payslip;

  const PayslipDetailScreen({super.key, required this.payslip});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₱');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payslip Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                   Text(
                    'Net Pay',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600]
                    ),
                  ),
                  const SizedBox(height: 8),
                  Hero(
                    tag: 'netPay-${payslip.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        currencyFormat.format(payslip.netPay),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${payslip.periodStart} - ${payslip.periodEnd}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Earnings'),
            ...payslip.earnings.map((item) => _buildPayItemRow(context, item, currencyFormat)),
            const Divider(height: 32),
             _buildTotalRow(context, 'Total Earnings', payslip.grossPay, currencyFormat, isPositive: true),
            const SizedBox(height: 32),
             _buildSectionTitle(context, 'Deductions'),
            ...payslip.deductions.map((item) => _buildPayItemRow(context, item, currencyFormat)),
             const Divider(height: 32),
             _buildTotalRow(context, 'Total Deductions', 
                payslip.grossPay - payslip.netPay, 
                currencyFormat, isPositive: false),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPayItemRow(BuildContext context, PayItem item, NumberFormat format) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.label, style: Theme.of(context).textTheme.bodyLarge),
          Text(format.format(item.amount), style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600
          )),
        ],
      ),
    );
  }

   Widget _buildTotalRow(BuildContext context, String label, double amount, NumberFormat format, {bool isPositive = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text(format.format(amount), style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isPositive ? Colors.green[700] : Colors.red[700],
          )),
        ],
      ),
    );
  }
}
