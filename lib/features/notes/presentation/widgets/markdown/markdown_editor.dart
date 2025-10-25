import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../cubit/markdown_editor_cubit.dart';
import 'markdown_preview.dart';
import 'markdown_write_tab.dart';

/// A complete markdown editor with Write and Preview tabs
class MarkdownEditor extends StatelessWidget {
  /// Constructor
  const MarkdownEditor({
    super.key,
    required this.tabController,
    required this.contentController,
    required this.isSmallMobile,
    required this.isMobile,
    required this.isTablet,
    required this.onInsertMarkdown,
    required this.onContentChanged,
  });

  /// Controller for managing tab selection
  final TabController tabController;

  /// Controller for the markdown content
  final TextEditingController contentController;

  /// Responsive flags
  final bool isSmallMobile;

  /// Responsive flags
  final bool isMobile;

  /// Responsive flags
  final bool isTablet;

  /// Callback for inserting markdown syntax
  final Function(String before, String after) onInsertMarkdown;

  /// Callback for content changes
  final VoidCallback onContentChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = isMobile;

    return BlocProvider(
      create: (context) => MarkdownEditorCubit(),
      child: BlocListener<MarkdownEditorCubit, MarkdownEditorState>(
        listener: (context, state) {
          onContentChanged();
        },
        child: _MarkdownEditorContent(
          tabController: tabController,
          contentController: contentController,
          isSmallMobile: isSmallMobile,
          isMobile: isMobile,
          isTablet: isTablet,
          onInsertMarkdown: onInsertMarkdown,
          theme: theme,
          isSmallScreen: isSmallScreen,
        ),
      ),
    );
  }
}

/// Internal widget for markdown editor content
class _MarkdownEditorContent extends StatefulWidget {
  const _MarkdownEditorContent({
    required this.tabController,
    required this.contentController,
    required this.isSmallMobile,
    required this.isMobile,
    required this.isTablet,
    required this.onInsertMarkdown,
    required this.theme,
    required this.isSmallScreen,
  });

  final TabController tabController;
  final TextEditingController contentController;
  final bool isSmallMobile;
  final bool isMobile;
  final bool isTablet;
  final Function(String before, String after) onInsertMarkdown;
  final ThemeData theme;
  final bool isSmallScreen;

  @override
  State<_MarkdownEditorContent> createState() => _MarkdownEditorContentState();
}

class _MarkdownEditorContentState extends State<_MarkdownEditorContent> {
  @override
  void initState() {
    super.initState();
    widget.contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.contentController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    context.read<MarkdownEditorCubit>().updateContent(
      widget.contentController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Tab bar
          Container(
            height: widget.isSmallMobile
                ? 36
                : widget.isMobile
                ? 40
                : 48,
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  widget.isSmallMobile
                      ? 6
                      : widget.isMobile
                      ? 8
                      : 12,
                ),
                topRight: Radius.circular(
                  widget.isSmallMobile
                      ? 6
                      : widget.isMobile
                      ? 8
                      : 12,
                ),
              ),
            ),
            child: TabBar(
              controller: widget.tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                fontSize: widget.isSmallMobile
                    ? 11
                    : widget.isMobile
                    ? 12
                    : 14,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: widget.isSmallMobile
                    ? 11
                    : widget.isMobile
                    ? 12
                    : 14,
              ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.edit,
                    size: widget.isSmallMobile
                        ? 14
                        : widget.isMobile
                        ? 16
                        : 18,
                  ),
                  text: AppStrings.writeTab,
                  height: widget.isSmallMobile
                      ? 32
                      : widget.isMobile
                      ? 36
                      : 44,
                ),
                Tab(
                  icon: Icon(
                    Icons.visibility,
                    size: widget.isSmallMobile
                        ? 14
                        : widget.isMobile
                        ? 16
                        : 18,
                  ),
                  text: AppStrings.previewTab,
                  height: widget.isSmallMobile
                      ? 32
                      : widget.isMobile
                      ? 36
                      : 44,
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: widget.tabController,
              children: [
                MarkdownWriteTab(
                  contentController: widget.contentController,
                  isSmallScreen: widget.isSmallScreen,
                  onInsertMarkdown: widget.onInsertMarkdown,
                ),
                BlocBuilder<MarkdownEditorCubit, MarkdownEditorState>(
                  builder: (context, state) {
                    // Always use the current content from the controller for real-time updates
                    return MarkdownPreview(
                      content: widget.contentController.text,
                      isSmallScreen: widget.isSmallScreen,
                      comeFromDetail: false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
