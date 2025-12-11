import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/shift.dart';
import '../providers/schedule_provider.dart';
import '../widgets/timesheet_row.dart';
import '../../attendance/providers/attendance_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScrollController _headerScrollController = ScrollController();
  DateTime _selectedWeekStart = DateTime.now();

  DateTime get _startOfWeek {
    final date = _selectedWeekStart;
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _previousWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.add(const Duration(days: 7));
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedWeekStart,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedWeekStart = picked;
      });
    }
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final startOfWeek = _startOfWeek;
    final weekShifts = scheduleProvider.getShiftsForWeek(startOfWeek);

    final groupedShifts = <DateTime, List<Shift>>{};
    for (var shift in weekShifts) {
      final dateKey = DateTime(
        shift.date.year,
        shift.date.month,
        shift.date.day,
      );
      if (!groupedShifts.containsKey(dateKey)) {
        groupedShifts[dateKey] = [];
      }
      groupedShifts[dateKey]!.add(shift);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Schedule'), elevation: 0),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousWeek,
                  color: Theme.of(context).colorScheme.primary,
                ),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d, y').format(startOfWeek.add(const Duration(days: 6)))}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextWeek,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            height: 50,
            color: const Color(0xFF34495E),
            child: Row(
              children: [
                Container(
                  width: 86,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Date',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _headerScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(24, (index) {
                        return Container(
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            index == 0
                                ? '12 AM'
                                : index == 12
                                ? '12 PM'
                                : index < 12
                                ? '$index AM'
                                : '${index - 12} PM',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: groupedShifts.length,
              itemBuilder: (context, index) {
                final date = groupedShifts.keys.elementAt(index);
                final shifts = groupedShifts[date]!;
                // Better: move provider access outside loop if possible, or use select
                final attendanceRecord = context
                    .watch<AttendanceProvider>()
                    .getRecordForDate(date);

                return TimesheetRow(
                  date: date,
                  shifts: shifts,
                  attendance: attendanceRecord,
                  headerScrollController: _headerScrollController,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
