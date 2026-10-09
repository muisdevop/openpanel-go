import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_exception.dart';
import '../../core/utils/open_url.dart';
import '../theme/app_theme.dart';
import 'empty_state.dart';

/// Full-area error with a retry button and, for auth errors, an explainer.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
  });

  final Object error;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final e = ApiException.from(error);
    if (compact) {
      return SurfaceCard(
        child: Row(
          children: [
            Icon(_icon(e.kind), color: AppColors.negative, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                e.message,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
    }
    return EmptyState(
      illustration:
          e.kind == ApiErrorKind.network || e.kind == ApiErrorKind.timeout
          ? EmptyIllustration.plug
          : EmptyIllustration.search,
      title: e.title,
      message: e.message,
      action: onRetry == null
          ? null
          : SizedBox(
              width: 200,
              child: FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ),
      secondaryAction: e.isAuth
          ? TextButton(
              onPressed: () => showReadClientDialog(context),
              child: const Text('How do I create a READ client?'),
            )
          : null,
    );
  }

  static IconData _icon(ApiErrorKind k) => switch (k) {
    ApiErrorKind.network || ApiErrorKind.timeout => Icons.wifi_off_rounded,
    ApiErrorKind.unauthorized ||
    ApiErrorKind.forbidden => Icons.lock_outline_rounded,
    _ => Icons.error_outline_rounded,
  };
}

/// Explains READ vs WRITE clients. Shown on any 401/403.
Future<void> showReadClientDialog(BuildContext context) {
  final t = Theme.of(context).textTheme;
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.key_rounded, color: AppColors.warning),
      title: const Text('You need a READ client'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Every OpenPanel project comes with a WRITE client. It can send '
            'events but can\'t read them, so the API answers 401.',
            style: t.bodyMedium,
          ),
          const SizedBox(height: 12),
          for (final (i, s) in const [
            'Open dashboard.openpanel.dev (or your self-hosted dashboard)',
            'Project Settings → Clients',
            'Create client → Mode: Read',
            'Copy the Client ID and Secret (the secret is shown once)',
          ].indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('${i + 1}. $s', style: t.bodyMedium),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => openExternalUrl(ctx, ApiConstants.docsAuthUrl),
          child: const Text('Docs'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(88, 40)),
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}
