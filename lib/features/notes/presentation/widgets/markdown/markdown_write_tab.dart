import 'package:flutter/material.dart';

/// The write tab widget for markdown content editing
class MarkdownWriteTab extends StatelessWidget {
  const MarkdownWriteTab({
    super.key,
    required this.contentController,
    required this.isSmallScreen,
    required this.onInsertMarkdown,
  });

  final TextEditingController contentController;
  final bool isSmallScreen;
  final Function(String before, String after) onInsertMarkdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
     
      child: SizedBox.expand( // fill full height of TabBarView
        child: TextFormField(
          controller: contentController,
          expands: true, // important
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            hintText: isSmallScreen
                ? '📝 Start writing your note...\n\n✨ Markdown tips:\n• **bold** or *italic*\n• # Header\n• - List item\n• `code`'
                : '📝 Start writing your note...\n\n✨ Markdown tips:\n• **bold** or *italic*\n• # Header\n• - List item\n• `code` or ~~strikethrough~~\n• [link](url) or > quote',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              fontSize: isSmallScreen ? 13 : 14,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(12),
          ),
          style: TextStyle(
            fontSize: isSmallScreen ? 15 : 16,
            height: 1.5,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
