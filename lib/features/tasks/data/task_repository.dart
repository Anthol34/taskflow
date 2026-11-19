import '../domain/task.dart';

const demoTasks = [
  Task(
    id: 1,
    title: 'Diseñar arquitectura de TaskFlow',
    description: 'Estructurar capas y componentes principales',
    priority: 'Alta',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 2,
    title: 'Implementar listado dinámico',
    description: 'Construir tarjetas con ListView.builder',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 3,
    title: 'Configurar navegación de tareas',
    description: 'Preparar flujo hacia el detalle por id',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 4,
    title: 'Conectar API REST de tareas',
    description: 'Integrar endpoints de sincronización remota',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 5,
    title: 'Ejecutar análisis y pruebas',
    description: 'Garantizar calidad con flutter test y analyze',
    priority: 'Baja',
    isCompleted: true,
    userId: 1,
  ),
];

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task?> getTaskById(int id);
}

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = demoTasks;

  @override
  Future<List<Task>> getTasks() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task?> getTaskById(int id) async {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }
}
