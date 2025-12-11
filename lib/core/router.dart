import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/attendance/screens/home_screen.dart';
import '../features/attendance/screens/attendance_screen.dart';
import '../features/schedule/screens/schedule_screen.dart';
import '../features/payroll/screens/payroll_screen.dart';
import '../features/payroll/screens/payslip_detail_screen.dart';
import '../features/payroll/models/payslip.dart';
import '../features/profile/screens/profile_screen.dart';
import 'main_scaffold.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter routerConfig(BuildContext context) {
  final authProvider = context.watch<AuthProvider>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isAuthenticated = authProvider.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }
      if (isAuthenticated && isLoginRoute) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/attendance',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const AttendanceScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/schedule',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ScheduleScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: '/payroll',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const PayrollScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
            routes: [
              GoRoute(
                path: 'details',
                 pageBuilder: (context, state) {
                  final payslip = state.extra as Payslip;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: PayslipDetailScreen(payslip: payslip),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
        ],
      ),
    ],
  );
}
