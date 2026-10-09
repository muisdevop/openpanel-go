import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/insights/presentation/insights_screen.dart';
import '../../features/overview/presentation/overview_screen.dart';
import '../../features/realtime/presentation/realtime_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/home_shell.dart';
import '../providers.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Re-run redirects when the project list changes, without rebuilding
  // the router itself.
  final hasProjects = ValueNotifier<bool>(
    ref.read(projectsProvider).isNotEmpty,
  );
  ref.listen(
    projectsProvider,
    (_, next) => hasProjects.value = next.isNotEmpty,
  );
  ref.onDispose(hasProjects.dispose);

  final router = GoRouter(
    initialLocation: '/overview',
    refreshListenable: hasProjects,
    redirect: (context, state) {
      // Only the "no projects at all" case belongs here. A project that exists
      // but has no secret on this device is a *data* failure: activeApiProvider
      // throws ApiException.noCredentials and HomeShell renders a setup prompt
      // with a route back to the credential form. Redirecting here would evict
      // the user from the tab bar for a problem the shell can show inline.
      final loggingIn = state.matchedLocation == '/login';
      if (!hasProjects.value) return loggingIn ? null : '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, state) =>
            LoginScreen(editId: state.uri.queryParameters['edit']),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/overview',
                builder: (_, _) => const OverviewScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/realtime',
                builder: (_, _) => const RealtimeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/insights',
                builder: (_, _) => const InsightsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
