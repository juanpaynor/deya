import 'package:flutter/foundation.dart';
import '../models/shift.dart';

class ScheduleProvider with ChangeNotifier {
  List<Shift> _shifts = [];
  DateTime _selectedDate = DateTime.now();

  List<Shift> get shifts => _shifts;
  DateTime get selectedDate => _selectedDate;

  ScheduleProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    _shifts = [];

    for (int i = 0; i < 14; i++) {
      final date = startOfWeek.add(Duration(days: i));

      if (date.weekday == DateTime.sunday) {
        continue;
      }

      if (i == 6 || i == 7) {
        _shifts.add(
          Shift(
            id: 'shift_${i}_1',
            userId: '1',
            date: date,
            startTime: DateTime(date.year, date.month, date.day, 0, 0),
            endTime: DateTime(date.year, date.month, date.day, 23, 59),
            type: ShiftType.absence,
          ),
        );
        continue;
      }

      if (i == 3) {
        _shifts.add(
          Shift(
            id: 'shift_${i}_1',
            userId: '1',
            date: date,
            startTime: DateTime(date.year, date.month, date.day, 10, 0),
            endTime: DateTime(date.year, date.month, date.day, 12, 0),
            type: ShiftType.late,
          ),
        );
        _shifts.add(
          Shift(
            id: 'shift_${i}_2',
            userId: '1',
            date: date,
            startTime: DateTime(date.year, date.month, date.day, 13, 0),
            endTime: DateTime(date.year, date.month, date.day, 18, 0),
            type: ShiftType.regular,
          ),
        );
      } else if (i == 5) {
        _shifts.add(
          Shift(
            id: 'shift_${i}_1',
            userId: '1',
            date: date,
            startTime: DateTime(date.year, date.month, date.day, 8, 0),
            endTime: DateTime(date.year, date.month, date.day, 12, 0),
            type: ShiftType.regular,
          ),
        );
        _shifts.add(
          Shift(
            id: 'shift_${i}_2',
            userId: '1',
            date: date,
            startTime: DateTime(date.year, date.month, date.day, 13, 0),
            endTime: DateTime(date.year, date.month, date.day, 16, 0),
            type: ShiftType.late,
          ),
        );
      } else if (i == 8 || i == 9) {
        _shifts.add(
          Shift(
            id: 'shift_${i}_1',
            userId: '1',
            date: date,
            startTime: DateTime(date.year, date.month, date.day, 0, 0),
            endTime: DateTime(date.year, date.month, date.day, 23, 59),
            type: ShiftType.leave,
          ),
        );
      } else {
        _shifts.add(
          Shift(
            id: 'shift_${i}_1',
            userId: '1',
            date: date,
            startTime: DateTime(date.year, date.month, date.day, 8, 0),
            endTime: DateTime(date.year, date.month, date.day, 12, 0),
            type: ShiftType.regular,
          ),
        );
        _shifts.add(
          Shift(
            id: 'shift_${i}_2',
            userId: '1',
            date: date,
            startTime: DateTime(date.year, date.month, date.day, 13, 0),
            endTime: DateTime(date.year, date.month, date.day, 17, 0),
            type: ShiftType.regular,
          ),
        );
      }
    }
  }

  List<Shift> getShiftsForDate(DateTime date) {
    return _shifts.where((shift) {
      return shift.date.year == date.year &&
          shift.date.month == date.month &&
          shift.date.day == date.day;
    }).toList();
  }

  List<Shift> getShiftsForWeek(DateTime startDate) {
    final endDate = startDate.add(const Duration(days: 7));
    return _shifts.where((shift) {
      return shift.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          shift.date.isBefore(endDate);
    }).toList();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  int get totalAbsences {
    return _shifts.where((s) => s.type == ShiftType.absence).length;
  }

  int get totalLate {
    return _shifts.where((s) => s.type == ShiftType.late).length;
  }

  double get totalRegularHours {
    return _shifts.where((s) => s.type == ShiftType.regular).fold(0.0, (
      sum,
      shift,
    ) {
      return sum + shift.endTime.difference(shift.startTime).inMinutes / 60;
    });
  }
}
