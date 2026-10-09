import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in an external app and says so when it can't.
///
/// `launchUrl` resolves to `false` when no installed app handles the link (a
/// device with no browser, a typo'd self-hosted dashboard URL) and can throw a
/// PlatformException. Call sites used to ignore both, so a dead link was
/// indistinguishable from an unresponsive button.
Future<void> openExternalUrl(BuildContext context, String url) async {
  // Resolved before the await: the dialog or screen can be gone by the time
  // the launcher comes back.
  final messenger = ScaffoldMessenger.maybeOf(context);
  var opened = false;
  try {
    opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } on Exception {
    opened = false;
  }
  if (!opened) {
    messenger?.showSnackBar(
      SnackBar(content: Text('Nothing on this device can open $url')),
    );
  }
}
