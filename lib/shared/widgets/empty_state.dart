import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum EmptyIllustration { chart, radar, plug, search }

/// Empty state with a drawn illustration (no image assets needed).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.illustration = EmptyIllustration.chart,
    this.action,
    this.secondaryAction,
  });

  final String title;
  final String message;
  final EmptyIllustration illustration;
  final Widget? action;
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      // Scrollable because the illustration alone is 120dp: in landscape, or
      // at a large text scale with a long server error message, this column
      // exceeded the viewport and painted overflow stripes instead of the
      // retry button the user needed.
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 120,
              child: CustomPaint(painter: _IllustrationPainter(illustration)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: t.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
            if (secondaryAction != null) ...[
              const SizedBox(height: 8),
              secondaryAction!,
            ],
          ],
        ),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  _IllustrationPainter(this.kind);
  final EmptyIllustration kind;

  @override
  void paint(Canvas canvas, Size size) {
    final card = Paint()..color = AppColors.card;
    final border = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
      const Radius.circular(16),
    );
    // Glow
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.5,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                AppColors.accent.withValues(alpha: 0.18),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(
                center: size.center(Offset.zero),
                radius: size.width * 0.5,
              ),
            ),
    );
    canvas.drawRRect(rect, card);
    canvas.drawRRect(rect, border);

    final accent = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final muted = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    switch (kind) {
      case EmptyIllustration.chart:
        for (var i = 0; i < 5; i++) {
          final x = 34.0 + i * 22;
          final h = const <double>[18, 34, 26, 48, 38][i];
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, size.height - 26 - h, 12, h),
              const Radius.circular(3),
            ),
            Paint()
              ..color = AppColors.accent.withValues(alpha: 0.25 + i * 0.12),
          );
        }
        final path = Path()..moveTo(30, size.height - 50);
        path.cubicTo(
          60,
          size.height - 40,
          80,
          size.height - 90,
          130,
          size.height - 80,
        );
        canvas.drawPath(path, accent);
      case EmptyIllustration.radar:
        final c = size.center(Offset.zero);
        for (var r = 12.0; r <= 42; r += 15) {
          canvas.drawCircle(c, r, border);
        }
        canvas.drawLine(
          c,
          c + Offset(math.cos(-0.7) * 42, math.sin(-0.7) * 42),
          accent..strokeWidth = 2,
        );
        canvas.drawCircle(
          c + const Offset(22, -18),
          4,
          Paint()..color = AppColors.live,
        );
        canvas.drawCircle(
          c + const Offset(-26, 10),
          3,
          Paint()..color = AppColors.accentSoft,
        );
      case EmptyIllustration.plug:
        final c = size.center(Offset.zero);
        canvas.drawLine(
          c + const Offset(-50, 0),
          c + const Offset(-14, 0),
          muted,
        );
        canvas.drawLine(
          c + const Offset(14, 0),
          c + const Offset(50, 0),
          muted,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: c + const Offset(-10, 0),
              width: 18,
              height: 26,
            ),
            const Radius.circular(5),
          ),
          Paint()..color = AppColors.accent,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: c + const Offset(12, 0),
              width: 14,
              height: 26,
            ),
            const Radius.circular(5),
          ),
          Paint()..color = AppColors.textSecondary,
        );
      case EmptyIllustration.search:
        final c = size.center(Offset.zero) + const Offset(-6, -6);
        canvas.drawCircle(c, 22, accent);
        canvas.drawLine(
          c + const Offset(16, 16),
          c + const Offset(34, 34),
          accent..strokeWidth = 5,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _IllustrationPainter old) => old.kind != kind;
}
