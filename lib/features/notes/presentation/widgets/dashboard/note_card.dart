import 'package:flutter/material.dart';

import '../../../domain/entities/note.dart';

/// Individual note card widget (smaller version for dashboard)
class NoteCard extends StatefulWidget {
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

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePin,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -4.0 : 0.0)
          ..scale(_isHovered ? 1.02 : 1.0),
        child: Container(
          height: 120, // Smaller height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _getNoteColor(),
            border: Border.all(
              color: _isHovered 
                ? const Color(0xFF6366F1).withOpacity(0.3) 
                : const Color(0xFFE5E7EB).withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03),
                blurRadius: _isHovered ? 12 : 4,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 6),
                    _buildTitle(context),
                    const SizedBox(height: 4),
                    _buildContent(context),
                    const Spacer(),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (widget.note.category != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getCategoryColor().withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.note.category!,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: _getCategoryColor(),
                letterSpacing: 0.3,
              ),
            ),
          ),
          const Spacer(),
        ] else
          const Spacer(),
        
        // Pin Icon
        if (widget.note.isPinned)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: _getCategoryColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.push_pin,
              size: 12,
              color: _getCategoryColor(),
            ),
          ),
        
        const SizedBox(width: 4),
        
        // More Menu
        AnimatedOpacity(
          opacity: _isHovered ? 1.0 : 0.6,
          duration: const Duration(milliseconds: 200),
          child: PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: _isHovered 
                  ? const Color(0xFF6B7280).withOpacity(0.1)
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.more_horiz,
                size: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit_outlined, size: 16),
                    const SizedBox(width: 8),
                    const Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'pin',
                child: Row(
                  children: [
                    Icon(
                      widget.note.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(widget.note.isPinned ? 'Unpin' : 'Pin'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  widget.onEdit();
                  break;
                case 'pin':
                  widget.onTogglePin();
                  break;
                case 'delete':
                  widget.onDelete();
                  break;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      widget.note.title.isEmpty ? 'Untitled Note' : widget.note.title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F2937),
        height: 1.2,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContent(BuildContext context) {
    final content = widget.note.content.replaceAll('\n', ' ').trim();
    if (content.isEmpty) return const SizedBox.shrink();
    
    return Text(
      content,
      style: TextStyle(
        fontSize: 10,
        color: const Color(0xFF6B7280),
        height: 1.3,
        fontWeight: FontWeight.w400,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF9CA3AF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.access_time,
                size: 10,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 3),
              Text(
                _formatDate(widget.note.updatedAt),
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getNoteColor() {
    if (widget.note.color == null) return Colors.white;
    
    switch (widget.note.color?.toLowerCase()) {
      case 'blue':
        return const Color(0xFFF0F9FF);
      case 'green':
        return const Color(0xFFF0FDF4);
      case 'orange':
        return const Color(0xFFFFF7ED);
      case 'purple':
        return const Color(0xFFFAF5FF);
      case 'red':
        return const Color(0xFFFEF2F2);
      case 'yellow':
        return const Color(0xFFFEFCE8);
      default:
        return Colors.white;
    }
  }

  Color _getCategoryColor() {
    if (widget.note.category == null) return const Color(0xFF6366F1);
    
    switch (widget.note.category?.toLowerCase()) {
      case 'work':
        return const Color(0xFF10B981);
      case 'personal':
        return const Color(0xFFF59E0B);
      case 'creative':
        return const Color(0xFF8B5CF6);
      case 'health':
        return const Color(0xFFEF4444);
      case 'welcome':
        return const Color(0xFF6366F1);
      default:
        return const Color(0xFF6366F1);
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
