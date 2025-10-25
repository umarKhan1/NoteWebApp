import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notes_cubit.dart';

/// Sort popover widget with anchored positioning
class SortPopover extends StatefulWidget {
  /// Callback when Apply is tapped
  final VoidCallback onApply;

  /// Callback when Cancel is tapped
  final VoidCallback onCancel;

  /// Initial selected sort
  final NoteSortBy? initialSort;

  const SortPopover({
    super.key,
    required this.onApply,
    required this.onCancel,
    this.initialSort,
  });

  @override
  State<SortPopover> createState() => _SortPopoverState();
}

class _SortPopoverState extends State<SortPopover> {
  late NoteSortBy _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort ?? NoteSortBy.recentlyUpdated;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<NotesCubit>();

    const sortOptions = [
      (NoteSortBy.recentlyUpdated, 'Recently Updated'),
      (NoteSortBy.oldestFirst, 'Oldest First'),
      (NoteSortBy.titleAtoZ, 'Title (A-Z)'),
      (NoteSortBy.titleZtoA, 'Title (Z-A)'),
      (NoteSortBy.pinnedFirst, 'Pinned First'),
    ];

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Sort',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          // Sort options
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sortOptions
                      .map((option) {
                        final sortBy = option.$1;
                        final label = option.$2;
                        final isSelected = _selectedSort == sortBy;

                        return _SortTile(
                          label: label,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedSort = sortBy;
                            });
                          },
                        );
                      })
                      .toList(),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          // Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.sortNotes(_selectedSort);
                      widget.onApply();
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Single sort option tile
class _SortTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: theme.colorScheme.surfaceVariant,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: theme.colorScheme.primary,
                )
              else
                Icon(
                  Icons.radio_button_unchecked,
                  size: 20,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
