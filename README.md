# TaskFlow 📱✨

**TaskFlow** es una aplicación móvil desarrollada con **Flutter** para la gestión eficiente y organizada de tareas diarias. El proyecto implementa una arquitectura orientada al dominio (**MVVM + Repository + ApiService**) y está preparado para sincronizarse con una **API REST**.

---

## 🎯 1. Problema que resuelve

En entornos académicos y laborales, las personas suelen enfrentarse a dificultades para gestionar sus actividades pendientes debido a:
- Falta de visibilidad y priorización de tareas urgentes frente a secundarias.
- Herramientas sobrecargadas de funciones complejas que entorpecen el registro ágil.
- Pérdida de seguimiento del estado real (pendiente vs. completada) y de los objetivos diarios.

**TaskFlow** soluciona esta problemática proporcionando una interfaz rápida, limpia y reactiva que permite consultar, crear, detallar y completar tareas en cualquier momento.

---

## 👥 2. Usuario objetivo

- **Estudiantes universitarios y técnicos** que necesitan planificar entregas de proyectos, talleres y exámenes.
- **Profesionales y trabajadores autónomos** que gestionan actividades diarias y requieren categorizar tareas por niveles de urgencia.
- **Cualquier usuario** que busque organizar su rutina diaria de manera directa sin complicaciones ni interfaces saturadas.

---

## 📋 3. Historias de Usuario

A continuación se presentan las cinco historias de usuario principales que definen el alcance esencial del producto:

### HU-01: Visualizar el listado de tareas
- **Como** usuario,  
- **quiero** ver todas mis tareas organizadas en una lista desplazable con su estado y prioridad,  
- **para** tener una visión global inmediata de mis pendientes del día.
- **Criterios de aceptación:**
  1. Cada tarjeta muestra título, prioridad (`Alta`, `Media`, `Baja`), descripción resumida e icono de estado.
  2. Las tareas completadas muestran un icono distintivo (`check_circle` en verde) y las pendientes un círculo sin rellenar.
  3. La lista se renderiza bajo demanda mediante `ListView.builder` para optimizar el rendimiento.

### HU-02: Consultar el detalle de una tarea
- **Como** usuario,  
- **quiero** tocar una tarjeta de tarea para abrir su pantalla de detalle,  
- **para** revisar su información completa (título, descripción detallada, prioridad y estado).
- **Criterios de aceptación:**
  1. La navegación utiliza rutas declarativas con parámetro dinámico (`/task/:id`) mediante `go_router`.
  2. La pantalla presenta un `Chip` visual con la prioridad y el texto del estado.
  3. Incluye un botón para regresar fácilmente al listado principal (`context.pop()`).

### HU-03: Crear una nueva tarea
- **Como** usuario,  
- **quiero** completar un formulario para registrar una nueva tarea,  
- **para** agregar compromisos a mi backlog de actividades.
- **Criterios de aceptación:**
  1. Formulario con validaciones: título obligatorio (mínimo 3 caracteres) y selección de prioridad.
  2. La tarea se inicializa por defecto con estado pendiente (`isCompleted = false`).
  3. Al guardar satisfactoriamente, se actualiza la lista y se regresa a la pantalla principal.

### HU-04: Marcar una tarea como completada o editarla
- **Como** usuario,  
- **quiero** cambiar el estado de una tarea o modificar sus datos existentes,  
- **para** reflejar el progreso real de mis actividades.
- **Criterios de aceptación:**
  1. Posibilidad de alternar el estado entre pendiente y completada.
  2. Actualización reactiva de la interfaz sin necesidad de recargar la app.
  3. Sincronización del cambio enviando la petición correspondiente a la API REST.

### HU-05: Eliminar una tarea
- **Como** usuario,  
- **quiero** borrar una tarea que ya no es necesaria o fue creada por error,  
- **para** mantener mi lista despejada y con información relevante.
- **Criterios de aceptación:**
  1. La acción solicita confirmación previa al usuario mediante un cuadro de diálogo para evitar borrados accidentales.
  2. Se ejecuta la petición HTTP de eliminación y se retira el elemento del listado.

---

## 🧱 4. Modelo Principal de Datos (`Task`)

La entidad central del dominio es la clase `Task`, definida en [`lib/task.dart`](lib/task.dart).

