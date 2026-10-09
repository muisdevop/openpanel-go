import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme.dart';

/// Shimmering placeholder block.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height = 16, this.radius = 8});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      // A null width next to a non-null child collapses to zero in the
      // crossAxisAlignment.start columns that use this, which rendered the
      // whole chart skeleton as an empty card.
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cardHigh,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    // A continuously animating shimmer is the worst case for vestibular
    // sensitivity and burns battery; honour the OS "reduce motion" setting.
    if (MediaQuery.disableAnimationsOf(context)) return placeholder;
    return Shimmer.fromColors(
      baseColor: AppColors.cardHigh,
      highlightColor: const Color(0xFF2E2E2E),
      child: placeholder,
    );
  }
}

class KpiSkeleton extends StatelessWidget {
  const KpiSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SkeletonBox(width: 90, height: 12),
          SkeletonBox(width: 70, height: 26),
          SkeletonBox(width: 50, height: 12),
        ],
      ),
    );
  }
}

class ChartSkeleton extends StatelessWidget {
  const ChartSkeleton({super.key, this.height = 220});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 120, height: 14),
          const SizedBox(height: 16),
          SkeletonBox(height: height, radius: 12),
        ],
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key, this.rows = 8});
  final int rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows; i++)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                SkeletonBox(width: 36, height: 36, radius: 10),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 140, height: 12),
                      SizedBox(height: 8),
                      SkeletonBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
