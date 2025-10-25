import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../shared/extensions/widget_extensions.dart';
import '../../../data/services/web_image_picker.dart';
import '../../../domain/entities/note.dart';
import '../../cubit/add_note_form_cubit.dart';
import '../../cubit/notes_cubit.dart';
import '../markdown/markdown_editor.dart';
import '../note_image_section.dart';

/// Beautiful sliding bottom sheet for adding notes
class AddNoteBottomSheet extends StatelessWidget {
  
  /// Constructor for add note bottom sheet [AddNoteBottomSheet]
  const AddNoteBottomSheet({
    super.key,
    this.existingNote,
    this.isEdit = false,
  });
  /// The existing note to edit (optional)
  final Note? existingNote;
  
  /// Whether this is in edit mode
  final bool isEdit;

  /// Show the add note bottom sheet
  static void show(BuildContext context, {Note? existingNote}) {
    final size = MediaQuery.of(context).size;
    final isEdit = existingNote != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: size.width >= 1024
            ? 1100
            : size.width >= 600
                ? 900
                : size.width,
        maxHeight: size.height,
      ),
      builder: (context) => BlocProvider(
        create: (context) => AddNoteFormCubit(),
        child: AddNoteBottomSheet(
          existingNote: existingNote,
          isEdit: isEdit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AddNoteBottomSheetContent(
      existingNote: existingNote,
      isEdit: isEdit,
    );
  }
}

/// Internal content widget for the bottom sheet
class _AddNoteBottomSheetContent extends StatefulWidget {
  
  const _AddNoteBottomSheetContent({
    this.existingNote,
    this.isEdit = false,
  });
  /// The existing note to edit (optional)
  final Note? existingNote;
  
  /// Whether this is in edit mode
  final bool isEdit;

  @override
  State<_AddNoteBottomSheetContent> createState() => _AddNoteBottomSheetContentState();
}

class _AddNoteBottomSheetContentState extends State<_AddNoteBottomSheetContent>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  late TabController _tabController;
  
