import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/features/realtime/presentation/realtime_screen.dart';

/// The Live/Paused toggle is the only hand-built control in the realtime
/// header; every other tappable comes from a Material widget that enforces its
/// own minimum size. These tests would fail on the ~42dp pill that existed
/// before the minHeight:48 constraint, and would fail again if a font-metric
/// change ever dragged the hit box back under the 48dp floor.
void main() {
  Future<void> pump(WidgetTester tester, {required bool paused}) {
    // disableAnimations stops _PulsingDot's repeating controller so the test
    // has no live ticker at teardown; it does not affect the measured size.
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Center(
              child: LiveTogglePill(
                paused: paused,
                intervalSeconds: 10,
                onToggle: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  for (final paused in [false, true]) {
    testWidgets(
      'the pill keeps a >=48dp tap target when ${paused ? "Paused" : "Live"}',
      (tester) async {
        await pump(tester, paused: paused);
        final size = tester.getSize(find.byType(InkWell));
        expect(size.height, greaterThanOrEqualTo(48));
      },
    );
  }

  testWidgets('the pill names what tapping does, not just its state', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(tester, paused: false);
    expect(
      find.bySemanticsLabel('Refreshing every 10 seconds, tap to pause'),
      findsOneWidget,
    );
    handle.dispose();
  });
}
