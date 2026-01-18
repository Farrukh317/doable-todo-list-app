import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doable_todo_list_app/screens/add_task_page.dart';

/// Robot class for automating interactions with the AddTaskPage.
/// Follows Page Object Model for clean, maintainable tests.
class AddTaskPageRobot {
  const AddTaskPageRobot(this.tester);

  final WidgetTester tester;

  /// Pumps the AddTaskPage into the widget tree.
  Future<void> pumpPage() async {
    tester.binding.window.physicalSizeTestValue = const Size(800, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: AddTaskPage(),
      ),
    );

    await tester.pumpAndSettle();
  }

  /// Enters text into the Title field.
  Future<void> enterTitle(String title) async {
    final titleField = find.widgetWithText(TextField, 'Title');
    expect(titleField, findsOneWidget);

    await tester.enterText(titleField, title);
    await tester.pump();
  }

  /// Taps the Save button.
  Future<void> tapSave() async {
    final saveButton = find.text('Save');
    expect(saveButton, findsOneWidget);

    await tester.tap(saveButton);
    await tester.pump(); // important for SnackBar rendering
  }

  /// Opens date picker.
  Future<void> tapSetDate() async {
    await tester.tap(find.text('Set date'));
    await tester.pumpAndSettle();
  }

  /// Opens time picker.
  Future<void> tapSetTime() async {
    await tester.tap(find.text('Set time'));
    await tester.pumpAndSettle();
  }

  /// Assertion: SnackBar error message.
  void expectErrorMessage(String message) {
    expect(find.text(message), findsOneWidget);
  }

  /// Assertion: Required UI fields exist.
  void verifyRequiredFields() {
    expect(find.widgetWithText(TextField, 'Title'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Description'), findsOneWidget);
    expect(find.text('Set date'), findsOneWidget);
    expect(find.text('Set time'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  }

  /// Assertion: Date picker dialog is visible.
  ///
  /// showDatePicker renders a Dialog with CalendarDatePicker
  void expectDatePickerDialog() {
    expect(find.byType(CalendarDatePicker), findsOneWidget);
  }

  /// Assertion: Time picker dialog is visible.
  void expectTimePickerDialog() {
    expect(find.byType(TimePickerDialog), findsOneWidget);
  }
}