  final List<String> _categories = [
    AppStrings.personalCategory,
    AppStrings.workCategory,
    AppStrings.studyCategory,
    AppStrings.ideasCategory,
    AppStrings.shoppingCategory,
    AppStrings.otherCategory,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _contentController.addListener(_onContentChanged);
    
    // Load existing note data if editing
    if (widget.isEdit && widget.existingNote != null) {
      final note = widget.existingNote!;
      _titleController.text = note.title;
      _contentController.text = note.content;
      
      // Set cubit state
      context.read<AddNoteFormCubit>().setEditMode(
        title: note.title,
        content: note.content,
        category: note.category,
        isPinned: note.isPinned,
        imageBase64: note.imageBase64,
        imageName: note.imageName,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    context.read<AddNoteFormCubit>().updateContent(_contentController.text);
  }

  Future<void> _handlePickImage() async {
    try {
      final result = await WebImagePickerService.pickImageAsBase64();
      
      if (result != null && mounted) {
        final (base64, fileName) = result;
        context.read<AddNoteFormCubit>().setImage(base64, fileName);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image added successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleRemoveImage() {
    context.read<AddNoteFormCubit>().removeImage();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image removed'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Trigger save through cubit - let cubit handle the business logic
      if (widget.isEdit && widget.existingNote != null) {
        // Update existing note
        context.read<AddNoteFormCubit>().updateNote(
          noteId: widget.existingNote!.id,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          notesCubit: context.read<NotesCubit>(),
        );
      } else {
        // Create new note
        context.read<AddNoteFormCubit>().saveNote(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          notesCubit: context.read<NotesCubit>(),
        );
      }
    }
  }

  void _handleCancel() {
    context.read<AddNoteFormCubit>().reset();
    Navigator.of(context).pop();
  }

  void _insertMarkdown(String before, String after) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final start = selection.start.clamp(0, text.length);
    final end = selection.end.clamp(0, text.length);
    
    final selectedText = text.substring(start, end);
    final newText = text.replaceRange(
      start,
      end,
      before + selectedText + after,
    );
    
    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(
      offset: start + before.length + selectedText.length + after.length,
    );
    
    context.read<AddNoteFormCubit>().updateContent(newText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isSmallMobile = screenWidth < 400;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Dynamic modal sizing - Better proportions with spacing
    final maxWidth = isDesktop
        ? 850  // Reduced from 1100 for better desktop proportions
        : isTablet
            ? screenWidth * 0.85  // Reduced from 900 for better tablet spacing
            : screenWidth * 0.95;  // Add some margin on mobile
    final maxHeight = isDesktop
        ? screenHeight * 0.85  // Reduced from 0.92 for better spacing
        : isTablet
            ? screenHeight * 0.88  // Reduced from 0.94
            : screenHeight * 0.93;  // Reduced from 0.98 for mobile spacing

    return Align(
      alignment: isDesktop ? Alignment.center : Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(
          top: isDesktop ? 40 : isTablet ? 20 : 20,
          bottom: keyboardHeight + (isDesktop ? 40 : isTablet ? 30 : 20),
          left: isDesktop ? 40 : isTablet ? 20 : 10,
          right: isDesktop ? 40 : isTablet ? 20 : 10,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth.toDouble(),
            maxHeight: maxHeight,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(
                isSmallMobile ? 12 : isMobile ? 16 : isTablet ? 20 : 24
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:  isDesktop ? 0.18 : isTablet ? 0.15 : 0.1),
                  blurRadius: isDesktop ? 40 : isTablet ? 30 : 20,
                  offset: Offset(0, isDesktop ? -8 : isTablet ? -6 : -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(theme, isSmallMobile, isMobile, isTablet),
                
                const Divider(height: 0.1),
                
                // Form content
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(isSmallMobile ? 16 : isMobile ? 20 : isTablet ? 10 : 10),
                      child: Column(
                        children: [
                          // Title field
                          _buildTitleField(theme, isSmallMobile, isMobile, isTablet),
                          
                          1.vSpace,
                          
                          // Category selection
                          _buildCategorySection(theme, isSmallMobile, isMobile, isTablet),
                          
                          2.vSpace,
                          
                          // Scrollable content area with image and markdown
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image section
                                  BlocBuilder<AddNoteFormCubit, AddNoteFormState>(
                                    builder: (context, state) {
                                      String? imageBase64;
                                      String? imageName;
                                      
                                      if (state is AddNoteFormContentUpdated) {
                                        imageBase64 = state.imageBase64;
                                        imageName = state.imageName;
                                      }
                                      
                                      return NoteImageSection(
                                        imageBase64: imageBase64,
                                        imageName: imageName,
                                        onPickImage: _handlePickImage,
                                        onRemoveImage: _handleRemoveImage,
                                      );
                                    },
                                  ),
                                  
                                  2.vSpace,
                                  
                                  // Markdown editor
                                  SizedBox(
                                    height: 250,
                                    child: MarkdownEditor(
                                      tabController: _tabController,
                                      contentController: _contentController,
                                      isSmallMobile: isSmallMobile,
                                      isMobile: isMobile,
                                      isTablet: isTablet,
                                      onInsertMarkdown: _insertMarkdown,
                                      onContentChanged: _onContentChanged,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),                  // Action buttons with BlocListener for save operations
                  BlocListener<AddNoteFormCubit, AddNoteFormState>(
                    listener: (context, state) {
                      if (state is AddNoteFormSaveSuccess) {
                        if (mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(AppStrings.noteCreatedSuccess),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } else if (state is AddNoteFormSaveError) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${AppStrings.noteCreationFailed}: ${state.error}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: _buildActionButtons(theme, isSmallMobile, isMobile, isTablet),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isSmallMobile, bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallMobile ? 12 : isMobile ? 16 : isTablet ? 24 : 32, 
        vertical: isSmallMobile ? 8 : isMobile ? 12 : 16
      ),
      child: Row(
        children: [
          Text(
            AppStrings.createNewNote,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallMobile ? 13 : isMobile ? 12 : isTablet ? 15 : 20,
            ),
          ),
         
        ],
      ),
    );
  }

  Widget _buildTitleField(ThemeData theme, bool isSmallMobile, bool isMobile, bool isTablet) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: AppStrings.noteTitleLabel,
        hintText: AppStrings.createNoteTitleHint,
        prefixIcon: Icon(Icons.title, size: isSmallMobile ? 18 : isMobile ? 20 : isTablet ? 15 : 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isSmallMobile ? 6 : isMobile ? 8 : isTablet ? 12 : 14),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallMobile ? 10 : isMobile ? 12 : isTablet ? 10 : 10,
          vertical: isSmallMobile ? 10 : isMobile ? 10 : isTablet ? 10 : 10,
        ),
      ),
      style: TextStyle(fontSize: isSmallMobile ? 13 : isMobile ? 14 : isTablet ? 16 : 18),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.titleRequired;
        }
        return null;
      },
    );
  }

  Widget _buildCategorySection(ThemeData theme, bool isSmallMobile, bool isMobile, bool isTablet) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header with Pin checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.category,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: isSmallMobile ? 13 : isMobile ? 14 : isTablet ? 16 : 18,
                ),
                textAlign: TextAlign.start,
              ),
              // Pin note checkbox at the end
              BlocBuilder<AddNoteFormCubit, AddNoteFormState>(
                builder: (context, state) {
                  // Get isPinned from the state
                  bool isPinned = false;
                  if (state is AddNoteFormContentUpdated) {
                    isPinned = state.isPinned;
                  } else if (state is AddNoteFormSaveSuccess) {
                    isPinned = state.isPinned;
                  } else if (state is AddNoteFormSaveError) {
                    isPinned = state.isPinned;
                  }
                  
                  return GestureDetector(
                    onTap: () {
                      context.read<AddNoteFormCubit>().togglePin();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isPinned ? theme.colorScheme.primary : theme.colorScheme.outline,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        color: isPinned
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isPinned,
                            visualDensity: VisualDensity.compact,
                            onChanged: (value) {
                              context.read<AddNoteFormCubit>().togglePin();
                            },
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Pin note',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallMobile ? 11 : isMobile ? 12 : isTablet ? 13 : 14,
                            ),
                          ),
                          if (isPinned) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.push_pin,
                              size: isSmallMobile ? 12 : isMobile ? 13 : 14,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          (isSmallMobile ? 6 : isMobile ? 8 : 12).verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: BlocBuilder<AddNoteFormCubit, AddNoteFormState>(
              builder: (context, state) {
                String? selectedCategory;
                if (state is AddNoteFormCategorySelected) {
                  selectedCategory = state.selectedCategory;
                } else if (state is AddNoteFormContentUpdated) {
                  selectedCategory = state.selectedCategory;
                }
                
                return Wrap(
                  alignment: WrapAlignment.start,
                  spacing: isSmallMobile ? 4 : isMobile ? 6 : isTablet ? 8 : 10,
                  runSpacing: isSmallMobile ? 4 : isMobile ? 6 : isTablet ? 8 : 10,
                  children: _categories.map((category) {
                    final isSelected = selectedCategory == category;
                    return FilterChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          fontSize: isSmallMobile ? 11 : isMobile ? 12 : isTablet ? 14 : 15,
                        ),
                      ),
                      selected: isSelected,
                      showCheckmark: true,
                      onSelected: (selected) {
                        final newCategory = selected ? category : null;
                        context.read<AddNoteFormCubit>().selectCategory(newCategory);
                      },
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      selectedColor: theme.colorScheme.primaryContainer,
                      checkmarkColor: theme.colorScheme.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallMobile ? 4 : isMobile ? 6 : isTablet ? 8 : 10,
                        vertical: isSmallMobile ? 1 : isMobile ? 2 : isTablet ? 4 : 5,
                      ),
                      visualDensity: isSmallMobile || isMobile 
                          ? VisualDensity.compact 
                          : VisualDensity.standard,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActionButtons(ThemeData theme, bool isSmallMobile, bool isMobile, bool isTablet) {
    return BlocBuilder<AddNoteFormCubit, AddNoteFormState>(
      builder: (context, state) {
        final isLoading = state is AddNoteFormLoading;
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isSmallMobile ? 16 : isMobile ? 20 : isTablet ? 24 : 28),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: isMobile
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Create button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: isSmallMobile ? 12 : 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(isSmallMobile ? 6 : 8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      widget.isEdit ? Icons.check_circle : Icons.add_circle,
                                      size: isSmallMobile ? 16 : 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.isEdit ? 'Update Note' : AppStrings.createNote,
                                      style: TextStyle(fontSize: isSmallMobile ? 13 : 14),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: isSmallMobile ? 6 : 8),
                      // Cancel button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: isLoading ? null : _handleCancel,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: isSmallMobile ? 12 : 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(isSmallMobile ? 6 : 8),
                            ),
                          ),
                          child: Text(
                            AppStrings.cancel,
                            style: TextStyle(fontSize: isSmallMobile ? 13 : 14),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading ? null : _handleCancel,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(AppStrings.cancel),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      widget.isEdit ? Icons.check_circle : Icons.add_circle,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(widget.isEdit ? 'Update Note' : AppStrings.createNote),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
