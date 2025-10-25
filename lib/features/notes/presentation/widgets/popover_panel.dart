import 'package:flutter/material.dart';

/// Reusable popover panel widget for filter and sort UI
class PopoverPanel extends StatefulWidget {
  /// Creates a [PopoverPanel]
  const PopoverPanel({
    super.key,
    required this.title,
    required this.content,
    required this.onApply,
    required this.onCancel,
    this.primaryButtonLabel = 'Apply',
  });

  /// Title displayed at the top
  final String title;

  /// Content widget to display inside the panel
  final Widget content;

  /// Callback when Apply button is pressed
  final VoidCallback onApply;

  /// Callback when Cancel button is pressed
  final VoidCallback onCancel;

  /// Label for the primary button (default: 'Apply')
  final String primaryButtonLabel;

  @override
  State<PopoverPanel> createState() => _PopoverPanelState();
}

class _PopoverPanelState extends State<PopoverPanel> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        width: 280,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: widget.content,
              ),
            ),
            const Divider(height: 1),
            // Footer buttons
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: widget.onApply,
                    child: Text(widget.primaryButtonLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
