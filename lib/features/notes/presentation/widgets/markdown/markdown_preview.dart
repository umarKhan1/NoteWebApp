import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';

/// A custom markdown preview widget with basic formatting support
class MarkdownPreview extends StatelessWidget {
  ///// Constructor [markdown preview widget]
  const MarkdownPreview({
    super.key,
    required this.content,
    required this.isSmallScreen,
    required this.comeFromDetail,
  });
  //// Markdown content to preview
  final String content;
  //// Responsive flag for small screens
  final bool isSmallScreen;

  /// Flag to indicate if the widget comes from the note detail view
  final bool comeFromDetail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: content.trim().isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.visibility_off_outlined,
                  size: isSmallScreen ? 40 : 48,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Text(
                  AppStrings.previewPlaceholder,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: comeFromDetail
                        ? Colors.white.withValues(alpha: 0.7)
                        : theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                    fontSize: isSmallScreen ? 16 : 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Text(
                  AppStrings.previewEmptyDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: comeFromDetail
                        ? Colors.white.withValues(alpha: 0.5)
                        : theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _parseMarkdown(content, theme),
              ),
            ),
    );
  }

  List<Widget> _parseMarkdown(String text, ThemeData theme) {
    final widgets = <Widget>[];
    final lines = text.split('\n');

    bool inCodeBlock = false;
    final List<String> codeBlockLines = [];
    String? codeLanguage;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Handle code blocks
      if (line.startsWith('```')) {
        if (inCodeBlock) {
          // End of code block
          widgets.add(
            _buildCodeBlock(codeBlockLines.join('\n'), theme, codeLanguage),
          );
          inCodeBlock = false;
          codeBlockLines.clear();
          codeLanguage = null;
        } else {
          // Start of code block
          inCodeBlock = true;
          codeLanguage = line.substring(3).trim();
          if (codeLanguage.isEmpty) codeLanguage = null;
        }
        continue;
      }

      if (inCodeBlock) {
        codeBlockLines.add(line);
        continue;
      }

      if (line.trim().isEmpty) {
        widgets.add(SizedBox(height: isSmallScreen ? 8 : 12));
        continue;
      }

      // Headers
      if (line.startsWith('# ')) {
        widgets.add(_buildHeader(line.substring(2), theme, 1));
      } else if (line.startsWith('## ')) {
        widgets.add(_buildHeader(line.substring(3), theme, 2));
      } else if (line.startsWith('### ')) {
        widgets.add(_buildHeader(line.substring(4), theme, 3));
      }
      // Bullet lists
      else if (line.trim().startsWith('- ')) {
        widgets.add(_buildBulletListItem(line.trim().substring(2), theme));
      }
      // Numbered lists
      else if (RegExp(r'^\s*\d+\.\s+').hasMatch(line)) {
        final match = RegExp(r'^\s*(\d+)\.\s+(.*)').firstMatch(line);
        if (match != null) {
          widgets.add(
            _buildNumberedListItem(match.group(2)!, theme, match.group(1)!),
          );
        }
      }
      // Quotes
      else if (line.trim().startsWith('> ')) {
        widgets.add(_buildQuote(line.trim().substring(2), theme));
      }
      // Regular paragraphs
      else {
        widgets.add(_buildParagraph(line, theme));
      }

      widgets.add(SizedBox(height: isSmallScreen ? 6 : 8));
    }

    // Handle unclosed code block
    if (inCodeBlock && codeBlockLines.isNotEmpty) {
      widgets.add(
        _buildCodeBlock(codeBlockLines.join('\n'), theme, codeLanguage),
      );
    }

    return widgets;
  }

  Widget _buildHeader(String text, ThemeData theme, int level) {
    late TextStyle style;
    switch (level) {
      case 1:
        style =
            theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 20 : 24,
              color: comeFromDetail ? Colors.white : null,
            ) ??
            const TextStyle();
        break;
      case 2:
        style =
            theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 18 : 22,
              color: comeFromDetail ? Colors.white : null,
            ) ??
            const TextStyle();
        break;
      case 3:
        style =
            theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 16 : 20,
              color: comeFromDetail ? Colors.white : null,
            ) ??
            const TextStyle();
        break;
      default:
        style =
            theme.textTheme.bodyLarge?.copyWith(
              color: comeFromDetail ? Colors.white : null,
            ) ??
            const TextStyle();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8),
      child: RichText(
        text: TextSpan(
          children: _buildFormattedTextSpans(text, theme),
          style: style,
        ),
      ),
    );
  }

  Widget _buildBulletListItem(String text, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(
        left: isSmallScreen ? 16 : 20,
        bottom: isSmallScreen ? 2 : 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: isSmallScreen ? 6 : 8,
              right: isSmallScreen ? 8 : 12,
            ),
            width: isSmallScreen ? 4 : 6,
            height: isSmallScreen ? 4 : 6,
            decoration: BoxDecoration(
              color: comeFromDetail
                  ? Colors.white.withValues(alpha: 0.8)
                  : theme.colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: _buildFormattedTextSpans(text, theme),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedListItem(String text, ThemeData theme, String number) {
    return Padding(
      padding: EdgeInsets.only(
        left: isSmallScreen ? 16 : 20,
        bottom: isSmallScreen ? 2 : 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isSmallScreen ? 20 : 24,
            child: Text(
              '$number.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 4 : 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: _buildFormattedTextSpans(text, theme),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuote(String text, ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: isSmallScreen ? 3 : 4,
          ),
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: _buildFormattedTextSpans(text, theme, isQuote: true),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: comeFromDetail
                ? Colors.white.withValues(alpha: 0.8)
                : theme.colorScheme.onSurfaceVariant,
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 2 : 4),
      child: RichText(
        text: TextSpan(
          children: _buildFormattedTextSpans(text, theme),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: isSmallScreen ? 14 : 16,
            color: comeFromDetail ? Colors.white : null,
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildFormattedTextSpans(
    String text,
    ThemeData theme, {
    bool isQuote = false,
  }) {
    final spans = <TextSpan>[];

    // Fixed RegExp pattern - properly escaped asterisks and better structure
    final regex = RegExp(r'(\*\*.*?\*\*|\*.*?\*|~~.*?~~|`.*?`|\[.*?\]\(.*?\))');
    final matches = regex.allMatches(text);

    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: isQuote
                ? theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: comeFromDetail
                        ? Colors.white.withValues(alpha: 0.8)
                        : theme.colorScheme.onSurfaceVariant,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    color: comeFromDetail ? Colors.white : null,
                  ),
          ),
        );
      }

      final matchText = match.group(0)!;
      spans.add(_buildStyledTextSpan(matchText, theme, isQuote));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastEnd),
          style: isQuote
              ? theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: comeFromDetail
                      ? Colors.white.withValues(alpha: 0.8)
                      : theme.colorScheme.onSurfaceVariant,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  color: comeFromDetail ? Colors.white : null,
                ),
        ),
      );
    }

    return spans.isEmpty
        ? [
            TextSpan(
              text: text,
              style: isQuote
                  ? theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: comeFromDetail
                          ? Colors.white.withValues(alpha: 0.8)
                          : theme.colorScheme.onSurfaceVariant,
                    )
                  : theme.textTheme.bodyMedium?.copyWith(
                      color: comeFromDetail ? Colors.white : null,
                    ),
            ),
          ]
        : spans;
  }

  TextSpan _buildStyledTextSpan(
    String matchText,
    ThemeData theme,
    bool isQuote,
  ) {
    final baseStyle = isQuote
        ? theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: comeFromDetail
                ? Colors.white.withValues(alpha: 0.8)
                : theme.colorScheme.onSurfaceVariant,
          )
        : theme.textTheme.bodyMedium?.copyWith(
            color: comeFromDetail ? Colors.white : null,
          );

    if (matchText.startsWith('**') && matchText.endsWith('**')) {
      return TextSpan(
        text: matchText.substring(2, matchText.length - 2),
        style: baseStyle?.copyWith(fontWeight: FontWeight.bold),
      );
    } else if (matchText.startsWith('*') && matchText.endsWith('*')) {
      return TextSpan(
        text: matchText.substring(1, matchText.length - 1),
        style: baseStyle?.copyWith(fontStyle: FontStyle.italic),
      );
    } else if (matchText.startsWith('~~') && matchText.endsWith('~~')) {
      return TextSpan(
        text: matchText.substring(2, matchText.length - 2),
        style: baseStyle?.copyWith(decoration: TextDecoration.lineThrough),
      );
    } else if (matchText.startsWith('`') && matchText.endsWith('`')) {
      // Keep original styling for inline code - don't change color
      return TextSpan(
        text: matchText.substring(1, matchText.length - 1),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * 0.9,
        ),
      );
    } else if (matchText.startsWith('[') && matchText.contains('](')) {
      final linkMatch = RegExp(r'\[(.*?)\]\((.*?)\)').firstMatch(matchText);
      if (linkMatch != null) {
        return TextSpan(
          text: linkMatch.group(1)!,
          style: baseStyle?.copyWith(
            color: theme.colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
        );
      }
    }

    return TextSpan(text: matchText, style: baseStyle);
  }

  Widget _buildCodeBlock(String code, ThemeData theme, String? language) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (language != null && language.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 6 : 8,
                vertical: isSmallScreen ? 2 : 4,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                language,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: isSmallScreen ? 10 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
          ],
          SelectableText(
            code,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: isSmallScreen ? 12 : 14,
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
