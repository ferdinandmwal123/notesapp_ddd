import 'package:firebase_ddd_todo/domain/notes/note.dart';
import 'package:firebase_ddd_todo/domain/notes/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({Key key, @required this.note}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            note.body.getOrCrash(),
            style: const TextStyle(fontSize: 18),
          ),
          if (note.todos.length > 0) ...[
            const SizedBox(height: 4),
            Wrap(
              children: [
                ...note.todos
                    .getOrCrash()
                    .map(
                      (todo) => TodoDisplay(todo: todo),
                    )
                    .iter,
              ],
            )
          ]
        ],
      ),
    );
  }
}

class TodoDisplay extends StatelessWidget {
  final TodoItem todo;

  const TodoDisplay({Key key, @required this.todo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (todo.done)
          Icon(
            Icons.check_box,
            color: Theme.of(context).accentColor,
          ),
        if (!todo.done)
          Icon(
            Icons.check_box_outline_blank,
            color: Theme.of(context).disabledColor,
          )
      ],
    );
  }
}
