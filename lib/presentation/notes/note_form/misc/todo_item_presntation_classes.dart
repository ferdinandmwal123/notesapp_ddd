import 'package:firebase_ddd_todo/domain/core/value_objects.dart';
import 'package:firebase_ddd_todo/domain/notes/todo_item.dart';
import 'package:firebase_ddd_todo/domain/notes/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'todo_item_presntation_classes.freezed.dart';

class FormTodos extends ValueNotifier<KtList<TodoItemPrimitive>>{
  FormTodos() : super(emptyList<TodoItemPrimitive>());

}


@freezed
abstract class TodoItemPrimitive implements _$TodoItemPrimitive {
  const TodoItemPrimitive._();

  const factory TodoItemPrimitive({
    @required UniqueId id,
    @required String name,
    @required bool done,
  }) = _TodoItemPrimitive;

  factory TodoItemPrimitive.empty() =>
      TodoItemPrimitive(id: UniqueId(), name: '', done: false);

  factory TodoItemPrimitive.fromDomain(TodoItem todoItem) {
    return TodoItemPrimitive(
        id: todoItem.id,
        name: todoItem.name.getOrCrash(),
        done: todoItem.done);
  }

  TodoItem toDomain() {
    return TodoItem(
        id: id, name: TodoName(name), done: done);
  }
}
