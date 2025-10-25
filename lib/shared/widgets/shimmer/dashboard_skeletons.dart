import 'package:flutter/material.dart';
import 'shimmer_skeleton.dart';

/// Shimmer loading grid for dashboard stats
class DashboardStatsGridSkeleton extends StatelessWidget {
  /// Creates a [DashboardStatsGridSkeleton].
  const DashboardStatsGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveInfo = MediaQuery.of(context).size.width < 768;

    if (responsiveInfo) {
      // Mobile: 2x2 grid
      return const Column(
        children: [
          Row(
            children: [
              Expanded(child: StatCardSkeleton()),
              SizedBox(width: 8),
              Expanded(child: StatCardSkeleton()),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: StatCardSkeleton()),
              SizedBox(width: 8),
              Expanded(child: StatCardSkeleton()),
            ],
          ),
        ],
      );
    } else {
      // Desktop: 4 column grid
      return const Row(
        children: [
          Expanded(child: StatCardSkeleton()),
          SizedBox(width: 8),
          Expanded(child: StatCardSkeleton()),
          SizedBox(width: 8),
          Expanded(child: StatCardSkeleton()),
          SizedBox(width: 8),
          Expanded(child: StatCardSkeleton()),
        ],
      );
    }
  }
}

/// Shimmer loading skeleton for recent notes section
class RecentNotesSkeleton extends StatelessWidget {
  /// Creates a [RecentNotesSkeleton].
  const RecentNotesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Container(
              width: 60,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index == 2 ? 0 : 12),
                child: const SizedBox(width: 160, child: NoteCardSkeleton()),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Shimmer loading skeleton for activity section
class ActivitySectionSkeleton extends StatelessWidget {
  /// Creates an [ActivitySectionSkeleton].
  const ActivitySectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Container(
              width: 60,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: List.generate(
            4,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == 3 ? 0 : 12),
              child: const ActivityCardSkeleton(),
            ),
          ),
        ),
      ],
    );
  }
}

/// Shimmer loading skeleton for pinned notes section
class PinnedNotesSkeleton extends StatelessWidget {
  /// Creates a [PinnedNotesSkeleton].
  const PinnedNotesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 110,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Container(
              width: 60,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index == 1 ? 0 : 12),
                child: const SizedBox(width: 160, child: NoteCardSkeleton()),
              );
            },
          ),
        ),
      ],
    );
  }
}
