import 'package:flutter/material.dart';

enum ShiftType { regular, absence, late, breakTime, leave, forApproval }

class Shift {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final ShiftType type;
  final String? notes;

  Shift({
    required this.id,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.notes,
  });

  Color get color {
    switch (type) {
      case ShiftType.regular:
        return const Color(0xFF4A90A4);
      case ShiftType.absence:
        return const Color(0xFFE74C3C);
      case ShiftType.late:
        return const Color(0xFFF39C12);
      case ShiftType.breakTime:
        return const Color(0xFF95A5A6);
      case ShiftType.leave:
        return const Color(0xFFE8A5B5);
      case ShiftType.forApproval:
        return const Color(0xFF81C784);
    }
  }

  String get typeLabel {
    switch (type) {
      case ShiftType.regular:
        return 'Regular';
      case ShiftType.absence:
        return 'Absence';
      case ShiftType.late:
        return 'Late/Undertime';
      case ShiftType.breakTime:
        return 'Break';
      case ShiftType.leave:
        return 'Leave';
      case ShiftType.forApproval:
        return 'For Approval';
    }
  }

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      type: ShiftType.values[json['type'] as int],
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'type': type.index,
      'notes': notes,
    };
  }
}
