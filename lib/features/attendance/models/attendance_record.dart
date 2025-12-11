class AttendanceRecord {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final String status;
  final int? durationMinutes;

  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.date,
    this.timeIn,
    this.timeOut,
    required this.status,
    this.durationMinutes,
  });

  String get formattedDate {
    return '${date.month}/${date.day}/${date.year}';
  }

  String get formattedTimeIn {
    if (timeIn == null) return '--';
    final hour = timeIn!.hour > 12 ? timeIn!.hour - 12 : timeIn!.hour;
    final period = timeIn!.hour >= 12 ? 'PM' : 'AM';
    final minute = timeIn!.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String get formattedTimeOut {
    if (timeOut == null) return '--';
    final hour = timeOut!.hour > 12 ? timeOut!.hour - 12 : timeOut!.hour;
    final period = timeOut!.hour >= 12 ? 'PM' : 'AM';
    final minute = timeOut!.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String get formattedDuration {
    if (durationMinutes == null) return '--';
    final hours = durationMinutes! ~/ 60;
    final minutes = durationMinutes! % 60;
    return '${hours}h ${minutes}m';
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      timeIn: json['timeIn'] != null
          ? DateTime.parse(json['timeIn'] as String)
          : null,
      timeOut: json['timeOut'] != null
          ? DateTime.parse(json['timeOut'] as String)
          : null,
      status: json['status'] as String,
      durationMinutes: json['durationMinutes'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'timeIn': timeIn?.toIso8601String(),
      'timeOut': timeOut?.toIso8601String(),
      'status': status,
      'durationMinutes': durationMinutes,
    };
  }
}
