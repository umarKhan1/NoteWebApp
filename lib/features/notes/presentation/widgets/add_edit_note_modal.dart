import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note.dart';
import '../cubit/notes_cubit.dart';

/// Modal for adding or editing a note
class AddEditNoteModal extends StatefulWidget {
  final Note? noteToEdit;

  const AddEditNoteModal({
    super.key,
    this.noteToEdit,
  });

  static Future<void> show(BuildContext context, {Note? noteToEdit}) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => AddEditNoteModal(noteToEdit: noteToEdit),
    );
  }

  @override
  State<AddEditNoteModal> createState() => _AddEditNoteModalState();
}

class _AddEditNoteModalState extends State<AddEditNoteModal> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _categoryController;
  bool _isPinned = false;
  bool _isLoading = false;
  String? _selectedCategory;

  static const List<String> _predefinedCategories = [
    'Personal',
    'Work',
    'Study',
    'Ideas',
    'Shopping',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _categoryController = TextEditingController();

    // If editing, populate fields with existing note data
    if (widget.noteToEdit != null) {
      _titleController.text = widget.noteToEdit!.title;
      _contentController.text = widget.noteToEdit!.content;
      _categoryController.text = widget.noteToEdit!.category ?? '';
      _selectedCategory = widget.noteToEdit!.category;
      _isPinned = widget.noteToEdit!.isPinned;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.noteToEdit != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Text(
                            _isEditing ? 'Edit Note' : 'Create New Note',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Title field
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Note Title',
                          hintText: 'Enter note title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.title),
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 16),

                      // Content field
                      TextField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          labelText: 'Content',
                          hintText: 'Write your note content here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 6,
                        minLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // Category section title with Pin checkbox at the end
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Pin checkbox at the horizontal end
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _isPinned
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              color: _isPinned
                                  ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                                  : Colors.transparent,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _isPinned,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (value) {
                                    setState(() {
                                      _isPinned = value ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Pin Post',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (_isPinned) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.push_pin,
                                    size: 14,
                                    color: theme.colorScheme.primary,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Category buttons
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _predefinedCategories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedCategory = category;
                                  _categoryController.text = category;
                                } else {
                                  _selectedCategory = null;
                                  _categoryController.text = '';
                                }
                              });
                            },
                            backgroundColor: theme.colorScheme.surface,
                            selectedColor: theme.colorScheme.primaryContainer,
                            side: BorderSide(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Category input field (optional)
                      TextField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: 'Custom Category (optional)',
                          hintText: 'Or enter a custom category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.category),
                        ),
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value.isEmpty ? null : value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Action buttons at bottom with padding
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: 24 + keyboardHeight,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveNote,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEditing ? 'Update Note' : 'Create Note'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final category = _categoryController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      _showErrorSnackBar('Please enter a title or content');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final cubit = context.read<NotesCubit>();

      if (_isEditing) {
        // Update existing note
        await cubit.updateNote(
          id: widget.noteToEdit!.id,
          title: title.isEmpty ? widget.noteToEdit!.title : title,
          content: content.isEmpty ? widget.noteToEdit!.content : content,
          category: category.isEmpty ? null : category,
          isPinned: _isPinned,
        );
      } else {
        // Create new note
        await cubit.createNote(
          title: title,
          content: content,
          category: category.isEmpty ? null : category,
          isPinned: _isPinned,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        _showSuccessSnackBar(
          _isEditing ? 'Note updated successfully!' : 'Note created successfully!',
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
