import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/models/project_config.dart';
import '../../../core/providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/open_url.dart';
import '../../../shared/theme/app_theme.dart';

final _packageInfoProvider = FutureProvider<PackageInfo>(
  (_) => PackageInfo.fromPlatform(),
);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ProjectConfig p,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove ${p.name}?'),
        content: const Text(
          'Its client ID and secret are deleted from this device. Your '
          'OpenPanel data isn\'t touched.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.negative),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(projectsProvider.notifier).remove(p.id);
    } on Object catch (e) {
      // Keychain deletes can fail. Without this the list drops the row while
      // the secret stays on the device, and nothing tells the user either
      // happened.
      messenger.showSnackBar(
        SnackBar(content: Text('Couldn\'t remove ${p.name}: $e')),
      );
      return;
    }
    if (context.mounted && ref.read(projectsProvider).isEmpty) {
      context.go('/login');
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'Removes every saved project and wipes all client secrets from '
          'secure storage on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.negative),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(projectsProvider.notifier).logout();
    } on Object {
      // Leaving the user on Settings believing every secret was wiped is worse
      // than the error itself.
      messenger.showSnackBar(
        const SnackBar(content: Text('Log out failed — secrets may remain')),
      );
      return;
    }
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final active = ref.watch(activeProjectProvider);
    final info = ref.watch(_packageInfoProvider).value;
    final t = Theme.of(context).textTheme;

    Widget header(String s) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 8),
      child: Text(
        s.toUpperCase(),
        style: t.labelSmall?.copyWith(
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          if (active != null) ...[
            header('Current project'),
            SurfaceCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  _InfoRow(label: 'Name', value: active.name),
                  const Divider(height: 1),
                  _InfoRow(label: 'Project ID', value: active.projectId),
                  const Divider(height: 1),
                  _InfoRow(label: 'Base URL', value: active.baseUrl),
                  const Divider(height: 1),
                  const _InfoRow(
                    label: 'Client secret',
                    value: '•••••••• (Keychain)',
                  ),
                ],
              ),
            ),
          ],
          header('Projects'),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                for (final p in projects) ...[
                  ListTile(
                    leading: Icon(
                      p.id == active?.id
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: p.id == active?.id ? AppColors.accent : null,
                    ),
                    title: Text(p.name),
                    subtitle: Text(
                      urlHost(p.baseUrl),
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                    onTap: () {
                      // `select` never throws: it swallows its own persistence
                      // failure after applying the in-memory selection.
                      unawaited(
                        ref.read(activeProjectIdProvider.notifier).select(p.id),
                      );
                    },
                    trailing: PopupMenuButton<String>(
                      tooltip: 'Edit or remove ${p.name}',
                      icon: const Icon(Icons.more_horiz_rounded),
                      onSelected: (v) {
                        if (v == 'edit') {
                          unawaited(context.push('/login?edit=${p.id}'));
                        }
                        // Handles its own failures (snack bar) and re-checks
                        // `context.mounted` before navigating.
                        if (v == 'delete') {
                          unawaited(_confirmDelete(context, ref, p));
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Remove')),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
                ListTile(
                  leading: const Icon(
                    Icons.add_rounded,
                    color: AppColors.accent,
                  ),
                  title: const Text('Add project'),
                  onTap: () {
                    // Guarded: the tile stays hitable through the push
                    // animation, so a fast double tap stacked two identical
                    // /login routes and the close gesture left the user on a
                    // second blank form.
                    if (ModalRoute.of(context)?.isCurrent ?? true) {
                      unawaited(context.push('/login'));
                    }
                  },
                ),
              ],
            ),
          ),
          header('Data'),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined),
                  title: const Text('Clear cache'),
                  subtitle: const Text(
                    'Offline copies of KPIs',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await ref.read(localStoreProvider).clearCache();
                    // Deliberately not invalidating activeApiProvider: that
                    // disposed the live client, cancelling whatever request was
                    // in flight on the screen the user had just left. The cache
                    // is only read when a fetch fails, so the next refresh
                    // repopulates it on its own.
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Cache cleared — refetched on next refresh',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.negative,
                  ),
                  title: const Text(
                    'Log out',
                    style: TextStyle(color: AppColors.negative),
                  ),
                  subtitle: const Text(
                    'Remove all projects and secrets',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  onTap: () => _logout(context, ref),
                ),
              ],
            ),
          ),
          header('About'),
          SurfaceCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _LinkTile(
                  icon: Icons.language_rounded,
                  title: 'openpanel.dev',
                  url: ApiConstants.websiteUrl,
                ),
                const Divider(height: 1),
                _LinkTile(
                  icon: Icons.code_rounded,
                  title: 'GitHub repository',
                  url: ApiConstants.repoUrl,
                ),
                const Divider(height: 1),
                _LinkTile(
                  icon: Icons.menu_book_rounded,
                  title: 'Export API docs',
                  url: ApiConstants.docsExportUrl,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('Version'),
                  trailing: Text(
                    info == null
                        ? '…'
                        : '${info.version} (${info.buildNumber})',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'OpenPanel Go · unofficial client',
              style: t.labelSmall?.copyWith(color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              textAlign: TextAlign.end,
              style: t.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.icon, required this.title, required this.url});
  final IconData icon;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
      onTap: () => openExternalUrl(context, url),
    );
  }
}
