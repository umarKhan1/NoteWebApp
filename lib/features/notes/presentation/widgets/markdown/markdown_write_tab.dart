import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';

/// The write tab widget for markdown content editing
class MarkdownWriteTab extends StatefulWidget {
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
  State<MarkdownWriteTab> createState() => _MarkdownWriteTabState();
}

class _MarkdownWriteTabState extends State<MarkdownWriteTab> {
  bool _showHints = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Hint section - different layouts for mobile and desktop
        if (widget.isSmallScreen)
          _buildMobileHintSection(theme)
        else
          _buildDesktopHintSection(theme),

        // Main text editor
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(widget.isSmallScreen ? 16 : 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.isSmallScreen ? 8 : 12),
                bottomRight: Radius.circular(widget.isSmallScreen ? 8 : 12),
              ),
            ),
            child: TextFormField(
              cursorHeight: 18,
              controller: widget.contentController,
              maxLines: null,
              expands: false,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: widget.isSmallScreen
                    ? AppStrings.markdownHintsSmall
                    : AppStrings.markdownHintsLarge,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.6,
                  ),
                  fontSize: widget.isSmallScreen ? 12 : 12,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontSize: widget.isSmallScreen ? 15 : 16,
                height: widget.isSmallScreen ? 1.4 : 3,
                color: theme.colorScheme.onSurface,
              ),
              scrollPadding: EdgeInsets.all(widget.isSmallScreen ? 8 : 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHintSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Use headers, lists, and plain text for best PDF results',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHintSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        leading: Icon(
          Icons.help_outline,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          AppStrings.pdfExportHint,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        initiallyExpanded: _showHints,
        onExpansionChanged: (expanded) {
          setState(() {
            _showHints = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PDF Friendly Features
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 12,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Works Well',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppStrings.pdfFriendlyFeatures,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                // PDF Limitations
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withValues(
                        alpha: 0.2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 12,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Gets Converted',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppStrings.pdfLimitations,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
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
