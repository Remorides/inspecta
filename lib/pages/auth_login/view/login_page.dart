import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk/pages/auth_login/login.dart';
import 'package:omdk/pages/auth_reset_password/view/auth_reset_password_page.dart';
import 'package:omdk_repo/omdk_repo.dart';

part 'login_view.dart';

/// Login page builder
class LoginPage extends StatelessWidget {
  /// Create [LoginPage] instance
  const LoginPage({super.key});

  /// Global route of login page
  static Route<void> route() {
    return CupertinoPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoginBloc(
          authRepo: RepositoryProvider.of<AuthRepo>(context),
        );
      },
      child: _LoginView(),
    );
  }
}
