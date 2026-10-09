# OpenPanel Go

The first native mobile client for [OpenPanel](https://openpanel.dev) analytics.
Flutter, Material 3 dark, no WebView. It works with OpenPanel Cloud
(`https://api.openpanel.dev`) and any self-hosted instance.

> Unofficial community app. It isn't affiliated with the OpenPanel team.

## Features

| Tab | What it shows | API |
|---|---|---|
| **Overview** | Unique visitors, sessions, pageviews, bounce rate, visit duration and views per session, each with % change vs the previous period. Visitors and pageviews line chart with a dashed previous-period overlay. Polls every 60 s. | `GET /insights/{projectId}/metrics`, `GET /export/charts` |
| **Realtime** | The latest 100 events from the last 24 h with a pulsing Live badge, "online now" count, highlights for new events, client-side filters (event name, country, device), and a full detail sheet (profile, geo, device, referrer, properties) with a redacted "Copy as JSON". Polls every 10 s. | `GET /export/events`, `GET /insights/{projectId}/live` |
| **Insights** | Top referrers (bar chart), top pages, countries (pie with flags), devices (donut), browsers and OS. Tap any card for the full list. | `GET /insights/{projectId}/{column}`, falls back to `GET /export/charts?breakdowns=` |
| **Settings** | Multiple projects (add, edit, switch, remove), clear cache, log out (wipes every secret), about. | none |

Also included: date ranges (Today, Yesterday, 7d, 30d, Custom), pull-to-refresh,
shimmer skeletons, drawn empty states, offline fallback for KPIs, and polling
that pauses both when the app is backgrounded and when its tab is hidden behind
another one. Animations (shimmer, the Live pulse) are skipped when the device
requests reduced motion.

## 1. Create a READ client (required)

Every OpenPanel project ships with a **WRITE** client. It can send events but
can't read them, so the API answers **401**.

1. Open [dashboard.openpanel.dev](https://dashboard.openpanel.dev) (or your self-hosted dashboard).
2. Go to **Project Settings → Clients → Create client**.
3. Set **Mode: Read**. Root also works, but Read is all the app needs.
4. Copy the **Client ID** and **Client Secret**. The secret is only shown once.
5. Copy the **Project ID** from the dashboard URL: `dashboard.openpanel.dev/<org>/<projectId>`.

In the app, choose **OpenPanel Cloud** or **Self-hosted** (enter your API base
URL, e.g. `https://api.yourdomain.com`), paste the four values and tap **Connect
project**. That button is not a dry run: it verifies the credentials against the
API and, on success, saves the project and selects it. If it fails, nothing is
saved.

| Status | Meaning in the app |
|---|---|
| 401 | WRITE client, or a wrong ID/secret. Create a READ client. |
| 403 | The READ client belongs to a different project. |
| 404 | Wrong Project ID, or the Base URL isn't the OpenPanel API. |
| 429 | Rate limit (100 requests per 10 s). Retried with backoff. |

Self-hosted Base URLs must be `https://`. Plain `http://` is accepted only for
`localhost`, `127.0.0.1`, `::1` and `10.0.2.2`, because that is all the OS
network policy allows (see [Security](#security)).

## 2. Run it

Requires Flutter **3.47+** and Dart **3.13+** — `pubspec.yaml` pins
`flutter: ">=3.47.0"` and `sdk: ^3.13.0`, and CI builds with 3.47.2. The older
`^3.8.0` constraint in the template was not satisfiable by the resolved
dependency graph.

```bash
git clone https://github.com/muisdevop/openpanel-go.git
cd openpanel-go
flutter pub get
dart run build_runner build      # freezed / json / riverpod codegen
flutter run
```

Optional debug prefill so you don't retype credentials:

```bash
cp .env.example .env             # fill it in; .env is git-ignored
flutter run --dart-define-from-file=.env
```

The prefill only applies in debug builds. Credentials are never read from
`.env` in release builds.

## 3. Build

```bash
# Android
flutter build apk --release            # build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle --release      # Play Store

# iOS (macOS + Xcode)
cd ios && pod install && cd ..
flutter build ipa --release            # set your Team in Xcode first
```

Release builds run R8 (`isMinifyEnabled` + `isShrinkResources`) with the keep
rules in `android/app/proguard-rules.pro`; without it the APK carries every
plugin class and full symbol tables.

For a Play Store release, put your keystore in `android/key.properties`
(also git-ignored):

```properties
storeFile=../release.keystore
storePassword=…
keyAlias=…
keyPassword=…
```

`android/app/build.gradle.kts` reads it if present. **If it is absent the build
falls back to the debug key** so `flutter build apk --release` keeps working
locally — but a debug-signed APK is not a release artifact. The debug keystore is
public, so anyone could sign an update that installs over that APK and takes the
stored credentials. The CI workflow names the artifact
`openpanel-go-apk-DEBUG-SIGNED` and emits a build warning whenever
`key.properties` is missing; treat that name as a stop signal.

### Verified contents of `app-release.apk`

Read out of the built artifact, not asserted from the source tree:

- `minSdk 24`, `targetSdk 36`, `compileSdk 36`, `debuggable` absent.
- One runtime permission: `android.permission.INTERNET` (plus the
  `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` AGP adds itself). No storage,
  location or camera permission to abuse.
- `android:allowBackup=false`, `android:dataExtractionRules` and
  `android:networkSecurityConfig` all resolve in the shipped manifest, so the
  backup and cleartext rules below really are in the distributed file.
- R8 ran: a single 1.05 MB `classes.dex`, `mapping.txt` and a resource-shrinking
  report. The 58 MB size is three ABIs of Flutter native libraries
  (`arm64-v8a`, `armeabi-v7a`, `x86_64`), not Dart or Java code — ship
  `flutter build appbundle`, or `flutter build apk --split-per-abi`, for
  downloads.

### If `flutter build apk --release` fails on Windows

Two separate failures are known, and the first is misreported by the tooling:

- **`Could not close incremental caches … .tab`** in a plugin module. The real
  cause is under the `Suppressed:` lines: Kotlin's incremental cache stores
  source paths with `File.relativeTo` against the project directory, so when the
  Pub cache (`C:\Users\…\AppData\Local\Pub\Cache`) is on a **different drive**
  than the project (`D:\…`), it throws `this and base files have different
  roots`. Disable incremental Kotlin compilation for that build:

  ```bash
  GRADLE_OPTS="-Dorg.gradle.project.kotlin.incremental=false" flutter build apk --release
  ```

  Or move the caches onto the project's drive (`PUB_CACHE`, `GRADLE_USER_HOME`).
  This is a host layout problem, not a project setting, so it is not baked into
  `android/gradle.properties` — CI on Linux never sees it.
- **R8: `Missing class com.google.android.play.core.…`** is *not* environmental.
  Flutter's deferred-components glue references Play Core, which this app doesn't
  depend on. `android/app/proguard-rules.pro` carries the
  `-dontwarn com.google.android.play.core.**` rule that AGP asks for; deleting it
  breaks every release build, on every machine.

## Security

The client secret is a **read key for your whole project's analytics**, and it
goes in a request header — so the threat model is "whatever ends up on this
phone, and whatever leaves it".

**Where the secret lives**
- Client secret and client ID live only in `flutter_secure_storage` (iOS
  Keychain with `first_unlock_this_device`, Android Keystore-backed storage).
- Hive holds only non-secret data: project name, Project ID, base URL, the
  selected range, and a small metrics cache.
- **Log out** wipes every secure-storage entry and all three Hive boxes.

**Where it can't go**
- `allowBackup=false`, `fullBackupContent=false` and `dataExtractionRules`
  disable cloud backup, Auto Backup and adb backup of app data. Without this, a
  device-to-device transfer or `adb backup` copies the unencrypted Hive boxes —
  and the KPI cache of a project you thought you'd logged out of.
- The debug logger runs with `requestHeader: false`, so headers are never
  printed. `ApiCredentials.toString()` redacts the secret, and the event detail
  sheet renders redacted rather than raw values.
- The "Copy as JSON" button in the event sheet strips direct identifiers before
  the payload reaches the clipboard (email / first / last name, profile
  properties, avatar, latitude / longitude, and any custom property whose key
  looks like personal data). The clipboard is a shared surface — other apps can
  read it and OS clipboard sync can push it to other devices. Pseudonymous ids
  (`id`, `sessionId`) are kept so a copied event is still debuggable.

**Transport**
- `network_security_config.xml` leaves cleartext off globally and permits
  `http://` only for `localhost`, `127.0.0.1` and `10.0.2.2` (the emulator
  address for a host dev server). iOS mirrors this with
  `NSAppTransportSecurity → NSAllowsLocalNetworking`, not
  `NSAllowsArbitraryLoads`.
- The login form rejects a non-loopback `http://` Base URL at input time rather
  than letting the OS kill the request and show an opaque "connection failed".
- Project IDs and breakdown columns are percent-encoded before they are
  interpolated into a path.

**Rate limits and state**
- Auth uses the two OpenPanel headers `openpanel-client-id` and
  `openpanel-client-secret` (not Bearer), injected per request by a Dio
  interceptor.
- `OpenPanelApi` queues requests through a 3-slot in-flight limit instead of
  fanning out. Insights issues six requests and Overview polls four a minute;
  an unbounded burst against a slow self-hosted server earns a 429.
- Retries live inside the queued call, not in a Dio interceptor: an interceptor
  retry re-enters the raw Dio and escapes the queue, so three queued requests
  plus their retries all land at once. A 429 waits the full 10 s window (or
  whatever `Retry-After` asks for) while releasing its slot; 401/403/404 are
  never retried, because they cannot succeed on a second attempt.
- The first 401 or 403 on any endpoint flips a shared "credentials rejected"
  flag, and the shell replaces the four tabs with one screen that offers to
  re-enter them. Without it, a rotated or write-mode secret left every tab
  rendering the same error card and every poll timer re-requesting a doomed
  endpoint for as long as the app stayed open.
- A cached response is a snapshot, so cache entries carry a timestamp: they
  expire after 24 h, the box is capped at 200 entries evicted oldest-first, and
  removing a project deletes its `metrics:<projectId>:*` keys. Preset ranges
  encode no calendar dates in the key, so without a TTL an offline launch weeks
  later would present a weeks-old snapshot as current traffic.
- Toggling "clear cache" does not dispose the live Dio client; that used to
  cancel whatever request the screen you had just left was running.

## Architecture

```
lib/
├── core/
│   ├── constants/api_constants.dart     endpoints, headers, intervals
│   ├── network/                         Dio client, auth/retry/error interceptors, ApiException
│   ├── storage/                         secure storage (secrets) + Hive (everything else)
│   ├── models/                          ProjectConfig (freezed), SelectedDateRange
│   ├── router/app_router.dart           go_router + StatefulShellRoute
│   ├── providers.dart                   projects, active project, API client, date range
│   └── utils/                           formatters.dart, open_url.dart
├── features/
│   ├── auth/        data/auth_repository.dart, presentation/login_screen.dart
│   ├── overview/    data/ (models, repository), presentation/ (screen, KPI card, chart)
│   ├── realtime/    data/ (event models, repository, polling notifier), presentation/
│   ├── insights/    data/insights_repository.dart, presentation/
│   ├── settings/    presentation/settings_screen.dart
│   └── shell/       bottom navigation + HomeShell (exposes branch index)
└── shared/          theme, empty/error/skeleton widgets, project & date pickers, polling mixin
```

State is Riverpod 3 with `riverpod_generator`. Every data provider derives
from `activeApiProvider`, so switching project or date range refetches
everything automatically.

`shared/widgets/polling.dart` is the single `Timer.periodic` implementation
behind both polling screens. It guards against re-entrancy (a periodic timer
does not await its callback, so a slow tick used to overlap the next one and
cancel requests mid-flight), pauses while the app is in the background, and
pauses while its shell tab is inactive — `StatefulShellRoute` keeps every
branch mounted, so without that check the Overview tab polled a request every
60 s while you were reading Realtime.

### API notes

- `/export/events` returns newest first (`created_at DESC`). There's no
  `orderBy` parameter. The app sends `start` = now − 24 h and
  `includes=profile,properties,region,device,…`.
- `/export/charts` takes `series` and `breakdowns` as JSON-encoded query
  params, e.g. `series=[{"name":"screen_view","segment":"user"}]`.
- Overview KPIs and Insights breakdowns use the Insights API. It's the same
  READ client and the same session-based numbers the web dashboard shows. If
  a self-hosted server has no `/insights` routes (404), Insights falls back to
  `/export/charts` breakdowns.
- freezed's generated `toJson()` is **shallow**: nested models stay as objects
  and are only expanded when the JSON encoder calls their own `toJson()`.
  Anything that inspects `json['profile'] as Map` must round-trip through the
  encoder first.

## Tests

```bash
flutter test              # 52 tests
flutter test --coverage
```

Covers date-range math (including that the previous window shifts by calendar
days, not elapsed ones, and month-boundary windows), chart and event parsing,
the clipboard redaction pass, the 401 → READ-client mapping and the other
status → message mappings, secret redaction, the Hive cache layer (TTL, the
200-entry LRU cap, per-project eviction, active project and range persistence
across reopen), the polling mixin (a slow tick does not overlap, a hidden tab
does not poll, dispose kills the timer), tolerant value coercion (a metric
serialised as a string, or one malformed event row, costs that value instead of
blanking the screen), cache-key identity for day-granularity presets, and the
auth-rejection hook (a 401/403 is reported once and never retried, a 5xx is
retried and must not look like a rejected credential) plus a widget test over
the real shell (a 401 unmounts all four tabs into one credential prompt, while
Settings stays reachable so the project can still be fixed or removed).

`flutter analyze` must stay clean. `analysis_options.yaml` turns on
`unawaited_futures`, `directives_ordering`, `cancel_subscriptions`,
`close_sinks`, `curly_braces_in_flow_control_structures` and a few others on top
of `flutter_lints`; `unawaited_futures` in particular is what keeps the
"fire-and-forget a mutation" bug family from coming back. CI
(`.github/workflows/build.yml`) pins the Flutter version, runs codegen and
fails if `git diff` is non-empty (generated files must be committed and match),
asserts `dart format` is clean, runs the tests with coverage, then builds the
APK and the app bundle.

## License

MIT
