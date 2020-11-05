import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ddd_todo/domain/core/value_objects.dart';
import 'package:firebase_ddd_todo/domain/notes/note.dart';
import 'package:firebase_ddd_todo/domain/notes/value_objects.dart';
import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_ddd_todo/domain/notes/todo_item.dart';
import 'package:kt_dart/kt.dart';
part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@freezed
abstract class NoteDto implements _$NoteDto {
  const NoteDto._();
  const factory NoteDto({
    @JsonKey(ignore: true) String id,
    @required String body,
    @required int color,
    @required List<TodoItemDto> todos,
    @required @ServerTimestampConverter() FieldValue serverTimeStamp,
  }) = _NoteDto;

  factory NoteDto.fromDomain(Note note) {
    return NoteDto(
        id: note.id.getOrCrash(),
        body: note.body.getOrCrash(),
        color: note.color.getOrCrash().value,
        todos: note.todos
            .getOrCrash()
            .map(
              (todoItem) => TodoItemDto.fromDomain(todoItem),
            )
            .asList(),
        serverTimeStamp: FieldValue.serverTimestamp());
  }

  Note toDomain() {
    return Note(
      id: UniqueId.fromUniqueString(id),
      body: NoteBody(body),
      color: NoteColor(Color(color)),
      todos: List3(todos.map((dto) => dto.toDomain()).toImmutableList()),
    );
  }

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  factory NoteDto.fromFirestore(DocumentSnapshot doc) {
    return NoteDto.fromJson(doc.data()).copyWith(id: doc.id);
  }
}

class ServerTimestampConverter implements JsonConverter<FieldValue, Object> {
  const ServerTimestampConverter();
  @override
  FieldValue fromJson(Object json) {
    return FieldValue.serverTimestamp();
  }

//converts fieldValue to object
  @override
  Object toJson(FieldValue fieldValue) => fieldValue;
}

@freezed
abstract class TodoItemDto implements _$TodoItemDto {
  const TodoItemDto._();
  const factory TodoItemDto({
    @required String id,
    @required String name,
    @required bool done,
  }) = _TodoItemDto;

  //converts TodoItem and maps to a TodoItemDto 
  factory TodoItemDto.fromDomain(TodoItem todoItem) {
    return TodoItemDto(
        id: todoItem.id.getOrCrash(),
        name: todoItem.name.getOrCrash(),
        done: todoItem.done);
  }

//* Maps to the domain our app can understand
  TodoItem toDomain() {
    return TodoItem(
        id: UniqueId.fromUniqueString(id), name: TodoName(name), done: done);
  }

  factory TodoItemDto.fromJson(Map<String, dynamic> json) =>
      _$TodoItemDtoFromJson(json);
}
