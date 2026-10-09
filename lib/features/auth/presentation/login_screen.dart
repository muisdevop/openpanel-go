import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/models/project_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/open_url.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../data/auth_repository.dart';
import 'widgets/credential_field.dart';

enum _Host { cloud, selfHosted }

/// `/login` — add a project, or edit one with `/login?edit=<id>`.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.editId});

  final String? editId;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrl = TextEditingController(text: ApiConstants.defaultBaseUrl);
  final _projectId = TextEditingController();
  final _clientId = TextEditingController();
  final _secret = TextEditingController();
  final _name = TextEditingController();

  _Host _host = _Host.cloud;
  bool _busy = false;
  ApiException? _error;
  String? _success;
  ProjectConfig? _editing;

  // Optional debug prefill: flutter run --dart-define-from-file=.env
  static const _envBaseUrl = String.fromEnvironment('OP_BASE_URL');
  static const _envProjectId = String.fromEnvironment('OP_PROJECT_ID');
  static const _envClientId = String.fromEnvironment('OP_CLIENT_ID');
  static const _envSecret = String.fromEnvironment('OP_CLIENT_SECRET');
  static const _envName = String.fromEnvironment('OP_PROJECT_NAME');

  static const _loopbackHosts = {'localhost', '127.0.0.1', '::1', '10.0.2.2'};

  void _onFieldEdited() {
    // The API-failure banner used to outlive the typo that caused it: it stayed
    // red under a field the user had already corrected until the next submit.
    // Guarded by state, so the programmatic fills during init/prefill (which
    // fire this listener) never call setState for nothing.
    if (_error != null || _success != null) {
      setState(() {
        _error = null;
        _success = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    for (final c in [_baseUrl, _projectId, _clientId, _secret, _name]) {
      c.addListener(_onFieldEdited);
    }
    if (widget.editId == null && kDebugMode) {
      if (_envBaseUrl.isNotEmpty) {
        _baseUrl.text = _envBaseUrl;
        if (_envBaseUrl != ApiConstants.defaultBaseUrl) {
          _host = _Host.selfHosted;
        }
      }
      _projectId.text = _envProjectId;
      _clientId.text = _envClientId;
      _secret.text = _envSecret;
      _name.text = _envName;
    }
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final id = widget.editId;
    if (id == null) return;
    final project = ref
        .read(projectsProvider)
        .where((p) => p.id == id)
        .firstOrNull;
    if (project == null) return;
    final clientId = await ref.read(authRepositoryProvider).readClientId(id);
    if (!mounted) return;
    setState(() {
      _editing = project;
      _baseUrl.text = project.baseUrl;
      _projectId.text = project.projectId;
      _name.text = project.name;
      _clientId.text = clientId ?? '';
      _host = project.baseUrl == ApiConstants.defaultBaseUrl
          ? _Host.cloud
          : _Host.selfHosted;
    });
  }

  @override
  void dispose() {
    for (final c in [_baseUrl, _projectId, _clientId, _secret, _name]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _connect() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
      _success = null;
    });
    final repo = ref.read(authRepositoryProvider);
    try {
      var secret = _secret.text.trim();
      if (secret.isEmpty && _editing != null) {
        secret =
            (await ref
                    .read(secureStorageProvider)
                    .readCredentials(_editing!.id))
                ?.clientSecret ??
            '';
      }
      final result = await repo.testConnection(
        baseUrl: _baseUrl.text,
        projectId: _projectId.text,
        clientId: _clientId.text,
        clientSecret: secret,
      );
      final saved = await repo.saveProject(
        existingId: _editing?.id,
        createdAt: _editing?.createdAt,
        name: _name.text,
        baseUrl: _baseUrl.text,
        projectId: _projectId.text,
        clientId: _clientId.text,
        clientSecret: secret,
      );
      // Awaited: navigating to /overview before the selection lands can render
      // the previous project for a frame or two.
      await ref.read(activeProjectIdProvider.notifier).select(saved.id);
      ref.invalidate(activeApiProvider);
      if (!mounted) return;
      setState(
        () => _success = result.totalEvents == null
            ? 'Connected'
            : 'Connected · ${Fmt.compact(result.totalEvents)} events in the last 12h',
      );
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (mounted) context.go('/overview');
    } catch (e) {
      final err = ApiException.from(e);
      if (!mounted) return;
      setState(() => _error = err);
      // Not awaited: awaiting the dialog would hold the button in its busy
      // state until the user dismisses the explainer.
      if (err.isAuth) unawaited(showReadClientDialog(context));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final hasProjects = ref.watch(projectsProvider).isNotEmpty;
    final editing = _editing != null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: hasProjects
            ? IconButton(
                tooltip: 'Close',
                icon: const Icon(Icons.close_rounded),
                onPressed: () =>
                    context.canPop() ? context.pop() : context.go('/settings'),
              )
            : null,
        title: Text(editing ? 'Edit project' : 'Connect a project'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              if (!hasProjects) ...[
                EmptyState(
                  illustration: EmptyIllustration.chart,
                  title: 'OpenPanel in your pocket',
                  message:
                      'Paste a READ client from your OpenPanel project to see '
                      'visitors, live events and top pages on the go.',
                  secondaryAction: TextButton.icon(
                    onPressed: () =>
                        openExternalUrl(context, ApiConstants.docsAuthUrl),
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    label: const Text('How to create a READ client'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              SegmentedButton<_Host>(
                segments: const [
                  ButtonSegment(
                    value: _Host.cloud,
                    icon: Icon(Icons.cloud_outlined),
                    label: Text('OpenPanel Cloud'),
                  ),
                  ButtonSegment(
                    value: _Host.selfHosted,
                    icon: Icon(Icons.dns_outlined),
                    label: Text('Self-hosted'),
                  ),
                ],
                selected: {_host},
                onSelectionChanged: (s) => setState(() {
                  _host = s.first;
                  if (_host == _Host.cloud) {
                    _baseUrl.text = ApiConstants.defaultBaseUrl;
                  } else if (_baseUrl.text == ApiConstants.defaultBaseUrl) {
                    _baseUrl.text = 'https://';
                  }
                }),
              ),
              const SizedBox(height: 20),
              if (_host == _Host.selfHosted)
                CredentialField(
                  controller: _baseUrl,
                  label: 'Base URL',
                  hint: 'https://api.yourdomain.com',
                  helper:
                      'Your API origin, e.g. https://api.yourdomain.com '
                      'or https://yourdomain.com/api',
                  icon: Icons.link_rounded,
                  keyboardType: TextInputType.url,
                  validator: (v) {
                    final u = Uri.tryParse((v ?? '').trim());
                    if (u == null || !u.hasScheme || u.host.isEmpty) {
                      return 'Enter a full URL, like https://api.yourdomain.com';
                    }
                    if (u.scheme != 'https' && u.scheme != 'http') {
                      return 'The Base URL must start with https://';
                    }
                    // Cleartext is blocked by the OS: Android ships a network
                    // security config that permits http only on loopback, and
                    // iOS ATS blocks arbitrary http outright. Rejecting it here
                    // beats a baffling "connection failed" later.
                    if (u.scheme == 'http' &&
                        !_loopbackHosts.contains(u.host)) {
                      return 'http:// only reaches a server on this device. '
                          'Use https:// for a remote server.';
                    }
                    return null;
                  },
                ),
              CredentialField(
                controller: _name,
                label: 'Project name',
                hint: 'My website',
                icon: Icons.label_outline_rounded,
                required: false,
              ),
              CredentialField(
                controller: _projectId,
                label: 'Project ID',
                hint: 'From the dashboard URL or Project Settings',
                icon: Icons.folder_outlined,
              ),
              CredentialField(
                controller: _clientId,
                label: 'Client ID',
                hint: 'xxxxxxxx-xxxx-4xxx-xxxx-xxxxxxxxxxxx',
                icon: Icons.badge_outlined,
              ),
              CredentialField(
                controller: _secret,
                label: 'Client Secret',
                hint: editing
                    ? 'Leave empty to keep the saved secret'
                    : 'sec_…',
                helper:
                    'Stored in the device Keychain / Keystore. Never logged.',
                icon: Icons.key_rounded,
                secret: true,
                required: !editing,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 4),
              _StatusBanner(error: _error, success: _success),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _busy ? null : _connect,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.bolt_rounded),
                // This button verifies the credentials, saves them, selects the
                // project and leaves the screen — the old "Test Connection"
                // label hid the fact that pressing it mutates a saved project.
                label: Text(
                  _busy
                      ? 'Connecting…'
                      : editing
                      ? 'Save & connect'
                      : 'Connect project',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'The default client on every project is WRITE-only. The app '
                'needs a READ client: Project Settings → Clients → Create '
                'client → Mode: Read.',
                textAlign: TextAlign.center,
                style: t.bodySmall?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({this.error, this.success});
  final ApiException? error;
  final String? success;

  @override
  Widget build(BuildContext context) {
    if (error == null && success == null) return const SizedBox.shrink();
    final ok = success != null;
    final color = ok ? AppColors.positive : AppColors.negative;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.error_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ok ? success! : error!.title,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: color),
                ),
                if (!ok) ...[
                  const SizedBox(height: 4),
                  Text(
                    error!.message,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (error!.detail != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Server: ${error!.detail}',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
