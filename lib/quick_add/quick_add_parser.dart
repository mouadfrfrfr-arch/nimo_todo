import 'package:flutter/material.dart';

class QuickAddResult {
  final String title;
  final DateTime? dueAt;
  final int? remindMinutesBefore;

  const QuickAddResult({
    required this.title,
    required this.dueAt,
    required this.remindMinutesBefore,
  });
}

class QuickAddParser {
  /// Very small, local-only parser.
  /// Supports:
  /// - tomorrow / today
  /// - in 2h / in 30m
  /// - time: 9am, 9:30, 21:15
  /// - reminder tokens: rm 10m / rm 30m / rm 1h / remind 15m
  static QuickAddResult parse(String input, {DateTime? now}) {
    final n = now ?? DateTime.now();
    var text = input.trim();

    int? remindMinutes;
    final rm = RegExp(r'(?:\brm\b|\bremind\b|\breminder\b)\s*(\d+)\s*([mh])', caseSensitive: false);
    final rmMatch = rm.firstMatch(text);
    if (rmMatch != null) {
      final value = int.tryParse(rmMatch.group(1) ?? '');
      final unit = (rmMatch.group(2) ?? '').toLowerCase();
      if (value != null) {
        remindMinutes = unit == 'h' ? value * 60 : value;
      }
      text = text.replaceRange(rmMatch.start, rmMatch.end, '').trim();
    }

    DateTime? date;
    if (RegExp(r'\btomorrow\b', caseSensitive: false).hasMatch(text)) {
      final d = n.add(const Duration(days: 1));
      date = DateTime(d.year, d.month, d.day);
      text = text.replaceAll(RegExp(r'\btomorrow\b', caseSensitive: false), '').trim();
    } else if (RegExp(r'\btoday\b', caseSensitive: false).hasMatch(text)) {
      date = DateTime(n.year, n.month, n.day);
      text = text.replaceAll(RegExp(r'\btoday\b', caseSensitive: false), '').trim();
    }

    final inRel = RegExp(r'\bin\b\s*(\d+)\s*([mh])', caseSensitive: false);
    final inRelMatch = inRel.firstMatch(text);
    if (inRelMatch != null) {
      final value = int.tryParse(inRelMatch.group(1) ?? '');
      final unit = (inRelMatch.group(2) ?? '').toLowerCase();
      if (value != null) {
        final due = unit == 'h' ? n.add(Duration(hours: value)) : n.add(Duration(minutes: value));
        text = text.replaceRange(inRelMatch.start, inRelMatch.end, '').trim();
        return QuickAddResult(title: _cleanTitle(text), dueAt: due, remindMinutesBefore: remindMinutes);
      }
    }

    // Time (9am / 9:30am / 21:15)
    TimeOfDay? time;
    final timeRe = RegExp(r'\b(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b', caseSensitive: false);
    final timeMatch = timeRe.firstMatch(text);
    if (timeMatch != null) {
      var h = int.tryParse(timeMatch.group(1) ?? '');
      final m = int.tryParse(timeMatch.group(2) ?? '0') ?? 0;
      final ampm = (timeMatch.group(3) ?? '').toLowerCase();
      if (h != null) {
        if (ampm == 'pm' && h < 12) h += 12;
        if (ampm == 'am' && h == 12) h = 0;
        if (h >= 0 && h <= 23 && m >= 0 && m <= 59) {
          time = TimeOfDay(hour: h, minute: m);
          text = text.replaceRange(timeMatch.start, timeMatch.end, '').trim();
        }
      }
    }

    if (date != null) {
      final t = time ?? const TimeOfDay(hour: 9, minute: 0);
      final due = DateTime(date.year, date.month, date.day, t.hour, t.minute);
      return QuickAddResult(title: _cleanTitle(text), dueAt: due, remindMinutesBefore: remindMinutes);
    }

    // No due date/time found
    return QuickAddResult(title: _cleanTitle(text), dueAt: null, remindMinutesBefore: remindMinutes);
  }

  static String _cleanTitle(String s) {
    final out = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return out.isEmpty ? 'New task' : out;
  }
}
