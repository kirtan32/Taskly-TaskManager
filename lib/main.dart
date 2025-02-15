import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/notification/notification_service.dart';
import 'package:task_manager/presentation/home_screen.dart';
import 'package:task_manager/presentation/main_screen.dart';
import 'package:task_manager/presentation/splash_screen.dart';
import 'package:task_manager/data/providers/theme_provider.dart';
import 'package:task_manager/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotificationService.init();
  runApp(ProviderScope(child: TaskManagerApp()));
}


class TaskManagerApp extends ConsumerWidget {

  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: MainScreen(),
    );
  }
}