### Atributos del modelo:
| Campo | Tipo | Descripción |
|---|---|---|
| `id` | `int` | Identificador único de la tarea |
| `title` | `String` | Título conciso de la tarea |
| `description` | `String` | Descripción detallada de la actividad |
| `priority` | `String` | Prioridad (`Alta`, `Media`, `Baja`) |
| `isCompleted` | `bool` | Estado de la tarea (`true`: completada, `false`: pendiente) |
| `userId` | `int` | Identificador del usuario propietario |

### Representación JSON:
```json
{
  "id": 1,
  "title": "Diseñar arquitectura de TaskFlow",
  "description": "Estructurar capas y componentes principales",
  "priority": "Alta",
  "isCompleted": false,
  "userId": 1
}
```

### Implementación en Dart:
```dart
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    required this.userId,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
  final int userId;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String,
      isCompleted: json['isCompleted'] as bool,
      userId: json['userId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }
}
```

---

## 📱 5. Boceto y Flujo de Pantallas

### Estructura de navegación declarativa (`GoRouter`):
```text
  [ / ]                      [ /task/:id ]                  [ /create ]
┌────────────────────┐     ┌────────────────────┐         ┌────────────────────┐
│    TaskListScreen  │     │  TaskDetailScreen  │         │   TaskFormScreen   │
│ ────────────────── │     │ ────────────────── │         │ ────────────────── │
│ • AppBar:          │ ──> │ • Título grande    │         │ • Campo: Título    │
│   "Mis tareas"     │ onTap│ • Descripción     │         │ • Campo: Descrip.  │
│ • Listado Cards    │     │ • Chip Prioridad   │         │ • Dropdown: Prior. │
│ • FAB [+]          │ ──> │ • Estado           │         │ • Botón: Guardar   │
└────────────────────┘     │ • [Volver listado] │         └────────────────────┘
                           └────────────────────┘
```

1. **Pantalla de Listado (`TaskListScreen`)**:
   - Ruta: `/`
   - Vista inicial con AppBar centrada. Muestra la colección de tareas mediante `ListView.builder`.
   - Cada tarjeta `TaskCard` incluye icono de estado, textos y chevron interactivo.
2. **Pantalla de Detalle (`TaskDetailScreen`)**:
   - Ruta: `/task/:id`
   - Muestra la información desglosada de la tarea seleccionada por su identificador único.
   - Botón tonal inferior para regresar a la pantalla anterior (`context.pop()`).
3. **Pantalla de Formulario (`TaskFormScreen`)**:
   - Ruta: `/create` (o `/task/:id/edit` para edición).
   - Formulario de entrada validado para creación y actualización de tareas.

---

## 🌐 6. Endpoints requeridos de la API REST

Para la integración con el backend remoto, se establecen las siguientes operaciones CRUD:

| Método | Endpoint | Descripción | Cuerpo de la petición (Body) | Código esperado |
|---|---|---|---|---|
| `GET` | `/tasks` | Obtener listado de tareas del usuario | Vacío | `200 OK` |
| `GET` | `/tasks/:id` | Obtener una tarea específica por id | Vacío | `200 OK` |
| `POST` | `/tasks` | Crear una nueva tarea | JSON con datos de la tarea | `201 Created` |
| `PUT` / `PATCH` | `/tasks/:id` | Modificar datos o estado de una tarea | JSON con campos actualizados | `200 OK` |
| `DELETE` | `/tasks/:id` | Eliminar una tarea del sistema | Vacío | `200 OK` / `204 No Content` |

---

## 🛠️ 7. Stack Técnico y Arquitectura

- **Lenguaje:** Dart 3.x
- **Framework:** Flutter 3.x (Material 3)
- **Navegación:** `go_router`
- **Arquitectura:** MVVM (Model-View-ViewModel) con repositorio desacoplado.
- **Control de versiones:** Git y GitHub.

---

## 🚀 8. Instalación y Ejecución

1. Clonar el repositorio o ingresar a la carpeta del proyecto:
   ```bash
   cd taskflow
   ```

2. Obtener las dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecutar análisis de código para validar calidad:
   ```bash
   flutter analyze
   ```

4. Iniciar la aplicación:
   ```bash
   # En navegador Microsoft Edge
   flutter run -d edge

   # En dispositivo Android conectado
   flutter run
   ```
