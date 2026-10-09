import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:openpanel_go/core/models/project_config.dart';
import 'package:openpanel_go/core/providers.dart';
import 'package:openpanel_go/core/storage/local_store.dart';
import 'package:openpanel_go/features/auth/presentation/login_screen.dart';

/// Selecting "Self-hosted" inserts the Base URL field above the other four.
/// Without keys on the fields, Flutter re-matches each remaining element to the
/// next widget by position, so every field inherits the State of the field that
/// used to sit in its slot — including `_obscured`, which made Client ID render
/// as a password with no reveal toggle.
void main() {
  late Directory dir;
  late LocalStore store;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('openpanel_go_login');
    store = await LocalStore.open(hiveDir: dir.path);
    await store.upsertProject(
      ProjectConfig(
        id: 'p1',
        name: 'Demo',
        baseUrl: 'https://bench.openpanel.com',
        projectId: '666',
        createdAt: DateTime(2026),
      ),
    );
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStoreProvider.overrideWithValue(store)],
        child: MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  bool obscured(WidgetTester tester, int index) => tester
      .widget<EditableText>(find.byType(EditableText).at(index))
      .obscureText;

  testWidgets('Cloud mode shows four fields and only one is masked', (
    tester,
  ) async {
    await pump(tester);
    expect(find.byType(TextFormField), findsNWidgets(4));
    // name, projectId, clientId, secret
    expect(obscured(tester, 2), isFalse, reason: 'Client ID is not a secret');
    expect(obscured(tester, 3), isTrue, reason: 'Client Secret starts masked');
  });

  testWidgets(
    'switching to Self-hosted does not move the mask onto Client ID',
    (tester) async {
      await pump(tester);
      await tester.tap(find.text('Self-hosted'));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(5));
      // baseUrl, name, projectId, clientId, secret
      expect(
        obscured(tester, 3),
        isFalse,
        reason: 'Client ID inherited the secret field obscured state',
      );
      expect(obscured(tester, 4), isTrue);
    },
  );

  testWidgets('exactly one field offers a reveal toggle', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Self-hosted'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
  });

  testWidgets('a revealed secret stays revealed and does not leak sideways', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Self-hosted'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pumpAndSettle();
    expect(obscured(tester, 4), isFalse, reason: 'reveal should stick');
    expect(obscured(tester, 3), isFalse);

    await tester.tap(find.text('OpenPanel Cloud'));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(obscured(tester, 3), isFalse, reason: 'revealed secret stays open');
  });
}
