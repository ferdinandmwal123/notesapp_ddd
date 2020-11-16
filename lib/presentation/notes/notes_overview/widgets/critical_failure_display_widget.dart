import 'package:firebase_ddd_todo/domain/notes/note_failure.dart';
import 'package:flutter/material.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure noteFailure;

  const CriticalFailureDisplay({Key key, @required this.noteFailure})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '😱',
            style: TextStyle(fontSize: 100),
          ),
          Text(
            noteFailure.maybeMap(
                insufficientPermission: (_) => 'Insufficient permissions',
                orElse: () => 'Unexpected error. \n Please, contact support'),
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          FlatButton(
              onPressed: () => print('Sending mail'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const[
                  Icon(Icons.mail),
                  SizedBox(width: 4,),
                  Text('I NEED HELP')
                ],
              ))
        ],
      ),
    );
  }
}
