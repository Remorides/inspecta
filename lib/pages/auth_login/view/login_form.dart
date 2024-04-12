import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/elements/texts/simple_text_field/simple_text_field.dart%20';
import 'package:omdk/pages/auth_login/login.dart';

/// Login form class provide all required field to login
class LoginForm extends StatelessWidget {
  /// create [LoginForm] instance
  LoginForm({super.key});

  /// Focus node of CompanyCode field
  final companyCodeFN = FocusNode();
  /// Focus node of username field
  final usernameFN = FocusNode();
  /// Focus nod of password field
  final passwordFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoadingStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CompanyCodeInput(
              widgetFN: companyCodeFN,
              nextWidgetFN: usernameFN,
            ),
            const Padding(padding: EdgeInsets.all(12)),
            _UsernameInput(
              widgetFN: usernameFN,
              nextWidgetFN: passwordFN,
            ),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(
              widgetFN: passwordFN,
            ),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _CompanyCodeInput extends StatelessWidget {
  /// Create [_CompanyCodeInput] instance
  const _CompanyCodeInput({
    required this.widgetFN,
    this.nextWidgetFN,
  });

  final FocusNode widgetFN;
  final FocusNode? nextWidgetFN;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.companyCode != current.companyCode,
      builder: (context, state) {
        return SimpleTextField(
          key: const Key('loginForm_companyInput_textField'),
          onEditingComplete: (companyCode) => context
              .read<LoginBloc>()
              .add(LoginCompanyCodeChanged(companyCode!)),
          labelText: 'CompanyCode',
          textFocusNode: widgetFN,
          nextFocusNode: nextWidgetFN,
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  /// Create [_UsernameInput] instance
  const _UsernameInput({
    required this.widgetFN,
    this.nextWidgetFN,
  });

  final FocusNode widgetFN;
  final FocusNode? nextWidgetFN;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return SimpleTextField(
          key: const Key('loginForm_usernameInput_textField'),
          onEditingComplete: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username!)),
          labelText: 'Username',
          textFocusNode: widgetFN,
          nextFocusNode: nextWidgetFN,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  /// Create [_PasswordInput] instance
  const _PasswordInput({
    required this.widgetFN,
  });

  final FocusNode widgetFN;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return SimpleTextField(
          key: const Key('loginForm_passwordInput_textField'),
          onEditingComplete: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password!)),
          labelText: 'Password',
          isObscured: true,
          textFocusNode: widgetFN,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return (state.status == LoadingStatus.inProgress)
            ? const CircularProgressIndicator(
                color: Colors.red,
              )
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: () {
                  context.read<LoginBloc>().add(const LoginSubmitted());
                },
                child: const Text('Login'),
              );
      },
    );
  }
}
