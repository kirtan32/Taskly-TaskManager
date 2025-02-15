import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/db/database_helper.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/notification/notification_service.dart';
import 'package:task_manager/utils/constants.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());

class TaskNotifier extends StateNotifier<List<Task>> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String _searchQuery = '';

  TaskNotifier() : super([]) {
    loadTasks();
  }

  Future<void> loadTasks(
      {bool isAsc = true,
      SortOptions sortOption = SortOptions.createDate,
      String searchQuery = ''}) async {
    // state = await dbHelper.getTasks(sortType: isAsc?SortType.asc:SortType.desc, sortOption: sortOption);

    _searchQuery = searchQuery;

    List<Task> tasks = await dbHelper.getTasks(
      sortType: isAsc ? SortType.asc : SortType.desc,
      sortOption: sortOption,
    );

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      tasks = tasks.where((task) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    state = tasks;
  }

  void searchTasks(String query) {
    loadTasks(searchQuery: query);
  }

  Future<void> addTask(Task task) async {
    int insertedId = await dbHelper.insertTask(task);
    loadTasks();

    DateTime dueDateTime = Task.parseDateTime(task.dueDate);
    DateTime now = DateTime.now();
    Duration diff = dueDateTime.difference(now);

    if (task.status == TaskStatus.completed.name) {
      return;
    }
    if (diff.inMinutes >= 30) {
      await NotificationService.showNotification(
        id: insertedId,
        title: "Task Reminder",
        body: "Your task '${task.title}' is due soon!",
        scheduledDate: DateTime.parse(task.dueDate),
      );
    }
  }

  Future<void> updateTask(Task task) async {
    await dbHelper.updateTask(task);
    loadTasks();

    await NotificationService.cancelNotification(task.id!);

    DateTime dueDateTime = Task.parseDateTime(task.dueDate);
    DateTime now = DateTime.now();
    Duration diff = dueDateTime.difference(now);

    if (task.status == TaskStatus.completed.name) {
      return;
    }

    if (diff.inMinutes >= 30) {
      await NotificationService.showNotification(
        id: task.id!,
        title: "Task Reminder",
        body: "Your task '${task.title}' is due soon!",
        scheduledDate: dueDateTime,
      );
    }
  }

  Future<void> deleteTask(Task task) async {
    await dbHelper.deleteTask(task.id!);
    loadTasks();

    await NotificationService.cancelNotification(task.id!);
  }
}
