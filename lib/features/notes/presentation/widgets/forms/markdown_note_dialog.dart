import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../cubit/notes_cubit.dart';

/// Markdown-enabled note creation dialog
class MarkdownNoteDialog extends StatefulWidget {
  /// Creates a [MarkdownNoteDialog].
  const MarkdownNoteDialog({super.key});

  @override
  State<MarkdownNoteDialog> createState() => _MarkdownNoteDialogState();

  /// Show the dialog
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MarkdownNoteDialog(),
    );
  }
}

class _MarkdownNoteDialogState extends State<MarkdownNoteDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  late TabController _tabController;
  String? _selectedCategory;
  bool _isLoading = false;
  
  final List<String> _categories = [
    'Personal',
    'Work',
    'Study',
    'Ideas',
    'Shopping',
    'Health',
    'Creative',
    'Travel',
    'Finance',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      try {
        await context.read<NotesCubit>().createNote(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          category: _selectedCategory,
        );
        
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create note: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: isMobile ? screenSize.width * 0.95 : 800,
        height: isMobile ? screenSize.height * 0.85 : 650,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.note_add,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Create New Note',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _handleCancel,
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Title field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  hintText: 'Enter note title...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 16),
              
              // Category dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  hintText: 'Select a category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
              ),
              
              const SizedBox(height: 16),
              
              // Content tabs (Write/Preview)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.edit), text: 'Write'),
                    Tab(icon: Icon(Icons.preview), text: 'Preview'),
                  ],
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  indicator: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Content area
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Write tab
                    _buildWriteTab(theme),
                    // Preview tab
                    _buildPreviewTab(theme),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : _handleCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add Note'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWriteTab(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Markdown toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _buildToolbarButton(
                  icon: Icons.format_bold,
                  tooltip: 'Bold',
                  onPressed: () => _insertMarkdown('**', '**'),
                ),
                _buildToolbarButton(
                  icon: Icons.format_italic,
                  tooltip: 'Italic',
                  onPressed: () => _insertMarkdown('*', '*'),
                ),
                _buildToolbarButton(
                  icon: Icons.format_list_bulleted,
                  tooltip: 'Bullet List',
                  onPressed: () => _insertMarkdown('- ', ''),
                ),
                _buildToolbarButton(
                  icon: Icons.format_list_numbered,
                  tooltip: 'Numbered List',
                  onPressed: () => _insertMarkdown('1. ', ''),
                ),
                _buildToolbarButton(
                  icon: Icons.link,
                  tooltip: 'Link',
                  onPressed: () => _insertMarkdown('[', '](url)'),
                ),
                _buildToolbarButton(
                  icon: Icons.code,
                  tooltip: 'Code',
                  onPressed: () => _insertMarkdown('`', '`'),
                ),
                _buildToolbarButton(
                  icon: Icons.format_quote,
                  tooltip: 'Quote',
                  onPressed: () => _insertMarkdown('> ', ''),
                ),
              ],
            ),
          ),
          // Text editor
          Expanded(
            child: TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'Write your note content here...\n\nSupports Markdown:\n• **bold** or *italic*\n• # Headers\n• - Lists\n• [Links](url)\n• `code`\n• > Quotes',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Content is required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTab(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _contentController.text.trim().isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.preview,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Preview will appear here',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start typing in the Write tab to see the preview',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: MarkdownWidget(
                data: _contentController.text,
                config: MarkdownConfig(
                  configs: [
                    const PConfig(
                      textStyle: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const H1Config(
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const H2Config(
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const H3Config(
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(32, 32),
        ),
      ),
    );
  }

  void _insertMarkdown(String before, String after) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final start = selection.start;
    final end = selection.end;
    
    final newText = text.replaceRange(
      start,
      end,
      before + text.substring(start, end) + after,
    );
    
    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(
      offset: start + before.length + (end - start) + after.length,
    );
    
    setState(() {}); // Refresh preview
  }
}
