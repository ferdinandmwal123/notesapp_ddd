import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ddd_todo/presentation/core/app_widget.dart';
import 'package:firebase_ddd_todo/presentation/injection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureInjection(Environment.prod);
  runApp(AppWidget());
}
class X extends StatefulWidget {
  @override
  _XState createState() => _XState();
}

class _XState extends State<X> {
  @override
  Widget build(BuildContext context) {
    return Container(
    
    );
  }
}

