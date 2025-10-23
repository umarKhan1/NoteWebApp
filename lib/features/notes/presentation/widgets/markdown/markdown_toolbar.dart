import 'package:flutter/material.dart';

/// A toolbar widget for markdown formatting buttons
class MarkdownToolbar extends StatelessWidget {
  /// Constructor for markdown toolbar [MarkdownToolbar]
  const MarkdownToolbar({
    super.key,
    required this.isSmallScreen,
    required this.onInsertMarkdown,
  });
  /// Responsive flag for small screens
  final bool isSmallScreen;
  /// Callback for inserting markdown syntax
  final Function(String before, String after) onInsertMarkdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: isSmallScreen ? 44 : 52,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12, 
        vertical: isSmallScreen ? 4 : 8
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isSmallScreen ? 8 : 12),
          topRight: Radius.circular(isSmallScreen ? 8 : 12),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildToolbarButton(
              context,
              icon: Icons.format_bold,
              tooltip: 'Bold (**text**)',
              onPressed: () => onInsertMarkdown('**', '**'),
            ),
            _buildToolbarButton(
              context,
              icon: Icons.format_italic,
              tooltip: 'Italic (*text*)',
              onPressed: () => onInsertMarkdown('*', '*'),
            ),
            _buildToolbarButton(
              context,
              icon: Icons.strikethrough_s,
              tooltip: 'Strikethrough (~~text~~)',
              onPressed: () => onInsertMarkdown('~~', '~~'),
            ),
            _buildDivider(theme),
            _buildToolbarButton(
              context,
              icon: Icons.title,
              tooltip: 'Header (# Title)',
              onPressed: () => onInsertMarkdown('\n# ', ''),
            ),
            _buildToolbarButton(
              context,
              icon: Icons.format_list_bulleted,
              tooltip: 'Bullet List',
              onPressed: () => onInsertMarkdown('\n- ', ''),
            ),
            _buildToolbarButton(
              context,
              icon: Icons.format_list_numbered,
              tooltip: 'Numbered List',
              onPressed: () => onInsertMarkdown('\n1. ', ''),
            ),
            _buildDivider(theme),
            _buildToolbarButton(
              context,
              icon: Icons.link,
              tooltip: 'Link ([text](url))',
              onPressed: () => onInsertMarkdown('[', '](url)'),
            ),
            _buildToolbarButton(
              context,
              icon: Icons.code,
              tooltip: 'Inline Code (`code`)',
              onPressed: () => onInsertMarkdown('`', '`'),
            ),
            _buildToolbarButton(
              context,
              icon: Icons.format_quote,
              tooltip: 'Quote (> text)',
              onPressed: () => onInsertMarkdown('\n> ', ''),
            ),
            _buildDivider(theme),
            _buildToolbarButton(
              context,
              icon: Icons.horizontal_rule,
              tooltip: 'Horizontal Rule',
              onPressed: () => onInsertMarkdown('\n---\n', ''),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: isSmallScreen ? 16 : 18),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
          minimumSize: Size(isSmallScreen ? 28 : 32, isSmallScreen ? 28 : 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: isSmallScreen ? VisualDensity.compact : VisualDensity.standard,
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: isSmallScreen ? 20 : 24,
      width: 1,
      color: theme.colorScheme.outline.withValues(alpha:  0.3),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
