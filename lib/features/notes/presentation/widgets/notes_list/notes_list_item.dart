import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../domain/entities/note.dart';

/// Individual note item widget for the notes list/grid
class NotesListItem extends StatelessWidget {
  /// The note to display
  final Note note;
  
  /// Callback when the note is tapped
  final VoidCallback onTap;
  
  /// Callback when the edit button is pressed
  final VoidCallback onEdit;
  
  /// Callback when the delete button is pressed
  final VoidCallback onDelete;
  
  /// Callback when the pin toggle is pressed
  final VoidCallback onTogglePin;

  const NotesListItem({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.w),
            color: _getNoteColor(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 1.h),
              _buildTitle(context),
              SizedBox(height: 1.h),
              _buildContent(context),
              const Spacer(),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (note.category != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Text(
              note.category!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
        ] else
          const Spacer(),
        IconButton(
          icon: Icon(
            note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            size: 5.w,
            color: note.isPinned
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          onPressed: onTogglePin,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            size: 5.w,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 4.w),
                  SizedBox(width: 2.w),
                  const Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 4.w, color: Theme.of(context).colorScheme.error),
                  SizedBox(width: 2.w),
                  Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      note.title.isEmpty ? 'Untitled Note' : note.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContent(BuildContext context) {
    final content = note.content.replaceAll('\n', ' ').trim();
    if (content.isEmpty) return const SizedBox.shrink();
    
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        height: 1.3,
      ),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 3.w,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        SizedBox(width: 1.w),
        Text(
          _formatDate(note.updatedAt),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Color? _getNoteColor(BuildContext context) {
    if (note.color == null) return null;
    
    switch (note.color?.toLowerCase()) {
      case 'blue':
        return Colors.blue.withOpacity(0.05);
      case 'green':
        return Colors.green.withOpacity(0.05);
      case 'orange':
        return Colors.orange.withOpacity(0.05);
      case 'purple':
        return Colors.purple.withOpacity(0.05);
      case 'red':
        return Colors.red.withOpacity(0.05);
      case 'yellow':
        return Colors.yellow.withOpacity(0.05);
      default:
        return null;
    }
  }

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
