import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Widget for displaying and managing note image in the editor
class NoteImageSection extends StatelessWidget {
  /// The Base64 encoded image data
  final String? imageBase64;
  
  /// The original image filename
  final String? imageName;
  
  /// Callback when user wants to pick/change image
  final VoidCallback onPickImage;
  
  /// Callback when user wants to remove image
  final VoidCallback onRemoveImage;

  /// Creates a [NoteImageSection]
  const NoteImageSection({
    Key? key,
    this.imageBase64,
    this.imageName,
    required this.onPickImage,
    required this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageBase64 != null && imageBase64!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Note Image',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          if (hasImage)
            // Image preview card
            _buildImagePreviewCard(context, theme)
          else
            // Upload prompt
            _buildUploadPrompt(context, theme),
        ],
      ),
    );
  }

  /// Builds the image preview card
  Widget _buildImagePreviewCard(BuildContext context, ThemeData theme) {
    return Stack(
      children: [
        // Image container
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
            image: DecorationImage(
              image: MemoryImage(
                _decodeBase64(imageBase64!),
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Action buttons overlay
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            children: [
              // Change image button
              FloatingActionButton.small(
                onPressed: onPickImage,
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(Icons.edit),
              ),
              const SizedBox(width: 8),
              // Remove image button
              FloatingActionButton.small(
                onPressed: onRemoveImage,
                backgroundColor: Colors.red,
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
        
        // Image info at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Text(
              imageName ?? 'Image',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the upload prompt card
  Widget _buildUploadPrompt(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 2,
            style: BorderStyle.solid,
          ),
          color: theme.colorScheme.surfaceContainerLowest,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              'Add Image',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to select an image from your device',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Decodes Base64 string to bytes
  Uint8List _decodeBase64(String base64String) {
    // Remove data URI prefix if present
    String cleanBase64 = base64String;
    if (base64String.contains(',')) {
      cleanBase64 = base64String.split(',').last;
    }
    
    try {
      return Uint8List.fromList(base64Decode(cleanBase64));
    } catch (e) {
      return Uint8List(0);
    }
  }
}

