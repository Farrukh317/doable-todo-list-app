import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:doable_todo_list_app/screens/home_page.dart';
import 'package:doable_todo_list_app/screens/add_task_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Task Creation Integration', () {
    testWidgets('TM-I-007: Create and save a task with only a title', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 1600);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
          routes: {
            'add_task': (context) => AddTaskPage(),
            'edit_task': (context) => Container(),
            'settings': (context) => Container(),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Initially, no tasks
      expect(find.text('Test Task'), findsNothing);

      // Tap the add button
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Now on add task page
      expect(find.text('Create to-do'), findsOneWidget);

      // Enter title
      final titleField = find.widgetWithText(TextField, 'Title');
      await tester.enterText(titleField, 'Test Task');
      await tester.pump();

      // Dismiss keyboard
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();

      // Check if FilledButton with 'Save' is present
      expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);

      // Tap save
      final saveButton = find.widgetWithText(FilledButton, 'Save');
      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle(); // Wait for async save to complete

      // Should navigate back to home
      expect(find.text('Create to-do'), findsNothing);
      expect(find.text('Today'), findsOneWidget);

      // Wait for the task to load
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1)); // Wait for async load
      await tester.pumpAndSettle();

      // Verify the task is displayed
      expect(find.text('Test Task'), findsOneWidget);
    });
  });
}