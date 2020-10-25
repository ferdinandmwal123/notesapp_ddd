import 'package:dartz/dartz.dart';
import 'package:firebase_ddd_todo/domain/notes/note_failure.dart';
import 'package:kt_dart/kt.dart';

import 'note.dart';

abstract class INoteRepository {
  //*CRUD
  Future<Either<NoteFailure, Unit>> create(Note note);
  Future<Either<NoteFailure, Unit>> update(Note note);
  Future<Either<NoteFailure, Unit>> delete(Note note);

  //*READ
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();
}
