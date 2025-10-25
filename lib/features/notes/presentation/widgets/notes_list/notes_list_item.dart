import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../domain/entities/note.dart';

/// Individual note item widget for the notes list/grid.
/// 
/// This widget represents a single note card in the notes list or grid view.
/// It displays note information and provides interactive controls for
/// viewing, editing, deleting, and pinning notes.
class NotesListItem extends StatelessWidget {

  /// Creates a new notes list item widget
  const NotesListItem({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
  });
  /// The note data to display
  final Note note;
  
  /// Callback when the note card is tapped for viewing
  final VoidCallback onTap;
  
  /// Callback when the edit button is pressed
  final VoidCallback onEdit;
  
  /// Callback when the delete button is pressed
  final VoidCallback onDelete;
  
  /// Callback when the pin toggle is pressed
  final VoidCallback onTogglePin;

  @override
  Widget build(BuildContext context) {
    final noteColors = _getNoteColors(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            noteColors.primary,
            noteColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: noteColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(
              minHeight: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                _buildTitle(context),
                const SizedBox(height: 8),
                _buildContent(context),
                const SizedBox(height: 12),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // Vertical line icon at top left
        Container(
          width: 4,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        // Category badge
        if (note.category != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              note.category!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        // Pinned badge
        if (note.isPinned) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.push_pin,
                  size: 12,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  AppStrings.pinnedNotes,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        const Spacer(),
         ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    
    return Text(
      note.title.isEmpty ? AppStrings.untitledNote : note.title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContent(BuildContext context) {
    final content = note.content.trim();
    if (content.isEmpty) return const SizedBox.shrink();
    
    return _buildMarkdownPreview(context, content);
  }

  Widget _buildMarkdownPreview(BuildContext context, String content) {
    final theme = Theme.of(context);
    
    // Parse markdown and convert to rich text spans
    final spans = _parseMarkdownToSpans(content, theme);
    
    return RichText(
      text: TextSpan(
        children: spans,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.9),
          height: 1.4,
          fontSize: 14,
        ),
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<TextSpan> _parseMarkdownToSpans(String content, ThemeData theme) {
    final spans = <TextSpan>[];
    final lines = content.split('\n');
    
    bool inCodeBlock = false;
    String codeBlockContent = '';
    
    for (int i = 0; i < lines.length && i < 4; i++) { // Limit to 4 lines for preview
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      
      // Handle code blocks
      if (line.startsWith('```')) {
        if (inCodeBlock) {
          // End of code block - add the accumulated content
          if (codeBlockContent.isNotEmpty) {
            spans.add(TextSpan(
              text: '[Code: ${codeBlockContent.length > 30 ? '${codeBlockContent.substring(0, 30)}...' : codeBlockContent}]',
              style: TextStyle(
                fontFamily: 'monospace',
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ));
            spans.add(const TextSpan(text: ' '));
          }
          inCodeBlock = false;
          codeBlockContent = '';
        } else {
          // Start of code block
          inCodeBlock = true;
          final language = line.substring(3).trim();
          if (language.isNotEmpty) {
            spans.add(TextSpan(
              text: '[$language] ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ));
          }
        }
        continue;
      }
      
      if (inCodeBlock) {
        if (codeBlockContent.isNotEmpty) codeBlockContent += '\n';
        codeBlockContent += line;
        continue;
      }
      
      if (i > 0) {
        spans.add(const TextSpan(text: ' '));
      }
      
      // Headers
      if (line.startsWith('# ')) {
        spans.add(TextSpan(
          text: line.substring(2),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ));
      } else if (line.startsWith('## ')) {
        spans.add(TextSpan(
          text: line.substring(3),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ));
      } else if (line.startsWith('### ')) {
        spans.add(TextSpan(
          text: line.substring(4),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ));
      }
      // Lists
      else if (line.startsWith('- ')) {
        spans.add(TextSpan(
          text: '• ${line.substring(2)}',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
        ));
      }
      else if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        final match = RegExp(r'^(\d+)\.\s(.*)').firstMatch(line);
        if (match != null) {
          spans.add(TextSpan(
            text: '${match.group(1)}. ${match.group(2)}',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          ));
        }
      }
      // Regular text with inline formatting
      else {
        spans.addAll(_parseInlineMarkdown(line, theme));
      }
    }
    
    // Handle unclosed code block
    if (inCodeBlock && codeBlockContent.isNotEmpty) {
      spans.add(TextSpan(
        text: '[Code: ${codeBlockContent.length > 30 ? '${codeBlockContent.substring(0, 30)}...' : codeBlockContent}]',
        style: TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 12,
        ),
      ));
    }
    
    return spans.isEmpty 
      ? [TextSpan(
          text: content.length > 100 ? '${content.substring(0, 100)}...' : content,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
        )]
      : spans;
  }

  List<TextSpan> _parseInlineMarkdown(String text, ThemeData theme) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'(\*\*.*?\*\*|\*(?!\*)(.*?)\*|~~(.*?)~~|`(.*?)`|\[(.*?)\]\((.*?)\))');
    final matches = regex.allMatches(text);

    int lastEnd = 0;

    for (final match in matches) {
      // Add text before the match
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
        ));
      }

      final matchText = match.group(0)!;
      
      // Bold
      if (matchText.startsWith('**') && matchText.endsWith('**')) {
        spans.add(TextSpan(
          text: matchText.substring(2, matchText.length - 2),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));
      }
      // Italic
      else if (matchText.startsWith('*') && matchText.endsWith('*') && !matchText.startsWith('**')) {
        spans.add(TextSpan(
          text: matchText.substring(1, matchText.length - 1),
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ));
      }
      // Strikethrough
      else if (matchText.startsWith('~~') && matchText.endsWith('~~')) {
        spans.add(TextSpan(
          text: matchText.substring(2, matchText.length - 2),
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ));
      }
      // Inline code
      else if (matchText.startsWith('`') && matchText.endsWith('`')) {
        spans.add(TextSpan(
          text: matchText.substring(1, matchText.length - 1),
          style: TextStyle(
            fontFamily: 'monospace',
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ));
      }
      // Links
      else if (matchText.startsWith('[') && matchText.contains('](')) {
        final linkMatch = RegExp(r'\[(.*?)\]\((.*?)\)').firstMatch(matchText);
        if (linkMatch != null) {
          spans.add(TextSpan(
            text: linkMatch.group(1)!,
            style: const TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ));
        }
      }
      else {
        spans.add(TextSpan(
          text: matchText,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
        ));
      }

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
      ));
    }

    return spans.isEmpty 
      ? [TextSpan(
          text: text,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
        )]
      : spans;
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.access_time,
                size: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(note.updatedAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Define color palette for notes
  ({Color primary, Color secondary}) _getNoteColors(BuildContext context) {
    // Create a deterministic color based on note ID or category
    final colorIndex = (note.id.hashCode) % _colorPalettes.length;
    return _colorPalettes[colorIndex];
  }

  /// Beautiful gradient color palettes for notes
  static const List<({Color primary, Color secondary})> _colorPalettes = [
    // Sunset Orange
    (primary: Color(0xFFFF6B6B), secondary: Color(0xFFFFE66D)),
    // Ocean Blue
    (primary: Color(0xFF4ECDC4), secondary: Color(0xFF44A08D)),
    // Purple Dream
    (primary: Color(0xFFA8EDEA), secondary: Color(0xFFFED6E3)),
    // Forest Green
    (primary: Color(0xFF56AB2F), secondary: Color(0xFFA8E6CF)),
    // Royal Purple
    (primary: Color(0xFF667EEA), secondary: Color(0xFF764BA2)),
    // Pink Bliss
    (primary: Color(0xFFFF8A80), secondary: Color(0xFFFFAB91)),
    // Mint Fresh
    (primary: Color(0xFF81C784), secondary: Color(0xFFAED581)),
    // Cosmic Blue
    (primary: Color(0xFF42A5F5), secondary: Color(0xFF29B6F6)),
    // Lavender
    (primary: Color(0xFFBA68C8), secondary: Color(0xFFE1BEE7)),
    // Golden Hour
    (primary: Color(0xFFFFB74D), secondary: Color(0xFFFFF176)),
  ];

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
