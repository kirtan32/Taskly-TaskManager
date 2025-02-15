

import 'package:task_manager/data/db/database_helper.dart';
import 'package:task_manager/data/model/task_model.dart';

class TaskViewModel {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<List<Task>> fetchTasks() async {
    return await dbHelper.getTasks();
  }

  Future<void> addTask(Task task) async {
    await dbHelper.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    await dbHelper.updateTask(task);
  }

  Future<void> deleteTask(int id) async {
    await dbHelper.deleteTask(id);
  }
}
