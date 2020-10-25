import 'package:dartz/dartz.dart';
import 'package:firebase_ddd_todo/domain/auth/auth_failure.dart';
import 'package:firebase_ddd_todo/domain/auth/user.dart';
import 'package:firebase_ddd_todo/domain/auth/value_objects.dart';
import 'package:flutter/foundation.dart';

/** 
 * FirebaseAuth & GoogleSignIn, complex classes wrapped
 * into one interface -- Facade Design Pattern
*/
abstract class IAuthFacade {
  Future<Option<User>> getSignedInUser();
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<void> signOut();
}
