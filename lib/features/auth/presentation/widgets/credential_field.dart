import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/theme/app_theme.dart';

/// Labeled text field with paste button, optional obscuring.
class CredentialField extends StatefulWidget {
  const CredentialField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.helper,
    this.icon,
    this.secret = false,
    this.required = true,
    this.keyboardType,
    this.validator,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? helper;
  final IconData? icon;
  final bool secret;
  final bool required;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  @override
  State<CredentialField> createState() => _CredentialFieldState();
}

class _CredentialFieldState extends State<CredentialField> {
  late bool _obscured = widget.secret;

  Future<void> _paste() async {
    final String? text;
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      text = data?.text?.trim();
    } on Object catch (e, st) {
      // Android raises a PlatformException when the read lands while the app
      // isn't focused. `IconButton.onPressed` is a VoidCallback, so this future
      // is discarded by the framework and the error used to escape to the zone.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: st,
          library: 'clipboard',
          context: ErrorDescription('while reading the clipboard to paste'),
        ),
      );
      return;
    }
    // The login screen disposes its controllers while this read is in flight
    // if the user leaves; writing to a disposed controller throws.
    if (!mounted || text == null || text.isEmpty) return;
    widget.controller.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscured,
        autocorrect: false,
        enableSuggestions: !widget.secret,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
        validator:
            widget.validator ??
            (v) => widget.required && (v == null || v.trim().isEmpty)
                ? '${widget.label} is required'
                : null,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          helperText: widget.helper,
          helperMaxLines: 2,
          helperStyle: const TextStyle(color: AppColors.textMuted),
          prefixIcon: widget.icon == null ? null : Icon(widget.icon, size: 20),
          // The suffix buttons sit between this field and the next one in
          // reading order, and IconButton is focusable by default, so
          // TextInputAction.next landed on "Paste" instead of the following
          // field. Keeping them out of the traversal order makes the keyboard's
          // Next key walk the form; they stay tappable and keep their semantics.
          suffixIcon: FocusTraversalGroup(
            descendantsAreTraversable: false,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.secret)
                  IconButton(
                    tooltip: _obscured ? 'Show' : 'Hide',
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  ),
                IconButton(
                  tooltip: 'Paste',
                  icon: const Icon(Icons.content_paste_rounded, size: 20),
                  onPressed: _paste,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
