import 'package:firebase_ddd_todo/application/notes/note_form/note_form_bloc.dart';
import 'package:firebase_ddd_todo/domain/notes/value_objects.dart';
import 'package:firebase_ddd_todo/presentation/notes/note_form/misc/todo_item_presntation_classes.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ddd_todo/presentation/notes/note_form/misc/build_context_x.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          FlushbarHelper.createAction(
            message: 'Want longer lists? Activate premium',
            button: FlatButton(
              onPressed: () {},
              child: const Text(
                'BUY NOW',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, child) {
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
            removeDuration: const Duration(),
            shrinkWrap: true,
            items: formTodos.value.asList(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            onReorderFinished: (item, from, to, newItems) {
              context.formTodos = newItems.toImmutableList();
              context
                  .read<NoteFormBloc>()
                  .add(NoteFormEvent.todosChanged(context.formTodos));
            },
            itemBuilder: (context, itemAnimation, item, index) {
              return Reorderable(
                key: ValueKey(item.id),
                builder: (context, animation, inDrag) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 0.95).animate(animation),
                                      child: TodoTile(
                      index: index,
                      elevation: animation.value * 4  ,
                    ),
                  );
                },
              );
            },
          
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;
  final double elevation;

  const TodoTile({@required this.index, double elevation, Key key})
      : elevation = elevation ?? 0,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final todo =
        context.formTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());
    final textEditingController = useTextEditingController(text: todo.name);
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            context.formTodos = context.formTodos.minusElement(todo);
            context
                .read<NoteFormBloc>()
                .add(NoteFormEvent.todosChanged(context.formTodos));
          },
        )
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Material(
          elevation: elevation,
          animationDuration: const Duration(milliseconds: 50),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Checkbox(
                value: todo.done,
                onChanged: (value) {
                  context.formTodos = context.formTodos.map((listTodo) =>
                      listTodo == todo ? todo.copyWith(done: value) : listTodo);
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
              ),
              trailing: const Handle(
                child: Icon(Icons.list),
              ),
              title: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Todo',
                  counterText: '',
                  border: InputBorder.none,
                ),
                maxLength: TodoName.maxLength,
                onChanged: (value) {
                  context.formTodos = context.formTodos.map((listTodo) =>
                      listTodo == todo ? todo.copyWith(name: value) : listTodo);
                  context
                      .read<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
                validator: (_) {
                  return context
                      .read<NoteFormBloc>()
                      .state
                      .note
                      .todos
                      .value
                      .fold(
                          (f) => null,
                          (todoList) => todoList[index].name.value.fold(
                              (l) => l.maybeMap(
                                    empty: (_) => 'Cannot be empty',
                                    exceedingLength: (_) => 'Too long',
                                    multiLine: (_) =>
                                        'Has to be in a single line',
                                    orElse: () => null,
                                  ),
                              (r) => null));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
