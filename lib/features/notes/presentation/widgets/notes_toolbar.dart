import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';

/// Toolbar widget for searching, filtering, and sorting notes
class NotesToolbar extends StatefulWidget {
  /// Creates a new [NotesToolbar].
  const NotesToolbar({super.key});

  @override
  State<NotesToolbar> createState() => _NotesToolbarState();
}

class _NotesToolbarState extends State<NotesToolbar> {
  late TextEditingController _searchController;
  String? _selectedCategory;
  NoteSortBy _selectedSort = NoteSortBy.recentlyUpdated;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<NotesCubit>().searchNotes('');
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                context.read<NotesCubit>().searchNotes(value);
                setState(() {});
              },
            ),
          ),
        ),

        // Filter and Sort buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Filter button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filters'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _showFilters
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Sort dropdown
              Expanded(
                child: _buildSortDropdown(theme),
              ),

              // Clear all filters
              if (_searchController.text.isNotEmpty ||
                  _selectedCategory != null)
                const SizedBox(width: 12),
              if (_searchController.text.isNotEmpty ||
                  _selectedCategory != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Clear all filters',
                  onPressed: () {
                    _searchController.clear();
                    _selectedCategory = null;
                    _selectedSort = NoteSortBy.recentlyUpdated;
                    context.read<NotesCubit>().resetFilters();
                    setState(() {
                      _showFilters = false;
                    });
                  },
                ),
            ],
          ),
        ),

        // Expanded filter options
        if (_showFilters) _buildFilterPanel(theme),
      ],
    );
  }

  Widget _buildSortDropdown(ThemeData theme) {
    return DropdownButtonFormField<NoteSortBy>(
      initialValue: _selectedSort,
      decoration: InputDecoration(
        labelText: 'Sort by',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: const [
        DropdownMenuItem(
          value: NoteSortBy.recentlyUpdated,
          child: Text('Recently Updated'),
        ),
        DropdownMenuItem(
          value: NoteSortBy.oldestFirst,
          child: Text('Oldest First'),
        ),
        DropdownMenuItem(
          value: NoteSortBy.titleAtoZ,
          child: Text('Title (A-Z)'),
        ),
        DropdownMenuItem(
          value: NoteSortBy.titleZtoA,
          child: Text('Title (Z-A)'),
        ),
        DropdownMenuItem(
          value: NoteSortBy.pinnedFirst,
          child: Text('Pinned First'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedSort = value;
          });
          context.read<NotesCubit>().sortNotes(value);
        }
      },
    );
  }

  Widget _buildFilterPanel(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          // Get unique categories from notes
          final categories = <String>{};
          if (state is NotesLoaded) {
            for (final note in state.notes) {
              if (note.category != null && note.category!.isNotEmpty) {
                categories.add(note.category!);
              }
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Category',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 12),
              if (categories.isEmpty)
                Text(
                  'No categories available',
                  style: TextStyle(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // "All" chip
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedCategory == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = null;
                        });
                        context.read<NotesCubit>().clearFilter();
                      },
                    ),
                    // Category chips
                    ...categories.map((category) {
                      return FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategory = category;
                            } else {
                              _selectedCategory = null;
                            }
                          });
                          if (selected) {
                            context
                                .read<NotesCubit>()
                                .filterByCategory( category);
                          } else {
                            context.read<NotesCubit>().clearFilter();
                          }
                        },
                      );
                    }),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
