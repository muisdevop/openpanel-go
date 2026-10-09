import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:openpanel_go/core/models/project_config.dart';
import 'package:openpanel_go/core/providers.dart';
import 'package:openpanel_go/core/storage/local_store.dart';
import 'package:openpanel_go/core/storage/secure_storage_service.dart';
import 'package:openpanel_go/features/auth/presentation/login_screen.dart';

/// `/login?edit=<id>` reads the saved client ID out of the Keychain from
/// `initState`, where nothing can await it. A storage failure used to escape as
/// an unhandled async error and leave the form blank with no explanation, so
/// the user could submit an empty client ID over a saved project.
class _FakeStorage extends SecureStorageService {
  _FakeStorage({this.failRead = false});

  final bool failRead;

  @override
  Future<({String clientId, String clientSecret})?> readCredentials(
    String projectKey,
  ) async {
    if (failRead) throw StateError('keystore locked');
    return (clientId: 'cid_$projectKey', clientSecret: 'secret');
  }
}

void main() {
  late Directory dir;
  late LocalStore store;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('openpanel_go_login_edit');
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

  Future<void> pumpEdit(
    WidgetTester tester,
    SecureStorageService storage,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStoreProvider.overrideWithValue(store),
          secureStorageProvider.overrideWithValue(storage),
        ],
        child: const MaterialApp(home: LoginScreen(editId: 'p1')),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'a saved project still prefills its name, project and client ID',
    (WidgetTester tester) async {
      await pumpEdit(tester, _FakeStorage());

      expect(find.text('Demo'), findsWidgets);
      expect(find.text('666'), findsOneWidget);
      expect(find.text('cid_p1'), findsOneWidget);
      expect(find.textContaining('Could not read this project'), findsNothing);
    },
  );

  testWidgets('a failed keychain read says so instead of escaping', (
    WidgetTester tester,
  ) async {
    // Captured rather than left to the test binding: an error that escapes the
    // widget layer is exactly what used to happen, and it would only surface as
    // an anonymous async failure with nothing naming the screen.
    final reported = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = reported.add;
    addTearDown(() => FlutterError.onError = previous);

    await pumpEdit(tester, _FakeStorage(failRead: true));

    expect(
      find.textContaining("Could not read this project's saved client ID"),
      findsOneWidget,
    );
    // The form is left in its "new project" shape: `_editing` is never set, so
    // a submit can't reuse the secret that failed to load.
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(reported, hasLength(1));
    expect(reported.single.exception, isA<StateError>());
    expect(reported.single.library, 'auth');
  });
}
