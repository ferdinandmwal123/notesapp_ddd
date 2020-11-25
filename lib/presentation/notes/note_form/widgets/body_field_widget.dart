import 'package:firebase_ddd_todo/application/notes/note_form/note_form_bloc.dart';
import 'package:firebase_ddd_todo/domain/notes/value_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BodyField extends HookWidget {
  const BodyField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textEditController = useTextEditingController();

    return BlocListener<NoteFormBloc, NoteFormState>(
        //*it will only listen when isEditing changes to true , that is when a note is being passed and
        //*we are editing it. So even though state.note.body should crash when it is empty, it won't
        //* as we only listen when isEditing changes to true meaning there is an initial note
        listenWhen: (p, c) => p.isEditing != c.isEditing,
        listener: (context, state) {
          textEditController.text = state.note.body.getOrCrash();
        },
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: textEditController,
              decoration:
                  const InputDecoration(labelText: 'Note', counterText: ''),
              maxLength: NoteBody.maxLength,
              maxLines: null,
              minLines: 5,
              onChanged: (value) => context
                  .read<NoteFormBloc>()
                  .add(NoteFormEvent.bodyChanged(value)),

              //* we get the state directly so we always have the current state
              validator: (_) => context
                  .read<NoteFormBloc>()
                  .state
                  .note
                  .body
                  .value
                  .fold(
                      (l) => l.maybeMap(
                          empty: (l) => "Cannot be empty",
                          exceedingLength: (l) =>
                              'Exceeding length, max : ${l.max}',
                          orElse: null),
                      (r) => null),
            )));
  }
}
