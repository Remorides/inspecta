import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/auth_login/bloc/login_bloc.dart';
import 'package:omdk/auth_login/view/login_form.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Login page builder
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return CupertinoPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
              authRepo: RepositoryProvider.of<AuthRepo>(context),
            );
          },
          child: const LoginForm(),
        ),
      ),
    );
  }
}
