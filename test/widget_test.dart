import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('TaskFlow welcome screen smoke test and interactions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    // 1. Estado inicial
    expect(find.text('TaskFlow'), findsOneWidget);
    expect(find.text('¡Hola, Anthony Solórzano!'), findsOneWidget);
    expect(find.text('Tareas pendientes: 3'), findsOneWidget);
    expect(find.text('Completadas hoy: 0 de 5'), findsOneWidget);
    expect(find.text('Aún tienes tareas por organizar.'), findsOneWidget);

    // 2. Agregar tareas
    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    expect(find.text('Tareas pendientes: 4'), findsOneWidget);

    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    expect(find.text('Tareas pendientes: 5'), findsOneWidget);

    // 3. Completar tareas hasta llegar a cero
    for (int i = 0; i < 5; i++) {
      await tester.tap(find.text('Completar una tarea'));
      await tester.pump();
    }

    // Verificar en cero
    expect(find.text('Tareas pendientes: 0'), findsOneWidget);
    expect(find.text('Completadas hoy: 5 de 5'), findsOneWidget);
    expect(
      find.text('¡Excelente! No tienes tareas pendientes.'),
      findsOneWidget,
    );

    // El botón 'Completar una tarea' debe estar deshabilitado
    final OutlinedButton completeBtn = tester.widget(
      find.widgetWithText(OutlinedButton, 'Completar una tarea'),
    );
    expect(completeBtn.onPressed, isNull);

    // 4. Agregar una tarea: se vuelve a habilitar y el contador sube a 1
    await tester.tap(find.text('Agregar tarea'));
    await tester.pump();
    expect(find.text('Tareas pendientes: 1'), findsOneWidget);
    expect(find.text('Aún tienes tareas por organizar.'), findsOneWidget);

    final OutlinedButton completeBtnEnabled = tester.widget(
      find.widgetWithText(OutlinedButton, 'Completar una tarea'),
    );
    expect(completeBtnEnabled.onPressed, isNotNull);

    // Completar la tarea: completedTasks no debe superar 5 (dailyGoal)
    await tester.tap(find.text('Completar una tarea'));
    await tester.pump();
    expect(find.text('Tareas pendientes: 0'), findsOneWidget);
    expect(find.text('Completadas hoy: 5 de 5'), findsOneWidget);
  });
}
