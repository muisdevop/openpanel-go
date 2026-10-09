import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/core/network/api_exception.dart';
import 'package:openpanel_go/shared/widgets/polling.dart';

/// A tick runs on a `Timer.periodic` callback, so nothing awaits it. The mixin
/// has to handle a rejected [onTick] itself, or every interval after the first
/// failure surfaces as an unhandled zone exception — which is what a rotated
/// secret or a WRITE client did on a real device.
class _Ticker extends StatefulWidget {
  const _Ticker({required this.onTick});

  final Future<void> Function() onTick;

  @override
  State<_Ticker> createState() => _TickerState();
}

class _TickerState extends State<_Ticker> with PollingMixin<_Ticker> {
  @override
  Duration get pollInterval => const Duration(milliseconds: 100);

  @override
  Future<void> onTick() => widget.onTick();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  @override
  void initState() {
    super.initState();
    startPolling();
  }
}

void main() {
  testWidgets('a failing tick is reported instead of escaping the zone', (
    tester,
  ) async {
    final reported = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = reported.add;
    addTearDown(() => FlutterError.onError = previous);

    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: _Ticker(
          onTick: () async {
            calls++;
            throw ApiException.unauthorized(401, null);
          },
        ),
      ),
    );

    // Two intervals: the second one only fires if the first failure released
    // the `_busy` guard instead of wedging the poller.
    for (var i = 0; i < 2; i++) {
      await tester.pump(const Duration(milliseconds: 120));
      await tester.pump();
    }

    expect(calls, 2, reason: 'polling must keep running after a failure');
    expect(
      reported.where((d) => d.exception is ApiException),
      isNotEmpty,
      reason: 'the tick error must reach the error handler',
    );
  });

  testWidgets('a successful tick reports nothing', (tester) async {
    final reported = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = reported.add;
    addTearDown(() => FlutterError.onError = previous);

    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: _Ticker(
          onTick: () async {
            calls++;
          },
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump();

    expect(calls, 1);
    expect(reported, isEmpty);
  });
}
