import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/payroll_provider.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payrollProvider = context.watch<PayrollProvider>();
    final payslips = payrollProvider.payslips;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: payslips.length,
        itemBuilder: (context, index) {
          final payslip = payslips[index];
          // Staggered Animation
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 100)), // Agile Stagger
            curve: Curves.easeOutQuad,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(50 * (1 - value), 0), // Slide from right
                  child: child,
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () {
                  context.push('/payroll/details', extra: payslip);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${payslip.periodStart} - ${payslip.periodEnd}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              payslip.status,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Net Pay',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Hero( // Hero Animation
                        tag: 'netPay-${payslip.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            NumberFormat.currency(symbol: '₱').format(payslip.netPay),
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
