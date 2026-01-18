# Testing Guide — Doable Todo List App

This document explains the testing approach, how to run the tests, the tools/frameworks used, and assumptions made while building test automation for this project.

## 1. Testing Approach
- Robots architecture: reusable UI helpers live under `test/robots/` (e.g. `add_task_page_robot.dart`) to encapsulate interactions and assertions.
- Test types:
  - Widget tests: fast unit-like tests for widgets and validation (located in `test/widgets/`).
  - Desktop integration tests: end-to-end flows that run via `flutter test` on the VM (located in `test/integration/`). These use `sqflite_common_ffi` to run SQLite in desktop environments.
  - Device integration tests: full end-to-end scenarios executed with `flutter drive` (located in `test/integration_test/`).

## 2. Where tests live
- `test/widgets/` — widget/unit tests
- `test/integration/` — desktop integration tests (flutter test)
- `test/integration_test/` — device integration tests (flutter drive)
- `test/robots/` — robots/helpers for UI interactions
- `test/test_config.dart` — shared test utilities and setup

## 3. How to run the tests

Run widget tests (fast):
```bash
flutter test test/widgets/
```

Run desktop integration tests (VM; requires `sqflite_common_ffi` initialization where used):
```bash
flutter test test/integration/
```

Run device integration tests (use a connected device or emulator):
```bash
flutter drive --driver=test_driver/integration_test.dart --target=test/integration_test/all_scenarios_test.dart
```

Run all tests under `test/` (excluding device integration run with `flutter drive`):
```bash
flutter test test/
```

Notes:
- When running device tests with `flutter drive`, make sure an emulator/device is available and the `test_driver/integration_test.dart` driver file exists (it does in this project).
- If you move the `integration_test` folder, update the `--target` path accordingly.

## 4. Tools & Frameworks Used
- Flutter (SDK) & Dart
- flutter_test — widget and unit tests
- integration_test — device integration tests
- flutter drive — run device integration tests
- sqflite — SQLite for persistence in app
- sqflite_common_ffi — enables SQLite for desktop tests
- build_runner — for code generation tasks (if used in the project)
- awesome_notifications — app feature (not required for running tests, but present in repo)

## 5. Important Setup Details & Assumptions
- Desktop tests using SQLite require initializing the FFI database factory. In test setup (e.g. `test/test_config.dart` or a `setUpAll`), include:
```dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // ...then run tests
}
```
- Device integration tests rely on platform SQLite and actual device environment; they should be executed with `flutter drive` and not `flutter test`.
- Web debugging: web support was added for debugging the app in Chrome. Use `flutter run -d chrome` or `flutter run -d web-server` to open the app in a browser for interactive debugging and stepping through Dart code in DevTools.
- The project's tests were consolidated under `test/`. If CI pipelines expect `integration_test/` at repo root, update CI config to use `test/integration_test/` or move the folder back accordingly.
