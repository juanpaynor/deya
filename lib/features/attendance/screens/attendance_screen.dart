import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('EEEE').format(DateTime.now()),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMMM d, y').format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              
              // Animated Clock Button
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(3), // Border width
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: attendanceProvider.isClockedIn 
                        ? [Colors.green.shade300, Colors.green.shade600]
                        : [Theme.of(context).primaryColor.withValues(alpha: 0.5), Theme.of(context).primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                       BoxShadow(
                        color: (attendanceProvider.isClockedIn ? Colors.green : Theme.of(context).primaryColor).withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ]
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          attendanceProvider.isClockedIn
                              ? Icons.check_circle
                              : Icons.touch_app, // Changed icon for better UX
                          size: 80,
                          color: attendanceProvider.isClockedIn
                              ? Colors.green[600]
                              : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          DateFormat('h:mm a').format(DateTime.now()), // Removed seconds for cleaner look
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                         Text(
                          attendanceProvider.isClockedIn ? 'CLOCKED IN' : 'TAP TO CLOCK IN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.grey[600]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                      if (attendanceProvider.todayRecord?.status != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                attendanceProvider.todayRecord!.status == 'Late'
                                ? Colors.orange.withValues(alpha: 0.1)
                                : Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            attendanceProvider.todayRecord!.status,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color:
                                      attendanceProvider.todayRecord!.status ==
                                          'Late'
                                      ? Colors.orange[700]
                                      : Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (attendanceProvider.isClockedIn) {
                      await attendanceProvider.clockOut();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Clocked out successfully'),
                          ),
                        );
                      }
                    } else {
                      await attendanceProvider.clockIn();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Clocked in successfully'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    attendanceProvider.isClockedIn ? 'Clock Out' : 'Clock In',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
