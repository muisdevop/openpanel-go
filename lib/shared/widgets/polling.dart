import 'dart:async';

import 'package:flutter/widgets.dart';

/// Runs [onTick] every [pollInterval] while the screen is actually on screen.
mixin PollingMixin<T extends StatefulWidget> on State<T> {
  Timer? _timer;
  AppLifecycleListener? _lifecycle;

  /// A tick can outlive its interval: a single request may sit behind the 30s
  /// receive timeout plus two retries, while `Timer.periodic` never waits for
  /// the callback it was given. Without this guard, ticks pile up and their
  /// responses race each other for the same state — an older response can land
  /// last and rewind the feed.
  bool _busy = false;

  Duration get pollInterval;

  Future<void> onTick();

  /// Override when the widget can be mounted but not visible. The shell uses
  /// `StatefulShellRoute.indexedStack`, which keeps every branch alive, so a
  /// backgrounded tab would otherwise poll forever and burn the API's 100
  /// requests per 10s limit on data nobody is looking at.
  bool shouldPoll() => true;

  void startPolling() {
    _lifecycle ??= AppLifecycleListener(
      onResume: () {
        _tick();
        _schedule();
      },
      onPause: _cancel,
      onHide: _cancel,
    );
    _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer.periodic(pollInterval, (_) => _tick());
  }

  void _tick() {
    if (!mounted || _busy || !shouldPoll()) return;
    _busy = true;
    unawaited(
      Future.sync(onTick)
          // `unawaited` drops the future without ever looking at its error, so
          // a tick that threw — a 401 from a rotated secret, a timeout after
          // the retries — escaped as an unhandled zone exception on every
          // interval. Polling is best-effort: the next tick retries and the
          // screen keeps showing the last good data, but the failure still has
          // to reach the error handler instead of vanishing.
          .catchError((Object error, StackTrace stackTrace) {
            FlutterError.reportError(
              FlutterErrorDetails(
                exception: error,
                stack: stackTrace,
                library: 'polling',
                context: ErrorDescription('while running a poll tick'),
              ),
            );
          })
          .whenComplete(() => _busy = false),
    );
  }

  void _cancel() => _timer?.cancel();

  @override
  void dispose() {
    _timer?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }
}
