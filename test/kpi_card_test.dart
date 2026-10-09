import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/features/overview/presentation/widgets/kpi_card.dart';
import 'package:openpanel_go/shared/theme/app_theme.dart';

/// KpiCard decides what a delta *means* for the user, and it had no test:
///  - `invertChange`: for a lower-is-better metric (bounce rate) a rise is bad
///    and a fall is good — flip the flag or forget it on a future metric and
///    the whole overview misleads.
///  - `isFlat`: a fixed bug (a 0.0% day painted green with an up arrow); this
///    locks that it now reads as neutral.
/// The arrow tracks the raw direction while the colour tracks good/bad — both
/// are asserted so a change that conflates them fails here.
Future<void> pumpCard(
  WidgetTester tester, {
  double? change,
  bool invert = false,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: KpiCard(
          label: 'Metric',
          value: '42',
          icon: Icons.person_outline_rounded,
          change: change,
          invertChange: invert,
        ),
      ),
    ),
  );
}

Color deltaColor(WidgetTester tester, String pct) =>
    tester.widget<Text>(find.text(pct)).style!.color!;

void main() {
  testWidgets('a higher-is-better metric rising reads positive', (
    tester,
  ) async {
    await pumpCard(tester, change: 20);
    expect(deltaColor(tester, '20.0%'), AppColors.positive);
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
  });

  testWidgets('a higher-is-better metric falling reads negative', (
    tester,
  ) async {
    await pumpCard(tester, change: -20);
    expect(deltaColor(tester, '20.0%'), AppColors.negative);
    expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
  });

  testWidgets('bounce rate rising is bad even though the arrow points up', (
    tester,
  ) async {
    await pumpCard(tester, change: 20, invert: true);
    // Colour = bad, arrow still shows the real upward direction.
    expect(deltaColor(tester, '20.0%'), AppColors.negative);
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
  });

  testWidgets('bounce rate falling is good', (tester) async {
    await pumpCard(tester, change: -20, invert: true);
    expect(deltaColor(tester, '20.0%'), AppColors.positive);
    expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
  });

  testWidgets('a near-zero change is flat, not a green upward tick', (
    tester,
  ) async {
    await pumpCard(tester, change: 0.0);
    expect(deltaColor(tester, '0.0%'), AppColors.textMuted);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward_rounded), findsNothing);
  });

  testWidgets('the flat threshold excludes tiny movements on either side', (
    tester,
  ) async {
    // Just inside (< 0.05) stays flat...
    await pumpCard(tester, change: 0.04, invert: true);
    expect(deltaColor(tester, '0.0%'), AppColors.textMuted);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    // ...and just outside is coloured normally (here a bounce rise = bad).
    await pumpCard(tester, change: 0.06, invert: true);
    expect(deltaColor(tester, '0.1%'), AppColors.negative);
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
  });

  testWidgets(
    'no previous period shows an explicit message, not a fake delta',
    (tester) async {
      await pumpCard(tester, change: null);
      expect(find.text('No previous data'), findsOneWidget);
      expect(find.textContaining('%'), findsNothing);
    },
  );
}
