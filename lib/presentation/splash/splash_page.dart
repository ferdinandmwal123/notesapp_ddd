import 'package:auto_route/auto_route.dart';
import 'package:firebase_ddd_todo/application/auth/auth_bloc.dart';
import 'package:firebase_ddd_todo/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      state.map(
        initial: (_) {},
        authenticated: (_) {
          print('I am authenticated');
        },
        unauthenticated: (_) =>
            ExtendedNavigator.of(context).replace(Routes.signInPage),
      );
    },
    child: const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ),
    );
  }
}
