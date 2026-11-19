import 'package:flutter/foundation.dart';

import '../data/task_repository.dart';
import '../domain/task.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel({required this.repository}) {
    loadTasks();
  }

  final TaskRepository repository;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await repository.getTasks();
    } catch (e) {
      _errorMessage = 'Error al cargar las tareas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Task?> getTaskById(int id) async {
    return await repository.getTaskById(id);
  }
}
