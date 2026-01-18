import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../robots/add_task_page_robot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.window.clearPhysicalSizeTestValue();
    TestWidgetsFlutterBinding.instance.window.clearDevicePixelRatioTestValue();
  });

  group('AddTaskPage Widget Tests', () {
    testWidgets(
      'TM-U-001: Empty title shows validation error',
      (WidgetTester tester) async {
        final robot = AddTaskPageRobot(tester);

        await robot.pumpPage();
        await robot.enterTitle('');
        await robot.tapSave();

        robot.expectErrorMessage('Please enter a title');
      },
    );

    testWidgets(
      'TM-U-002: Valid title does not show validation error',
      (WidgetTester tester) async {
        final robot = AddTaskPageRobot(tester);

        await robot.pumpPage();
        await robot.enterTitle('Valid Title');
        await robot.tapSave();

        expect(find.text('Please enter a title'), findsNothing);
      },
    );

    testWidgets(
      'TM-W-003: Create to-do screen renders all required fields',
      (WidgetTester tester) async {
        final robot = AddTaskPageRobot(tester);

        await robot.pumpPage();
        robot.verifyRequiredFields();
      },
    );

    testWidgets(
      'TM-W-004: Tapping Set date opens date picker dialog',
      (WidgetTester tester) async {
        final robot = AddTaskPageRobot(tester);

        await robot.pumpPage();
        await robot.tapSetDate();

        robot.expectDatePickerDialog();
      },
    );

    testWidgets(
      'TM-W-005: Tapping Set time opens time picker dialog',
      (WidgetTester tester) async {
        final robot = AddTaskPageRobot(tester);

        await robot.pumpPage();
        await robot.tapSetTime();

        robot.expectTimePickerDialog();
      },
    );
  });
}
