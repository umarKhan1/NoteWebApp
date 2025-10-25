// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../cubit/notes_cubit.dart';

/// Content widget for sort popover
class SortContent extends StatefulWidget {
  /// Creates a [SortContent]
  const SortContent({
    super.key,
    required this.onApply,
    required this.onCancel,
    this.initialSort,
  });

  /// Callback when sort is applied
  final Function(NoteSortBy sortBy) onApply;

  /// Callback when sort is canceled
  final VoidCallback onCancel;

  /// Initial sort option
  final NoteSortBy? initialSort;

  @override
  State<SortContent> createState() => _SortContentState();
}

class _SortContentState extends State<SortContent> {
  late NoteSortBy _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort ?? NoteSortBy.recentlyUpdated;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = [
      (NoteSortBy.recentlyUpdated, 'Recently Updated'),
      (NoteSortBy.oldestFirst, 'Oldest First'),
      (NoteSortBy.titleAtoZ, 'Title (A-Z)'),
      (NoteSortBy.titleZtoA, 'Title (Z-A)'),
      (NoteSortBy.pinnedFirst, 'Pinned First'),
    ];

    return AlertDialog(
      title: const Text('Sort Notes'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.map((option) {
            final sortBy = option.$1;
            final label = option.$2;
            final isSelected = _selectedSort == sortBy;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSort = sortBy;
                  });
                },
                child: Row(
                  children: [
                    Radio<NoteSortBy>(
                      value: sortBy,
                      groupValue: _selectedSort,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSort = value;
                          });
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: widget.onCancel, child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_selectedSort);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
