import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'core/providers.dart';
import 'core/router/app_router.dart';
import 'core/storage/local_store.dart';
import 'shared/theme/app_theme.dart';

void main() {
  // Nothing in a Flutter app awaits every future. A poll tick that outlives its
  // widget, or a refresh whose screen is swapped away mid-flight, throws into a
  // zone that has no handler by default: the error is written to logcat, the
  // isolate carries on, and a release user is left staring at a card that
  // quietly stopped updating with nothing recording why. Routing every escape
  // through one handler keeps failures attributable and gives a crash reporter
  // a single place to hook.
  runZonedGuarded<void>(
    () {
      FlutterError.onError = FlutterError.presentError;
      unawaited(_bootstrap());
    },
    (error, stack) {
      FlutterError.presentError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'unawaited',
          context: ErrorDescription(
            'an error escaped a future nothing awaited',
          ),
        ),
      );
      // Startup failures have no widget tree to display them. `LocalStore.open`
      // throws on a corrupted or unreadable Hive box, and before this the app
      // died with a logcat line and a black screen — which on a release device,
      // where nobody reads logcat, is indistinguishable from a hung install.
      _showStartupFailure(error);
    },
  );
}

void _showStartupFailure(Object error) {
  // Idempotent, so it still works if the failure landed before `_bootstrap` got
  // to it. `rootElement` is what distinguishes a startup crash from any later
  // one: once the app is on screen, replacing its tree with an error page would
  // turn a recoverable background failure into a dead app.
  final binding = WidgetsFlutterBinding.ensureInitialized();
  if (binding.rootElement != null) return;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storage_rounded, size: 40),
                const SizedBox(height: 16),
                const Text(
                  textAlign: TextAlign.center,
                  'OpenPanel Go could not open its local storage.',
                ),
                const SizedBox(height: 8),
                const Text(
                  textAlign: TextAlign.center,
                  // The stored boxes hold the project list and cached numbers,
                  // never a secret — clearing them costs no credentials.
                  'Reinstall the app to start fresh. Saved projects will need '
                  'their credentials entered again; your OpenPanel data is not '
                  'affected.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                Text(
                  // Only ever a local storage error (box path, file format). The
                  // app never reaches a network call before this point, so there
                  // is no server body to leak.
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                  error.toString(),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  // Every string, date and number format in this app is English. Pinning the
  // default locale keeps DateFormat/timeago deterministic instead of following
  // ambient state if a locale is added later.
  Intl.defaultLocale = 'en';
  // Inter is NOT bundled: there is no fonts/ asset in this repo, so GoogleFonts
  // downloads it from fonts.gstatic.com on first use and caches it. Keeping
  // runtime fetching on is deliberate — turning it off without shipping the TTFs
  // silently drops the app back to the system font. The tradeoff is a first-run
  // network dependency and a font request that identifies this app to Google.
  GoogleFonts.config.allowRuntimeFetching = true;
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
    ),
  );

  final store = await LocalStore.open();

  runApp(
    ProviderScope(
      overrides: [localStoreProvider.overrideWithValue(store)],
      // Auth/404 errors won't fix themselves; the Dio layer already retries
      // transient failures, so turn off Riverpod's automatic retry.
      retry: (_, _) => null,
      child: const OpenPanelGoApp(),
    ),
  );
}

class OpenPanelGoApp extends ConsumerWidget {
  const OpenPanelGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'OpenPanel Go',
      debugShowCheckedModeBanner: false,
      // English only. Claiming more would need flutter_localizations plus
      // Global*Localizations delegates and extracted strings — without them
      // Flutter falls back to English anyway, so this is documentation that the
      // framework can act on rather than an aspiration.
      supportedLocales: const [Locale('en')],
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
