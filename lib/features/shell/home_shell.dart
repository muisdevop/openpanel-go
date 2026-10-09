import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/api_exception.dart';
import '../../core/providers.dart';
import '../../shared/widgets/empty_state.dart';

/// True when [index] is the branch [HomeShell] is currently showing.
///
/// `StatefulShellRoute.indexedStack` keeps all four branches mounted and never
/// disposes them, so "mounted" is not the same as "on screen". Polling screens
/// must check this or a backgrounded tab keeps burning requests forever.
bool shellBranchIsActive(BuildContext context, int index) {
  final shell = context.findAncestorWidgetOfExactType<HomeShell>();
  if (shell == null) return true;
  return shell.navigationShell.currentIndex == index;
}

/// Bottom navigation shell for the four tabs.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(activeApiProvider);
    final project = ref.watch(activeProjectProvider);
    final rejectedStatus = ref.watch(credentialsRejectedProvider);
    // A selected project with no secret on this device can't serve any tab —
    // activeApi now fails instead of returning null, so every data provider
    // errors before it reaches the network. Intercept it here rather than
    // showing four screens that each say the same thing.
    // A server 401/403 is the same class of dead end (via rejectedStatus), and
    // `api.error` alone can't be an auth rejection: building the client never
    // touches the network.
    final failure = rejectedStatus != null
        ? ApiException.credentialsRejected(rejectedStatus)
        : api.hasError
        ? ApiException.from(api.error!)
        : null;
    final needsSetup =
        project != null &&
        failure != null &&
        (failure.needsSetup || rejectedStatus != null);

    return Scaffold(
      body: needsSetup && navigationShell.currentIndex != 3
          ? SafeArea(
              child: EmptyState(
                illustration: EmptyIllustration.plug,
                title: failure.title,
                message: failure.message,
                action: SizedBox(
                  width: 220,
                  child: FilledButton(
                    onPressed: () => context.push(
                      '/login?edit=${ref.read(activeProjectProvider)!.id}',
                    ),
                    child: const Text('Re-enter credentials'),
                  ),
                ),
              ),
            )
          : navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined),
            selectedIcon: Icon(Icons.space_dashboard_rounded),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.sensors_outlined),
            selectedIcon: Icon(Icons.sensors_rounded),
            label: 'Realtime',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
