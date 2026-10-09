import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:openpanel_go/core/models/date_range.dart';
import 'package:openpanel_go/core/storage/local_store.dart';

void main() {
  late Directory dir;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('openpanel_go_store');
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  Future<LocalStore> store() => LocalStore.open(hiveDir: dir.path);

  test('a cached entry is readable inside its TTL', () async {
    final s = await store();
    await s.writeCache('metrics:p1:{"preset":"last7Days"}', '{"v":1}');
    expect(s.readCache('metrics:p1:{"preset":"last7Days"}'), '{"v":1}');
  });

  test('a cached entry older than the requested maxAge is dropped', () async {
    final s = await store();
    await s.writeCache('metrics:p1:k', 'payload');
    // Zero tolerance: the entry was stamped microseconds ago, so anything with
    // an age at all is expired. It must read as absent and be removed.
    expect(s.readCache('metrics:p1:k', maxAge: Duration.zero), isNull);
    expect(s.readCache('metrics:p1:k'), isNull);
  });

  test('writeCache evicts past the entry cap, keeping the newest', () async {
    final s = await store();
    for (var i = 0; i < 205; i++) {
      await s.writeCache('metrics:p1:k$i', 'v$i');
    }
    var readable = 0;
    for (var i = 0; i < 205; i++) {
      if (s.readCache('metrics:p1:k$i') != null) readable++;
    }
    // A box that grows with every project × range × screen combination is the
    // defect; the cap is what the test pins, not which key got evicted.
    expect(readable, lessThanOrEqualTo(200));
    expect(s.readCache('metrics:p1:k204'), 'v204');
  });

  test('deleting a project evicts its cached responses', () async {
    final s = await store();
    await s.writeCache('metrics:p1:k', 'one');
    await s.writeCache('metrics:p2:k', 'two');
    await s.deleteProject('p1');
    expect(s.readCache('metrics:p1:k'), isNull);
    expect(s.readCache('metrics:p2:k'), 'two');
  });

  test('active project and date range survive a reopen', () async {
    final s = await store();
    await s.setActiveProjectId('abc');
    await s.setDateRange(
      const SelectedDateRange.preset(DateRangePreset.last30Days),
    );
    await Hive.close();

    final reopened = await store();
    expect(reopened.activeProjectId, 'abc');
    expect(reopened.dateRange.preset, DateRangePreset.last30Days);
  });
}
