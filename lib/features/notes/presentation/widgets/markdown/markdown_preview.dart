import 'package:flutter/material.dart';

/// A custom markdown preview widget with basic formatting support
class MarkdownPreview extends StatelessWidget {
///// Constructor [markdown preview widget]
  const MarkdownPreview({
    super.key,
    required this.content,
    required this.isSmallScreen,
  });
  //// Markdown content to preview
  final String content;
  //// Responsive flag for small screens
  final bool isSmallScreen;

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
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Text(
                  'Preview will appear here',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: isSmallScreen ? 16 : 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Text(
                  'Start writing to see a live preview\nof your markdown formatting',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
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
      else if (RegExp(r'^\d+\. ').hasMatch(line.trim())) {
        final match = RegExp(r'^(\d+)\. (.*)').firstMatch(line.trim());
        if (match != null) {
          widgets.add(_buildNumberedListItem(match.group(2)!, theme, match.group(1)!));
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
    
    return widgets;
  }

  Widget _buildHeader(String text, ThemeData theme, int level) {
    late TextStyle style;
    switch (level) {
      case 1:
        style = theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: isSmallScreen ? 20 : 24,
        ) ?? const TextStyle();
        break;
      case 2:
        style = theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: isSmallScreen ? 18 : 22,
        ) ?? const TextStyle();
        break;
      case 3:
        style = theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: isSmallScreen ? 16 : 20,
        ) ?? const TextStyle();
        break;
      default:
        style = theme.textTheme.bodyLarge ?? const TextStyle();
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
              color: theme.colorScheme.onSurfaceVariant,
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
            color: theme.colorScheme.onSurfaceVariant,
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
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildFormattedTextSpans(String text, ThemeData theme, {bool isQuote = false}) {
    final spans = <TextSpan>[];
    
    // Fixed RegExp pattern - properly escaped asterisks and better structure
    final regex = RegExp(r'(\*\*.*?\*\*|\*.*?\*|~~.*?~~|`.*?`|\[.*?\]\(.*?\))');
    final matches = regex.allMatches(text);

    int lastEnd = 0;

    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: isQuote
              ? theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : theme.textTheme.bodyMedium,
        ));
      }

      final matchText = match.group(0)!;
      spans.add(_buildStyledTextSpan(matchText, theme, isQuote));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: isQuote
            ? theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              )
            : theme.textTheme.bodyMedium,
      ));
    }

    return spans.isEmpty
        ? [
            TextSpan(
              text: text,
              style: isQuote
                  ? theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  : theme.textTheme.bodyMedium,
            )
          ]
        : spans;
  }

  TextSpan _buildStyledTextSpan(String matchText, ThemeData theme, bool isQuote) {
    final baseStyle = isQuote
        ? theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.onSurfaceVariant,
          )
        : theme.textTheme.bodyMedium;

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
      return TextSpan(
        text: matchText.substring(1, matchText.length - 1),
        style: baseStyle?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          fontSize: (baseStyle.fontSize ?? 14) * 0.9,
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
}
