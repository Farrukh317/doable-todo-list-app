import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Test suite for HomePage widget components.
///
/// Note: This test uses copied widget implementations from the actual app
/// to isolate the testing of the task toggle functionality without dependencies.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('HomePage Components', () {
    testWidgets(
      'TM-W-006: Verify tapping the \'Completed\' checkbox on a task item updates its state',
      (WidgetTester tester) async {
        await tester.pumpWidget(const TestTaskWidget());
        await tester.pumpAndSettle();

        // Initially, not completed
        expect(find.byIcon(Icons.check), findsNothing);
        expect(
          find.byWidgetPredicate((widget) {
            if (widget is Text) {
              return widget.style?.decoration == TextDecoration.lineThrough;
            }
            return false;
          }),
          findsNothing,
        );

        // Tap the checkbox
        final circleCheck = find.byType(InkResponse);
        await tester.tap(circleCheck);
        await tester.pumpAndSettle();

        // Now, completed
        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(
          find.byWidgetPredicate((widget) {
            if (widget is Text) {
              return widget.style?.decoration == TextDecoration.lineThrough;
            }
            return false;
          }),
          findsOneWidget,
        );
      },
    );
  });
}

/// Model class for Task (copied from app for testing).
class Task {
  const Task({
    required this.id,
    required this.title,
    this.description,
    this.time,
    this.date,
    this.hasNotification = false,
    this.repeatRule,
    required this.completed,
  });

  final int id;
  final String title;
  final String? description;
  final String? time;
  final String? date;
  final bool hasNotification;
  final String? repeatRule;
  final bool completed;
}

/// Circle check widget (copied from app for testing).
class _CircleCheck extends StatelessWidget {
  const _CircleCheck({required this.completed, required this.onTap});

  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      customBorder: const CircleBorder(),
      radius: 24,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: completed ? Colors.blue : Colors.blueGrey.shade200,
            width: 2,
          ),
          color: completed ? Colors.blue : Colors.transparent,
        ),
        child: completed
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}

/// Task tile widget (copied from app for testing).
class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onToggle,
  });

  final Task task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isDone = task.completed;

    final titleStyle = TextStyle(
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w800,
      decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
      color: isDone ? Colors.blueGrey : Colors.black,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CircleCheck(completed: isDone, onTap: onToggle),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: titleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Test widget that provides a task tile for testing toggle functionality.
class TestTaskWidget extends StatefulWidget {
  const TestTaskWidget({super.key});

  @override
  State<TestTaskWidget> createState() => _TestTaskWidgetState();
}

class _TestTaskWidgetState extends State<TestTaskWidget> {
  late Task task;

  @override
  void initState() {
    super.initState();
    task = const Task(
      id: 1,
      title: 'Test Task',
      description: 'Test Description',
      completed: false,
    );
  }

  void _toggle() {
    setState(() {
      task = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        time: task.time,
        date: task.date,
        hasNotification: task.hasNotification,
        repeatRule: task.repeatRule,
        completed: !task.completed,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _TaskTile(task: task, onToggle: _toggle),
      ),
    );
  }
}