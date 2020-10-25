import 'package:dartz/dartz.dart';
import 'package:firebase_ddd_todo/domain/core/failures.dart';
import 'package:firebase_ddd_todo/domain/core/value_objects.dart';
import 'package:firebase_ddd_todo/domain/core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

// * we validate in the factory constructor so that email address is validated on instansiation
  factory EmailAddress(String input) {
    assert(input != null);
    return EmailAddress._(validateEmailAddress(input));
  }

  const EmailAddress._(
    this.value,
  );
}
class Password extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Password(String input) {
    assert(input != null);
    return Password._(validatePassword(input));
  }

  const Password._(
    this.value,
  );
}
