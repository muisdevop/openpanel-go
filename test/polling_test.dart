import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/shared/widgets/polling.dart';

/// Drives [PollingMixin] with a tick whose duration the test controls.
class _Probe extends StatefulWidget {
  const _Probe({
    required this.interval,
    required this.tickDuration,
    required this.started,
    this.visible = true,
  });

  final Duration interval;
  final Duration tickDuration;
  final List<int> started;
  final bool visible;

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> with PollingMixin {
  @override
  Duration get pollInterval => widget.interval;

  @override
  bool shouldPoll() => widget.visible;

  @override
  Future<void> onTick() async {
    widget.started.add(DateTime.now().microsecondsSinceEpoch);
    await Future<void>.delayed(widget.tickDuration);
  }

  @override
  void initState() {
    super.initState();
    startPolling();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  Widget probe({
    required Duration interval,
    required Duration tickDuration,
    required List<int> started,
    bool visible = true,
  }) {
    return MaterialApp(
      home: _Probe(
        interval: interval,
        tickDuration: tickDuration,
        started: started,
        visible: visible,
      ),
    );
  }

  testWidgets('a tick slower than the interval does not overlap the next one', (
    tester,
  ) async {
    final started = <int>[];
    await tester.pumpWidget(
      probe(
        interval: const Duration(seconds: 10),
        tickDuration: const Duration(seconds: 25),
        started: started,
      ),
    );

    await tester.pump(const Duration(seconds: 10));
    expect(started, hasLength(1));

    // Two more intervals elapse while the first request is still in flight.
    // Timer.periodic would have fired three times without the guard.
    await tester.pump(const Duration(seconds: 20));
    expect(started, hasLength(1));

    // The tick that started at 10s finishes at 35s; the periodic timer is on
    // its own schedule, so the next allowed tick is at 40s.
    await tester.pump(const Duration(seconds: 11));
    expect(started, hasLength(2));

    // Let the second tick finish, then dispose: an outstanding Future.delayed
    // is a pending timer, and the binding fails a test that leaves one behind.
    await tester.pump(const Duration(seconds: 25));
    expect(started, hasLength(2));
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
  });

  testWidgets('a hidden branch does not poll', (tester) async {
    final started = <int>[];
    await tester.pumpWidget(
      probe(
        interval: const Duration(seconds: 10),
        tickDuration: const Duration(seconds: 1),
        started: started,
        visible: false,
      ),
    );

    await tester.pump(const Duration(seconds: 31));
    expect(started, isEmpty);
  });

  testWidgets('dispose stops the timer', (tester) async {
    final started = <int>[];
    await tester.pumpWidget(
      probe(
        interval: const Duration(seconds: 10),
        tickDuration: const Duration(seconds: 1),
        started: started,
      ),
    );
    await tester.pump(const Duration(seconds: 11));
    expect(started, hasLength(1));

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump(const Duration(seconds: 30));
    expect(started, hasLength(1));
  });
}
