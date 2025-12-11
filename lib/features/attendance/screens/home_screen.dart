import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/attendance_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final attendanceProvider = context.watch<AttendanceProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.name ?? 'Employee',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${user?.department ?? ''} • ${user?.role ?? ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutQuart,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        DateFormat('h:mm a').format(DateTime.now()),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Time In',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                attendanceProvider
                                        .todayRecord
                                        ?.formattedTimeIn ??
                                    '--',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          Column(
                            children: [
                              Text(
                                'Time Out',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                attendanceProvider
                                        .todayRecord
                                        ?.formattedTimeOut ??
                                    '--',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: attendanceProvider.isClockedIn
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          attendanceProvider.isClockedIn
                              ? 'Clocked In'
                              : 'Not Clocked In',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: attendanceProvider.isClockedIn
                                    ? Colors.green[700]
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Overview', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green[600],
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${attendanceProvider.daysPresent}',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            Text(
                              'Days Present',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.orange[600],
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${attendanceProvider.daysLate}',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            Text(
                              'Days Late',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.red[600],
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${attendanceProvider.daysAbsent}',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            Text(
                              'Days Absent',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.blue[600],
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${attendanceProvider.totalHoursWorked}h',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            Text(
                              'Total Hours',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
