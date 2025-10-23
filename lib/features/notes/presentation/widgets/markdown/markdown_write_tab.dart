import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';

/// The write tab widget for markdown content editing
class MarkdownWriteTab extends StatelessWidget {
  /// Constructor for [MarkdownWriteTab]
  const MarkdownWriteTab({
    super.key,
    required this.contentController,
    required this.isSmallScreen,
    required this.onInsertMarkdown,
  });
  
  /// The controller for the markdown content
  final TextEditingController contentController;
  /// Responsive flag for small screens
  final bool isSmallScreen;
  /// Callback for inserting markdown syntax
  final Function(String before, String after) onInsertMarkdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isSmallScreen ? 8 : 12),
          bottomRight: Radius.circular(isSmallScreen ? 8 : 12),
        ),
      ),
      child: TextFormField(
        controller: contentController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: isSmallScreen 
              ? AppStrings.markdownHintsSmall
              : AppStrings.markdownHintsLarge,
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            fontSize: isSmallScreen ? 14 : 15,
            height: 1.5,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(
          fontSize: isSmallScreen ? 15 : 16,
          height: isSmallScreen ? 1.4 : 1.5,
          color: theme.colorScheme.onSurface,
        ),
        scrollPadding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      ),
    );
  }
}
