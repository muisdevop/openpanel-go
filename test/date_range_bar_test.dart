import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:openpanel_go/core/models/date_range.dart';
import 'package:openpanel_go/core/providers.dart';
import 'package:openpanel_go/core/storage/local_store.dart';
import 'package:openpanel_go/shared/widgets/project_header.dart';

/// The date bar is a fixed 40dp row of chips, and the widest label is a custom
/// range ("Oct 1 – Sep 30, 2026"). Truncation there was suspected from a device
/// capture, so it is asserted here rather than eyeballed.
void main() {
  late Directory dir;
  late LocalStore store;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('openpanel_go_date_bar');
    store = await LocalStore.open(hiveDir: dir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  Future<void> pumpBar(WidgetTester tester) async {
    // The narrowest handset still sold, and the bar has to survive it.
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    // Scaffold, not a bare SizedBox: ChoiceChip needs the Material ancestor the
    // app bar gives it in the real screen.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStoreProvider.overrideWithValue(store)],
        child: const MaterialApp(
          home: Scaffold(body: SizedBox(height: 40, child: DateRangeBar())),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('the 40dp bar overflows nothing on a 320dp screen', (
    WidgetTester tester,
  ) async {
    await pumpBar(tester);

    // A chip taller than the bar would raise a RenderFlex overflow here rather
    // than show up as a clipped label.
    expect(tester.takeException(), isNull);
    expect(find.byType(ChoiceChip), findsWidgets);

    // The row scrolls, so the chips past the fold have to be reachable rather
    // than cut off. Drag until the last preset is on screen.
    await tester.dragUntilVisible(
      find.text('Last 30 days'),
      find.byType(ListView),
      const Offset(-40, 0),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Last 30 days'), findsOneWidget);
  });

  testWidgets('a custom range label is not ellipsized', (tester) async {
    final range = SelectedDateRange(
      DateRangePreset.custom,
      customStart: DateTime(2025, 10, 1),
      customEnd: DateTime(2026, 9, 30),
    );
    // `runAsync` because the write is real disk I/O: inside a `testWidgets`
    // body the binding runs on FakeAsync, which never drains the event loop the
    // Hive completion arrives on, so a bare await hangs the test forever.
    await tester.runAsync(() => store.setDateRange(range));
    await pumpBar(tester);

    final label = range.label;
    await tester.dragUntilVisible(
      find.text(label),
      find.byType(ListView),
      const Offset(-40, 0),
    );
    expect(find.text(label), findsOneWidget);
    final textWidth = tester.getSize(find.text(label)).width;
    final chipWidth = tester
        .getSize(
          find.ancestor(
            of: find.text(label),
            matching: find.byType(ChoiceChip),
          ),
        )
        .width;
    // The selected chip has to be at least as wide as the label it holds; if
    // the label were being cut, its measured width would exceed the chip's.
    expect(textWidth, lessThanOrEqualTo(chipWidth));
    expect(tester.takeException(), isNull);
  });
}
