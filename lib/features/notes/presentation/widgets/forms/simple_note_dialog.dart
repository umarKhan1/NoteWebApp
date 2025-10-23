import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../shared/extensions/widget_extensions.dart';
import '../../cubit/notes_cubit.dart';
import '../../cubit/simple_note_form_cubit.dart';

/// Simple note dialog for testing
class SimpleNoteDialog extends StatelessWidget {
  /// Constructor
  const SimpleNoteDialog({super.key});

  /// Show the simple note dialog
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => SimpleNoteFormCubit(),
        child: const SimpleNoteDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SimpleNoteFormCubit, SimpleNoteFormState>(
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: AlertDialog(
        title: const Text(AppStrings.addNote),
        content: SizedBox(
          width: 400,
          child: _SimpleNoteForm(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          BlocBuilder<SimpleNoteFormCubit, SimpleNoteFormState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () => _handleSave(context),
                child: state.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(AppStrings.save),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    final formCubit = context.read<SimpleNoteFormCubit>();
    final notesCubit = context.read<NotesCubit>();
    
    final validationError = formCubit.validateForm();
    if (validationError != null) {
      formCubit.setError(validationError);
      return;
    }

    formCubit.setLoading(true);

    try {
      await notesCubit.createNote(
        title: formCubit.state.title.trim(),
        content: formCubit.state.content.trim(),
        category: AppStrings.personalCategory,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.noteCreatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      formCubit.setError('${AppStrings.noteCreationFailed}: $e');
    }
  }
}

/// Simple note form widget
class _SimpleNoteForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SimpleNoteFormCubit>();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<SimpleNoteFormCubit, SimpleNoteFormState>(
          builder: (context, state) {
            return TextField(
              onChanged: cubit.updateTitle,
              decoration: InputDecoration(
                labelText: AppStrings.noteTitleText,
                hintText: AppStrings.enterNoteTitleHint,
                border: const OutlineInputBorder(),
                errorText: state.error.isNotEmpty && 
                          state.error.contains('title') 
                    ? state.error 
                    : null,
              ),
            );
          },
        ),
        16.verticalSpace,
        BlocBuilder<SimpleNoteFormCubit, SimpleNoteFormState>(
          builder: (context, state) {
            return TextField(
              onChanged: cubit.updateContent,
              decoration: const InputDecoration(
                labelText: AppStrings.noteContent,
                hintText: AppStrings.enterNoteContentHint,
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            );
          },
        ),
      ],
    );
  }
}
