import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('TaskFlow task list smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TaskFlowApp());

    // Verify AppBar title
    expect(find.text('Mis tareas'), findsOneWidget);

    // Verify all demo tasks are rendered
    for (final task in demoTasks) {
      expect(find.text(task.title), findsOneWidget);
      expect(
        find.text('${task.priority} · ${task.description}'),
        findsOneWidget,
      );
    }

    // Verify presence of completed and pending icons
    expect(find.byIcon(Icons.check_circle), findsWidgets);
    expect(find.byIcon(Icons.radio_button_unchecked), findsWidgets);
    expect(find.byIcon(Icons.chevron_right), findsNWidgets(demoTasks.length));
  });
}
