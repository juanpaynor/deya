import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/shift.dart';
import '../../attendance/models/attendance_record.dart';

class TimesheetRow extends StatelessWidget {
  final DateTime date;
  final List<Shift> shifts;
  final AttendanceRecord? attendance;
  final ScrollController headerScrollController;

  const TimesheetRow({
    super.key,
    required this.date,
    required this.shifts,
    this.attendance,
    required this.headerScrollController,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEE').format(date);
    final dateStr = DateFormat('MMM d').format(date);
    final isToday =
        DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    return Container(
      decoration: BoxDecoration(
        color: isToday
            ? const Color(0xFFFFF8E1)
            : isWeekend
            ? const Color(0xFFF5F5F5)
            : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 86,
            height:
                150, // Increased height to accommodate time track details if needed, but flex is better
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SingleChildScrollView(
                  controller: headerScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    width: 24 * 80,
                    height: 64,
                    decoration: const BoxDecoration(),
                    child: Stack(
                      children: [
                        Row(
                          children: List.generate(24, (index) {
                            return Container(
                              width: 80,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        ...shifts.map((shift) => _buildShiftBlock(shift)),
                      ],
                    ),
                  ),
                ),
                if (shifts.isNotEmpty)
                  _buildTimeTrackDetails(context, shifts.first),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTrackDetails(BuildContext context, Shift shift) {
    // Basic calculations
    final plannedStart = shift.startTime;
    final plannedEnd = shift.endTime;

    // Default values if no attendance
    String timeInStr = '--:--';
    String timeOutStr = '--:--';
    String earlyInStr = '--';
    String earlyOutStr = '--';
    String overTimeStr = '--';
    String underTimeStr = '--';

    if (attendance != null && attendance!.timeIn != null) {
      final actualStart = attendance!.timeIn!;
      timeInStr = DateFormat('h:mm a').format(actualStart);

      // Early In Calculation
      final earlyInMinutes = plannedStart.difference(actualStart).inMinutes;
      if (earlyInMinutes > 0) {
        final h = earlyInMinutes ~/ 60;
        final m = earlyInMinutes % 60;
        earlyInStr = h > 0 ? '${h}h ${m}m' : '${m}m';
      } else {
        earlyInStr = '-';
      }

      if (attendance!.timeOut != null) {
        final actualEnd = attendance!.timeOut!;
        timeOutStr = DateFormat('h:mm a').format(actualEnd);

        // Early Out Calculation
        final earlyOutMinutes = plannedEnd.difference(actualEnd).inMinutes;
        if (earlyOutMinutes > 0) {
          final h = earlyOutMinutes ~/ 60;
          final m = earlyOutMinutes % 60;
          earlyOutStr = h > 0 ? '${h}h ${m}m' : '${m}m';
        } else {
          earlyOutStr = '-';
        }

        // Duration calculations
        final plannedDuration = plannedEnd.difference(plannedStart).inMinutes;
        final actualDuration = attendance!.durationMinutes ?? 0;

        // Overtime (Simple logic: Actual > Planned)
        if (actualDuration > plannedDuration) {
          final diff = actualDuration - plannedDuration;
          final h = diff ~/ 60;
          final m = diff % 60;
          overTimeStr = h > 0 ? '${h}h ${m}m' : '${m}m';
          underTimeStr = '-';
        }
        // Undertime (Simple logic: Actual < Planned)
        else if (actualDuration < plannedDuration) {
          final diff = plannedDuration - actualDuration;
          final h = diff ~/ 60;
          final m = diff % 60;
          underTimeStr = h > 0 ? '${h}h ${m}m' : '${m}m';
          overTimeStr = '-';
        } else {
          overTimeStr = '-';
          underTimeStr = '-';
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _buildDetailItem(context, 'Time In', timeInStr, icon: Icons.login),
          _buildDetailItem(context, 'Time Out', timeOutStr, icon: Icons.logout),
          _buildDetailItem(
            context,
            'Early In',
            earlyInStr,
            valueColor: earlyInStr != '-' && earlyInStr != '--'
                ? Colors.green
                : null,
          ),
          _buildDetailItem(
            context,
            'Early Out',
            earlyOutStr,
            valueColor: earlyOutStr != '-' && earlyOutStr != '--'
                ? Colors.orange
                : null,
          ),
          _buildDetailItem(
            context,
            'Overtime',
            overTimeStr,
            valueColor: overTimeStr != '-' && overTimeStr != '--'
                ? Colors.blue
                : null,
          ),
          _buildDetailItem(
            context,
            'Undertime',
            underTimeStr,
            valueColor: underTimeStr != '-' && underTimeStr != '--'
                ? Colors.red
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: Colors.grey.shade600),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: valueColor ?? Colors.grey.shade900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildShiftBlock(Shift shift) {
    final startHour = shift.startTime.hour + shift.startTime.minute / 60;
    final endHour = shift.endTime.hour + shift.endTime.minute / 60;
    final duration = endHour - startHour;

    final leftPosition = startHour * 80.0;
    final width = duration * 80.0;

    return Positioned(
      left: leftPosition,
      width: width.clamp(40.0, double.infinity),
      top: 8,
      bottom: 8,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [shift.color, shift.color.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: shift.color.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (shift.type != ShiftType.absence &&
                  shift.type != ShiftType.leave)
                Text(
                  DateFormat('h:mm a').format(shift.startTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                shift.typeLabel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
