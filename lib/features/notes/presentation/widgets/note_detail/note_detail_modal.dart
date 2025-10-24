import 'package:flutter/material.dart';

import '../../../data/services/note_pdf_service.dart';
import '../../../domain/entities/note.dart';
import '../markdown/markdown_preview.dart';

/// Beautiful note detail modal that matches the card colors
class NoteDetailModal extends StatelessWidget {
  /// The note to display
  final Note note;
  
  /// Constructor
  const NoteDetailModal({
    super.key,
    required this.note,
  });

  /// Show the note detail modal
  static void show(BuildContext context, Note note) {
    final size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: size.width >= 1024
            ? 1000
            : size.width >= 600
                ? 800
                : size.width,
        maxHeight: size.height * 0.9,
      ),
      builder: (context) => NoteDetailModal(note: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteColors = _getNoteColors();
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Responsive breakpoints
    final isSmallMobile = screenWidth < 400;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    return Align(
      alignment: isDesktop ? Alignment.center : Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(
          top: isDesktop ? 40 : isTablet ? 30 : 20,
          bottom: keyboardHeight + (isDesktop ? 40 : isTablet ? 30 : 20),
          left: isDesktop ? 40 : isTablet ? 20 : 10,
          right: isDesktop ? 40 : isTablet ? 20 : 10,
        ),
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 900 : isTablet ? screenWidth * 0.85 : screenWidth * 0.95,
          maxHeight: screenHeight * (isDesktop ? 0.85 : isTablet ? 0.88 : 0.93),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              noteColors.primary,
              noteColors.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(
            isSmallMobile ? 16 : isMobile ? 20 : isTablet ? 24 : 28
          ),
          boxShadow: [
            BoxShadow(
              color: noteColors.primary.withValues(alpha: 0.3),
              blurRadius: isDesktop ? 20 : isTablet ? 16 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            isSmallMobile ? 16 : isMobile ? 20 : isTablet ? 24 : 28
          ),
          child: Column(
            children: [
              _buildHeader(theme, isSmallMobile, isMobile, isTablet),
              Expanded(
                child: _buildContent(theme, isSmallMobile, isMobile, isTablet),
              ),
              _buildActionButtons(theme, isSmallMobile, isMobile, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isSmallMobile, bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isSmallMobile ? 16 : isMobile ? 20 : isTablet ? 24 : 28),
      child: Row(
        children: [
          // Vertical line icon
          Container(
            width: 4,
            height: isSmallMobile ? 40 : isMobile ? 48 : 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: isSmallMobile ? 12 : isMobile ? 16 : 20),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                if (note.category != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallMobile ? 8 : isMobile ? 10 : 12,
                      vertical: isSmallMobile ? 4 : isMobile ? 6 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(isSmallMobile ? 12 : 16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      note.category!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isSmallMobile ? 12 : isMobile ? 14 : 16,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallMobile ? 8 : isMobile ? 12 : 16),
                ],
                
                // Title
                Text(
                  note.title.isEmpty ? 'Untitled Note' : note.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: isSmallMobile ? 20 : isMobile ? 24 : isTablet ? 28 : 32,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: isSmallMobile ? 8 : isMobile ? 12 : 16),
                
                // Date and pin status
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: isSmallMobile ? 14 : isMobile ? 16 : 18,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    SizedBox(width: isSmallMobile ? 4 : 8),
                    Expanded(
                      child: Text(
                        _formatDate(note.updatedAt),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: isSmallMobile ? 12 : isMobile ? 14 : 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (note.isPinned) ...[
                      SizedBox(width: isSmallMobile ? 8 : 12),
                      Container(
                        padding: EdgeInsets.all(isSmallMobile ? 4 : 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.push_pin,
                          size: isSmallMobile ? 14 : isMobile ? 16 : 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Close button
          Builder(
            builder: (context) => IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Container(
                padding: EdgeInsets.all(isSmallMobile ? 6 : 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.close,
                  size: isSmallMobile ? 18 : isMobile ? 20 : 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, bool isSmallMobile, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: isSmallMobile ? 16 : isMobile ? 20 : isTablet ? 24 : 28,
      ),
      padding: EdgeInsets.all(isSmallMobile ? 16 : isMobile ? 20 : isTablet ? 24 : 28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isSmallMobile ? 12 : isMobile ? 16 : 20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        child: note.content.trim().isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_outlined,
                      size: isSmallMobile ? 48 : isMobile ? 56 : 64,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: isSmallMobile ? 12 : 16),
                    Text(
                      'This note is empty',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: isSmallMobile ? 16 : isMobile ? 18 : 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : MarkdownPreview(
                content: note.content,
                isSmallScreen: isMobile,
                comeFromDetail: true,
              ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isSmallMobile, bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isSmallMobile ? 16 : isMobile ? 20 : isTablet ? 24 : 28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isMobile) ...[
              // Mobile: Stacked buttons
              _buildActionButton(
                icon: Icons.print_outlined,
                label: 'Print',
                onPressed: () => _handlePrint(),
                isSmallMobile: isSmallMobile,
                isMobile: isMobile,
              ),
              SizedBox(height: isSmallMobile ? 8 : 12),
              _buildActionButton(
                icon: Icons.picture_as_pdf_outlined,
                label: 'Download PDF',
                onPressed: () async {
                  try {
                    await NotePdfService.downloadNotePdf(note);
                  } catch (e) {
                    // Handle error silently - could show a toast/snackbar if needed
                    // For now, we'll just prevent crashes
                  }
                },
                isSmallMobile: isSmallMobile,
                isMobile: isMobile,
              ),
              SizedBox(height: isSmallMobile ? 8 : 12),
              _buildActionButton(
                icon: Icons.edit_outlined,
                label: 'Edit Note',
                onPressed: () {
                  // TODO: Implement edit functionality
                },
                isSmallMobile: isSmallMobile,
                isMobile: isMobile,
              ),
              SizedBox(height: isSmallMobile ? 8 : 12),
              _buildActionButton(
                icon: Icons.delete_outline,
                label: 'Delete Note',
                onPressed: () {
                  // TODO: Implement delete functionality
                },
                isSmallMobile: isSmallMobile,
                isMobile: isMobile,
                isDestructive: true,
              ),
            ] else ...[
              // Desktop/Tablet: Row of buttons
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.print_outlined,
                      label: 'Print',
                      onPressed: () => _handlePrint(),
                      isSmallMobile: isSmallMobile,
                      isMobile: isMobile,
                    ),
                  ),
                  SizedBox(width: isTablet ? 12 : 16),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.picture_as_pdf_outlined,
                      label: 'Download PDF',
                      onPressed: () async {
                        try {
                          await NotePdfService.downloadNotePdf(note);
                        } catch (e) {
                          // Handle error silently - could show a toast/snackbar if needed
                          // For now, we'll just prevent crashes
                        }
                      },
                      isSmallMobile: isSmallMobile,
                      isMobile: isMobile,
                    ),
                  ),
                  SizedBox(width: isTablet ? 12 : 16),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit Note',
                      onPressed: () {
                        // TODO: Implement edit functionality
                      },
                      isSmallMobile: isSmallMobile,
                      isMobile: isMobile,
                    ),
                  ),
                  SizedBox(width: isTablet ? 12 : 16),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete Note',
                      onPressed: () {
                        // TODO: Implement delete functionality
                      },
                      isSmallMobile: isSmallMobile,
                      isMobile: isMobile,
                      isDestructive: true,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isSmallMobile,
    required bool isMobile,
    bool isDestructive = false,
  }) {
    return Container(
      width: double.infinity,
      height: isSmallMobile ? 44 : isMobile ? 48 : 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: isSmallMobile ? 16 : isMobile ? 18 : 20,
          color: isDestructive ? Colors.red.shade300 : Colors.white,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isDestructive ? Colors.red.shade300 : Colors.white,
            fontSize: isSmallMobile ? 13 : isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDestructive ? Colors.red.shade300 : Colors.white.withValues(alpha: 0.6),
            width: 1.5,
          ),
          backgroundColor: isDestructive 
              ? Colors.red.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmallMobile ? 8 : isMobile ? 10 : 12),
          ),
        ),
      ),
    );
  }

  /// Get note colors matching the card
  ({Color primary, Color secondary}) _getNoteColors() {
    final colorIndex = (note.id.hashCode) % _colorPalettes.length;
    return _colorPalettes[colorIndex];
  }

  /// Handle print button press
  void _handlePrint() {
    try {
      NotePdfService.printNotePdf(note);
    } catch (e) {
      // Handle error silently - could show a toast/snackbar if needed
      // For now, we'll just prevent crashes
    }
  }

  /// Color palettes matching the note cards
  static const List<({Color primary, Color secondary})> _colorPalettes = [
    (primary: Color(0xFFFF6B6B), secondary: Color(0xFFFFE66D)),
    (primary: Color(0xFF4ECDC4), secondary: Color(0xFF44A08D)),
    (primary: Color(0xFFA8EDEA), secondary: Color(0xFFFED6E3)),
    (primary: Color(0xFF56AB2F), secondary: Color(0xFFA8E6CF)),
    (primary: Color(0xFF667EEA), secondary: Color(0xFF764BA2)),
    (primary: Color(0xFFFF8A80), secondary: Color(0xFFFFAB91)),
    (primary: Color(0xFF81C784), secondary: Color(0xFFAED581)),
    (primary: Color(0xFF42A5F5), secondary: Color(0xFF29B6F6)),
    (primary: Color(0xFFBA68C8), secondary: Color(0xFFE1BEE7)),
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
