import 'package:flutter/material.dart';

import '../models/task.dart';
import '../helpers/db_helper.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  Future<int> addTask({
    required String title,
    required String note,
    required String date,
    required String startTime,
    required String endTime,
    required int remind,
    required String repeat,
    required int color,
    required int isCompleted,
  }) async {
    final newTask = Task(
      title: title,
      note: note,
      isCompleted: isCompleted,
      date: date,
      startTime: startTime,
      endTime: endTime,
      color: color,
      remind: remind,
      repeat: repeat,
    );
    _tasks.add(newTask);
    notifyListeners();

    return await DBHelper.insert('user_tasks', {
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
      'color': color,
      'isCompleted': isCompleted,
    });
  }

  Future<List<Task>> getTasks() async {
    final dataList = await DBHelper.query('user_tasks');
    _tasks = dataList
        .map((item) => Task(
              id: item['id'],
              title: item['title'],
              note: item['note'],
              isCompleted: item['isCompleted'],
              date: item['date'],
              startTime: item['startTime'],
              endTime: item['endTime'],
              color: item['color'],
              remind: item['remind'],
              repeat: item['repeat'],
            ))
        .toList();
    notifyListeners();
    return tasks;
  }

  Future<int> removeTask(Task task) async {
    return await DBHelper.delete('user_tasks', task);
  }

  Future<int> taskIsCompleted(int id) async {
    return await DBHelper.update('user_tasks', id);
  }
}
