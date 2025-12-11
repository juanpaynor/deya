import 'package:flutter/foundation.dart';
import '../models/attendance_record.dart';

class AttendanceProvider with ChangeNotifier {
  AttendanceRecord? _todayRecord;
  bool _isClockedIn = false;
  List<AttendanceRecord> _history = [];

  AttendanceRecord? get todayRecord => _todayRecord;
  bool get isClockedIn => _isClockedIn;
  List<AttendanceRecord> get history => _history;

  AttendanceProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final now = DateTime.now();
    _history = [
      AttendanceRecord(
        id: '1',
        userId: '1',
        date: now.subtract(const Duration(days: 1)),
        timeIn: DateTime(now.year, now.month, now.day - 1, 8, 30),
        timeOut: DateTime(now.year, now.month, now.day - 1, 17, 45),
        status: 'Present',
        durationMinutes: 555,
      ),
      AttendanceRecord(
        id: '2',
        userId: '1',
        date: now.subtract(const Duration(days: 2)),
        timeIn: DateTime(now.year, now.month, now.day - 2, 8, 15),
        timeOut: DateTime(now.year, now.month, now.day - 2, 17, 30),
        status: 'Present',
        durationMinutes: 555,
      ),
      AttendanceRecord(
        id: '3',
        userId: '1',
        date: now.subtract(const Duration(days: 3)),
        timeIn: DateTime(now.year, now.month, now.day - 3, 9, 5),
        timeOut: DateTime(now.year, now.month, now.day - 3, 17, 20),
        status: 'Late',
        durationMinutes: 495,
      ),
      AttendanceRecord(
        id: '4',
        userId: '1',
        date: now.subtract(const Duration(days: 4)),
        timeIn: null,
        timeOut: null,
        status: 'Absent',
        durationMinutes: 0,
      ),
      AttendanceRecord(
        id: '5',
        userId: '1',
        date: now.subtract(const Duration(days: 5)),
        timeIn: DateTime(now.year, now.month, now.day - 5, 8, 25),
        timeOut: DateTime(now.year, now.month, now.day - 5, 17, 40),
        status: 'Present',
        durationMinutes: 555,
      ),
    ];
  }

  Future<void> clockIn() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    _todayRecord = AttendanceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '1',
      date: now,
      timeIn: now,
      timeOut: null,
      status: now.hour >= 9 ? 'Late' : 'Present',
      durationMinutes: null,
    );
    _isClockedIn = true;
    notifyListeners();
  }

  Future<void> clockOut() async {
    if (_todayRecord == null) return;

    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final duration = now.difference(_todayRecord!.timeIn!).inMinutes;

    _todayRecord = AttendanceRecord(
      id: _todayRecord!.id,
      userId: _todayRecord!.userId,
      date: _todayRecord!.date,
      timeIn: _todayRecord!.timeIn,
      timeOut: now,
      status: _todayRecord!.status,
      durationMinutes: duration,
    );
    _isClockedIn = false;
    _history.insert(0, _todayRecord!);
    notifyListeners();
  }

  int get totalHoursWorked {
    return _history
            .where((record) => record.durationMinutes != null)
            .fold(0, (sum, record) => sum + record.durationMinutes!) ~/
        60;
  }

  int get daysPresent {
    return _history
        .where(
          (record) => record.status == 'Present' || record.status == 'Late',
        )
        .length;
  }

  int get daysAbsent {
    return _history.where((record) => record.status == 'Absent').length;
  }

  int get daysLate {
    return _history.where((record) => record.status == 'Late').length;
  }

  AttendanceRecord? getRecordForDate(DateTime date) {
    try {
      return _history.firstWhere(
        (record) =>
            record.date.year == date.year &&
            record.date.month == date.month &&
            record.date.day == date.day,
      );
    } catch (e) {
      if (_todayRecord != null &&
          _todayRecord!.date.year == date.year &&
          _todayRecord!.date.month == date.month &&
          _todayRecord!.date.day == date.day) {
        return _todayRecord;
      }
      return null;
    }
  }
}
