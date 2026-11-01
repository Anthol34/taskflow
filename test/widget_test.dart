// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('TaskFlow welcome screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TaskFlowApp());

    // Verify that our app bar and welcome message are present.
    expect(find.text('TaskFlow'), findsOneWidget);
    expect(find.text('¡Hola, Anthony Solórzano!'), findsOneWidget);
    expect(find.text('Tareas pendientes: 7'), findsOneWidget);
  });
}
