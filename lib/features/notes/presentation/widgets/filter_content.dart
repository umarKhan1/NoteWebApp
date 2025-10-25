// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// Content widget for filter popover
class FilterContent extends StatefulWidget {

  /// Creates a [FilterContent]
  const FilterContent({
    super.key,
    required this.onApply,
    required this.onCancel,
    this.initialOperator,
    this.initialValue,
  });
  /// Callback when filter is applied
  final Function(String operator, String value) onApply;

  /// Callback when filter is canceled
  final VoidCallback onCancel;

  /// Initial operator value
  final String? initialOperator;

  /// Initial value
  final String? initialValue;

  @override
  State<FilterContent> createState() => _FilterContentState();
}

class _FilterContentState extends State<FilterContent> {
  late String _selectedOperator;
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _selectedOperator = widget.initialOperator ?? 'is';
    _valueController = TextEditingController(
      text: widget.initialValue ?? '',
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final value = _valueController.text.trim();
    if (_selectedOperator == 'has any value' || value.isNotEmpty) {
      widget.onApply(_selectedOperator, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final operators = [
      AppConstants.filterOperatorIs,
      AppConstants.filterOperatorIsNot,
      AppConstants.filterOperatorContains,
      AppConstants.filterOperatorHasAnyValue,
    ];

    return AlertDialog(
      title: const Text(AppConstants.filterTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio group
            ...operators.map((op) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOperator = op;
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: op,
                        groupValue: _selectedOperator,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedOperator = value;
                            });
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          op,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            // Conditional text field
            if (_selectedOperator != AppConstants.filterOperatorHasAnyValue) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _valueController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppConstants.filterValueHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onSubmitted: (_) {
                  _applyFilter();
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          
          onPressed: widget.onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            minimumSize: const Size(64, 20),
          ),
          onPressed: _applyFilter,
          child: const Text(AppConstants.filterApply),
        ),
      ],
    );
  }
}
