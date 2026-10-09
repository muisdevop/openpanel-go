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
      _bootstrap();
    },
    (error, stack) => FlutterError.presentError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'unawaited',
        context: ErrorDescription('an error escaped a future nothing awaited'),
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
