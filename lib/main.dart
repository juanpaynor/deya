import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/attendance/providers/attendance_provider.dart';
import 'features/schedule/providers/schedule_provider.dart';
import 'features/payroll/providers/payroll_provider.dart';

void main() {
  runApp(const DeyaApp());
}

class DeyaApp extends StatelessWidget {
  const DeyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => PayrollProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Deya',
            theme: AppTheme.lightTheme,
            routerConfig: routerConfig(context),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
