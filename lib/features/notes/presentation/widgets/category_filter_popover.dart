import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notes_cubit.dart';

/// Category filter popover widget with anchored positioning
class CategoryFilterPopover extends StatefulWidget {

  /// Creates a [CategoryFilterPopover]
  const CategoryFilterPopover({
    super.key,
    required this.onApply,
    required this.onCancel,
    this.initialCategory,
  });
  /// Callback when Apply is tapped
  final VoidCallback onApply;

  /// Callback when Cancel is tapped
  final VoidCallback onCancel;

  /// Initial selected category
  final String? initialCategory;

  @override
  State<CategoryFilterPopover> createState() => _CategoryFilterPopoverState();
}

class _CategoryFilterPopoverState extends State<CategoryFilterPopover> {
  late String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<NotesCubit>();

    // Get unique categories from allNotes, sorted A-Z
    final categories = <String>{};
    for (final note in cubit.allNotes) {
      if (note.category != null && note.category!.isNotEmpty) {
        categories.add(note.category!);
      }
    }
    final sortedCategories = categories.toList()..sort();

    // Count notes per category
    final categoryCounts = <String, int>{};
    for (final note in cubit.allNotes) {
      if (note.category != null && note.category!.isNotEmpty) {
        categoryCounts[note.category!] = (categoryCounts[note.category!] ?? 0) + 1;
      }
    }

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
              'Filter by Category',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          // Categories list
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // All option
                    _CategoryTile(
                      icon: Icons.check_circle,
                      label: 'All',
                      count: cubit.allNotes.length,
                      isSelected: _selectedCategory == null,
                      onTap: () {
                        setState(() {
                          _selectedCategory = null;
                        });
                      },
                    ),
                    // Category options
                    ...sortedCategories.map((category) {
                      return _CategoryTile(
                        icon: Icons.label,
                        label: category,
                        count: categoryCounts[category] ?? 0,
                        isSelected: _selectedCategory == category,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      );
                    }),
                  ],
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
                      if (_selectedCategory == null) {
                        cubit.filterByCategory(null);
                      } else {
                        cubit.filterByCategory(_selectedCategory);
                      }
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

/// Single category tile with icon, label, and count
class _CategoryTile extends StatelessWidget {

  const _CategoryTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: theme.colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
