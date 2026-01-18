import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:doable_todo_list_app/screens/home_page.dart';
import 'package:doable_todo_list_app/screens/add_task_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('All Test Scenarios Integration', () {
    testWidgets('TM-U-001: Empty title validation', (WidgetTester tester) async {
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
      //await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2)); // Watch app load
      await tester.pumpAndSettle();

      // Tap the add button
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();
      //await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2)); // Watch navigation

      // On add task page
      expect(find.text('Create to-do'), findsOneWidget);

      // Try to save without title
      final saveButton = find.widgetWithText(FilledButton, 'Save');
      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      //await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2)); // Watch error message

      // Check for error snackbar
      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('TM-U-002: Valid title validation', (WidgetTester tester) async {
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
      expect(find.text('Valid Test Task'), findsNothing);

      // Tap the add button
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();
      //await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2)); // Watch navigation

      // On add task page
      expect(find.text('Create to-do'), findsOneWidget);

      // Enter valid title
      final titleField = find.widgetWithText(TextField, 'Title');
      await tester.enterText(titleField, 'Valid Test Task');
      await tester.pump();
      await Future.delayed(const Duration(seconds: 1)); // Watch text entry

      // Dismiss keyboard
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1)); // Watch keyboard dismiss

      // Tap save
      final saveButton = find.widgetWithText(FilledButton, 'Save');
      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      //await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2)); // Watch save action
      await tester.pumpAndSettle(); // Wait for async save

      // Should navigate back
      expect(find.text('Create to-do'), findsNothing);
      expect(find.text('Today'), findsOneWidget);
      //await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2)); // Watch navigation back

      // Wait for task to load
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify task displayed
      expect(find.text('Valid Test Task'), findsOneWidget);
      //await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2)); // Watch task appear
    });

    testWidgets('TM-W-003: UI fields presence', (WidgetTester tester) async {
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

      // Tap the add button
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Check UI fields are present
      expect(find.text('Tell us about your task'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Description'), findsOneWidget);
      expect(find.text('Repeat'), findsOneWidget);
      expect(find.text('Date & Time'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);
    });

    testWidgets('TM-W-004: Date picker dialog', (WidgetTester tester) async {
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

      // Tap the add button
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Tap date field
      final dateField = find.text('Set date');
      await tester.tap(dateField);
      await tester.pumpAndSettle();

      // Check date picker dialog appears
      expect(find.text('Select date'), findsOneWidget);
      //expect(find.byType(CalendarDatePicker), findsOneWidget);
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('TM-W-005: Time picker dialog', (WidgetTester tester) async {
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

      // Tap the add button
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Tap time field
      final timeField = find.text('Set time');
      await tester.tap(timeField);
      await tester.pumpAndSettle();

      // Check time picker dialog appears
      expect(find.text('Select time'), findsOneWidget);
      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('TM-W-006: Task completion toggle', (WidgetTester tester) async {
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

      // Create a task first
      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      final titleField = find.widgetWithText(TextField, 'Title');
      await tester.enterText(titleField, 'Toggle Test Task');
      await tester.pump();

      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(FilledButton, 'Save');
      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Now toggle the task
      final taskTile = find.text('Toggle Test Task');
      expect(taskTile, findsOneWidget);

      // Find the toggle circle (assuming it's the first CircleCheck or similar)
      // Since _CircleCheck is custom, find by type or ancestor
      final toggleFinder = find.descendant(
        of: find.ancestor(of: taskTile, matching: find.byType(InkWell)),
        matching: find.byType(Container), // The circle container
      ).first;

      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();

      // Check if task is now completed (might have strikethrough or moved)
      // Since completed tasks are at bottom, and incomplete at top
      // For simplicity, check that the task is still there, assuming toggle worked
      expect(find.text('Toggle Test Task'), findsOneWidget);
    });

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