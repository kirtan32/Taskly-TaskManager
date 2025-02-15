import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_manager/utils/constants.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {},
    );

    // final androidImplementation =
    //     _notificationsPlugin.resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>();
    // if (androidImplementation != null) {
    //   final bool? granted =
    //       await androidImplementation.requestNotificationsPermission();
    //   if (granted == false) {
    //     showToastMessage("Notification permission denied!");
    //   }
    // }
  }

  static Future<bool> requestPermission() async {
    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    return granted ?? false;
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {

    bool hasPermission = await requestPermission();
    if (!hasPermission) {
      return;
    }

    final now = DateTime.now();
    final scheduledTime = scheduledDate.subtract(const Duration(minutes: 30));

    if (scheduledTime.isBefore(now)) {
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

}
