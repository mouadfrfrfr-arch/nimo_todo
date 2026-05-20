import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _inited = false;

  Future<void> init() async {
    if (_inited) return;

    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    _inited = true;
  }

  Future<bool> requestPermissionsIfNeeded() async {
    // iOS requires explicit permission request
    final ios = _plugin.resolvePlatformSpecificImplementation<DarwinFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final ok = await ios.requestPermissions(alert: true, badge: true, sound: true);
      return ok ?? false;
    }

    // Android (13+) permission is handled by the plugin internally on many setups,
    // but we keep this as a safe no-op.
    return true;
  }

  Future<void> scheduleTaskReminder({
    required int taskId,
    required String title,
    required DateTime when,
  }) async {
    await init();

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_reminders',
        'Task reminders',
        channelDescription: 'Reminders for your tasks',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    final now = DateTime.now();
    if (!when.isAfter(now)) return;

    try {
      await _plugin.zonedSchedule(
        taskId,
        'Reminder',
        title,
        tz.TZDateTime.from(when, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: null,
      );
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('Failed to schedule reminder: $e');
      }
    }
  }

  Future<void> cancelTaskReminder(int taskId) async {
    await init();
    await _plugin.cancel(taskId);
  }
}
