import 'package:firebase_ddd_todo/presentation/core/app_widget.dart';
import 'package:firebase_ddd_todo/presentation/injection.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(AppWidget());
}

