import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:openpanel_go/features/auth/presentation/widgets/credential_field.dart';

/// The credential form is five fields deep, so the keyboard's action key is the
/// only reason a user does not have to tap each field by hand. It calls
/// `focusNode.nextFocus()`, which walks the traversal order — and the suffix
/// "Paste" / "Show" buttons sit between a field and the next one.
void main() {
  Future<void> pumpForm(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: Column(
              children: [
                CredentialField(
                  controller: TextEditingController(),
                  label: 'A',
                ),
                CredentialField(
                  controller: TextEditingController(),
                  label: 'B',
                  secret: true,
                ),
                CredentialField(
                  controller: TextEditingController(),
                  label: 'C',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // `EditableTextState.focusNode` is private, so identify a field by the Focus
  // node EditableText wraps and ask the focus manager whether it is primary.
  // A suffix button owning focus matches none of them, which is the regression.
  bool ownsFocus(WidgetTester tester, int index) {
    final primary = FocusManager.instance.primaryFocus;
    if (primary == null) return false;
    return find
        .descendant(
          of: find.byType(EditableText).at(index),
          matching: find.byWidgetPredicate(
            (w) => w is Focus && identical(w.focusNode, primary),
          ),
        )
        .evaluate()
        .isNotEmpty;
  }

  testWidgets('Next moves from a field to the next field, not its buttons', (
    tester,
  ) async {
    await pumpForm(tester);
    await tester.showKeyboard(find.byType(EditableText).first);
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();

    expect(ownsFocus(tester, 1), isTrue, reason: 'B should own focus');
    expect(ownsFocus(tester, 0), isFalse);
  });

  testWidgets('Next chains across every field in order', (tester) async {
    await pumpForm(tester);
    await tester.showKeyboard(find.byType(EditableText).first);

    for (var expected = 1; expected < 3; expected++) {
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      expect(
        ownsFocus(tester, expected),
        isTrue,
        reason: 'step $expected should land on field $expected',
      );
    }
  });
}
