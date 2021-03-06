import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_ddd_todo/application/notes/note_form/note_form_bloc.dart';
import 'package:firebase_ddd_todo/domain/notes/note.dart';
import 'package:firebase_ddd_todo/presentation/notes/note_form/widgets/add_todo_tile_widget.dart';
import 'package:firebase_ddd_todo/presentation/notes/note_form/widgets/body_field_widget.dart';
import 'package:firebase_ddd_todo/presentation/notes/note_form/widgets/color_field_widget.dart';
import 'package:firebase_ddd_todo/presentation/notes/note_form/widgets/todo_list_widget.dart';
import 'package:firebase_ddd_todo/presentation/routes/router.gr.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../injection.dart';
import 'misc/todo_item_presntation_classes.dart';

class NoteFormPage extends StatelessWidget {
  final Note editedNote;

  const NoteFormPage({Key key, @required this.editedNote}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(NoteFormEvent.initialized(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (p, c) =>
            p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(() => {}, (a) {
            a.fold((l) {
              FlushbarHelper.createError(
                message: l.map(
                    unexpected: (_) => 'Unexpected error',
                    insufficientPermission: (_) => 'Insufficient permissions',
                    unableToUpdate: (_) => 'Unable to update'),
              ).show(context);
            }, (r) {
              ExtendedNavigator.of(context).popUntil(
                  (route) => route.settings.name == Routes.notesOverviewPage);
            });
          });
        },
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) {
          return Stack(
            children: [
              const NoteFormPageScaffold(),
              SavingInProgressOverlay(
                isSaving: state.isSaving,
              ),
            ],
          );
        },
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;
  const SavingInProgressOverlay({
    Key key,
    @required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: !isSaving,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            color:
                isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Visibility(
              visible: isSaving,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Saving',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            )));
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (p, c) => p.isEditing != c.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit a note' : 'Create a note');
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
              })
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (p,c) => p.showErrorMessages != c.showErrorMessages,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
                      child: Form(
              autovalidate: state.showErrorMessages,
                child: SingleChildScrollView(
              child: Column(
                children: [
                  const BodyField(),
                  const ColorField(),
                  const TodoList(),
                  const AddTodoTile(),
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}
