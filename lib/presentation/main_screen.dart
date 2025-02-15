import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/providers/task_providers.dart';
import 'package:task_manager/data/providers/theme_provider.dart';
import 'package:task_manager/presentation/home_screen.dart';
import 'package:task_manager/presentation/task_details.dart';
import 'package:task_manager/utils/constants.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Widget? secondayScreen;
  bool isTablet = false;

  @override
  void initState() {
    // secondayScreen = getEmptySecondaryScreen();
    super.initState();
  }

  void updateTheme() {
    ref.read(themeProvider.notifier).toggleTheme();
  }

  Widget getEmptySecondaryScreen() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Center(
        child: Text(
          "Select any option",
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium!.color),
        ),
      ),
    );
  }

  void setSecondaryScreen(Task? task, bool isTab, {bool isDefault = false}) {
    setState(() {
      if (isDefault) {
        secondayScreen = getEmptySecondaryScreen();
      } else {
        secondayScreen = TaskDetails(
          isTab: isTablet,
          task: task,
          onSave: () {
            setSecondaryScreen(task, isTab, isDefault: true);
          },
        );
      }
    });
  }

  void onTaskDetails(Task? task) async {
    if (isTablet) {
      // setState(() {
        //     secondayScreen = StatefulBuilder(
        //   builder: (context, setInnerState) {
        //     return TaskDetails(
        //       isTab: isTablet,
        //       task: task,
        //       onSave: () {
        //         setInnerState(() {
        //           secondayScreen = getEmptySecondaryScreen();
        //         });
        //       },
        //     );
        //   },
        // );
        setSecondaryScreen(task, isTablet);
      // });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TaskDetails(
            isTab: isTablet,
            task: task,
            onSave: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    secondayScreen ??= getEmptySecondaryScreen();
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        isTablet = constraints.maxWidth >= 600;

        return isTablet ? _buildTabletView() : _buildMobileView();
      },
    );
  }

  Widget _buildTabletView() {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: HomeScreen(
              onTaskSave: onTaskDetails,
              changeTheme: updateTheme,
            )),
        Expanded(
          flex: 3,
          child: secondayScreen!,
        ),
      ],
    );
  }

  Widget _buildMobileView() {
    return HomeScreen(
      onTaskSave: onTaskDetails,
      changeTheme: updateTheme,
    );
  }
}
