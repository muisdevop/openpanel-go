import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:openpanel_go/core/models/project_config.dart';
import 'package:openpanel_go/core/providers.dart';
import 'package:openpanel_go/core/storage/local_store.dart';
import 'package:openpanel_go/features/shell/home_shell.dart';
import 'package:openpanel_go/shared/widgets/empty_state.dart';

/// Forces the "the server rejected this secret" state, as the Dio layer would.
class _Rejected extends CredentialsRejected {
  _Rejected(this.code);

  final int? code;

  @override
  int? build() => code;
}

/// The four tabs as inert placeholders: this covers whether the shell shows
/// them at all, not what each one renders.
Widget _tab(String key) => SizedBox.expand(key: ValueKey(key));

late LocalStore store;

Future<void> _pump(
  WidgetTester tester, {
  int? rejectedAt,
  String at = '/overview',
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const Text('login-screen')),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/overview', builder: (_, _) => _tab('overview')),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/realtime', builder: (_, _) => _tab('realtime')),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/insights', builder: (_, _) => _tab('insights')),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/settings', builder: (_, _) => _tab('settings')),
            ],
          ),
        ],
      ),
    ],
  );
  router.go(at);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        activeApiProvider.overrideWith((_) async => null),
        if (rejectedAt != null)
          credentialsRejectedProvider.overrideWith(() => _Rejected(rejectedAt)),
      ],
      // Same policy as main(): a 401/403 will not fix itself, so no retries.
      retry: (_, _) => null,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late Directory dir;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('openpanel_go_shell');
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
    await store.setActiveProjectId('p1');
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  testWidgets('with working credentials the tabs are shown', (tester) async {
    await _pump(tester);
    expect(find.byKey(const ValueKey('overview')), findsOneWidget);
    expect(find.byType(EmptyState), findsNothing);
  });

  testWidgets('a server 401 replaces every tab with one fixable screen', (
    tester,
  ) async {
    await _pump(tester, rejectedAt: 401);
    expect(find.byKey(const ValueKey('overview')), findsNothing);
    expect(find.text('Not authorized'), findsOneWidget);
    expect(find.text('Re-enter credentials'), findsOneWidget);
  });

  testWidgets('a 403 blames the client, not the network', (tester) async {
    await _pump(tester, rejectedAt: 403);
    expect(find.text('No access to this project'), findsOneWidget);
  });

  testWidgets('Settings stays reachable while credentials are rejected', (
    tester,
  ) async {
    await _pump(tester, rejectedAt: 401, at: '/settings');
    expect(find.byKey(const ValueKey('settings')), findsOneWidget);
    expect(find.text('Re-enter credentials'), findsNothing);
  });

  testWidgets('the setup prompt routes to this project\'s credential form', (
    tester,
  ) async {
    await _pump(tester, rejectedAt: 401);
    await tester.tap(find.text('Re-enter credentials'));
    await tester.pumpAndSettle();
    expect(find.text('login-screen'), findsOneWidget);
  });
}
