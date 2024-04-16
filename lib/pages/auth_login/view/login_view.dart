import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/elements/appbars/omdk_appbar.dart';
import 'package:omdk/elements/buttons/elevated_button/elevated_button.dart';
import 'package:omdk/elements/buttons/outlined_button/outlined_button.dart';
import 'package:omdk/elements/keyboard/keyboard.dart';
import 'package:omdk/elements/scaffolds/omdk_scaffold.dart';
import 'package:omdk/elements/spacers/space_widget.dart';
import 'package:omdk/elements/texts/simple_text_field/simple_text_field.dart';
import 'package:omdk/pages/auth_login/login.dart';

/// Login form class provide all required field to login
class LoginView extends StatelessWidget {
  /// create [LoginView] instance
  LoginView({super.key});

  /// Focus node of CompanyCode field
  final companyCodeFN = FocusNode();

  /// [SimpleTextBloc] of CompanyCode field
  final companyCodeB = SimpleTextBloc(isEmptyAllowed: false, isNullable: false);

  /// Focus node of username field
  final usernameFN = FocusNode();

  /// [SimpleTextBloc] of username field
  final usernameB = SimpleTextBloc(isEmptyAllowed: false, isNullable: false);

  /// Focus node of password field
  final passwordFN = FocusNode();

  /// [SimpleTextBloc] of password field
  final passwordB = SimpleTextBloc(isEmptyAllowed: false, isNullable: false);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoadingStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorText)),
            );
        }
      },
      child: OMDKScaffold(
        appBar: OMDKAppBar().appBar(
          context: context,
          title: 'Login',
        ),
        backgroundLogo: false,
        body: CustomKeyboardActions(
          focusNodes: [
            companyCodeFN,
            usernameFN,
            passwordFN,
          ],
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              const Space.vertical(40),
              _CompanyCodeInput(
                widgetFN: companyCodeFN,
                widgetB: companyCodeB,
                nextWidgetFN: usernameFN,
              ),
              const Padding(padding: EdgeInsets.all(12)),
              _UsernameInput(
                widgetFN: usernameFN,
                widgetB: usernameB,
                nextWidgetFN: passwordFN,
              ),
              const Padding(padding: EdgeInsets.all(12)),
              _PasswordInput(
                widgetFN: passwordFN,
                widgetB: passwordB,
              ),
              const Padding(padding: EdgeInsets.all(24)),
              const _ConfigurationsButton(),
              _LoginButton(
                companyCodeB: companyCodeB,
                usernameB: usernameB,
                passwordB: passwordB,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyCodeInput extends StatelessWidget {
  /// Create [_CompanyCodeInput] instance
  const _CompanyCodeInput({
    required this.widgetFN,
    required this.widgetB,
    this.nextWidgetFN,
  });

  final FocusNode widgetFN;
  final SimpleTextBloc widgetB;
  final FocusNode? nextWidgetFN;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.companyCode != current.companyCode,
      builder: (context, state) {
        return SimpleTextField(
          key: const Key('loginForm_companyInput_textField'),
          simpleTextBloc: widgetB,
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
    required this.widgetB,
    this.nextWidgetFN,
  });

  final FocusNode widgetFN;
  final SimpleTextBloc widgetB;
  final FocusNode? nextWidgetFN;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return SimpleTextField(
          key: const Key('loginForm_usernameInput_textField'),
          simpleTextBloc: widgetB,
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
    required this.widgetB,
  });

  final FocusNode widgetFN;
  final SimpleTextBloc widgetB;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return SimpleTextField(
          key: const Key('loginForm_passwordInput_textField'),
          simpleTextBloc: widgetB,
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
  /// Create [_LoginButton] instance
  const _LoginButton({
    required this.companyCodeB,
    required this.usernameB,
    required this.passwordB,
  });

  final SimpleTextBloc companyCodeB;
  final SimpleTextBloc usernameB;
  final SimpleTextBloc passwordB;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return (state.status == LoadingStatus.inProgress)
            ? const CircularProgressIndicator(
                color: Colors.red,
              )
            : OMDKElevatedButton(
                key: const Key('loginForm_continue_button'),
                onPressed: () {
                  if (state.companyCode.isEmpty) {
                    companyCodeB.add(ValidateData());
                  }
                  if (state.username.isEmpty) {
                    usernameB.add(ValidateData());
                  }
                  if (state.password.isEmpty) {
                    passwordB.add(ValidateData());
                  }
                  if (state.companyCode.isNotEmpty &&
                      state.username.isNotEmpty &&
                      state.password.isNotEmpty) {
                    context.read<LoginBloc>().add(const LoginSubmitted());
                  } else {
                    context.read<LoginBloc>().add(const EmptyField());
                  }
                },
                child: Text(
                  'Login'.toUpperCase(),
                  // style: context.theme?.textTheme.labelMedium?.copyWith(
                  //   color: const Color(0xFFDB4E1E),
                  //   fontSize: 16,
                  //   fontWeight: FontWeight.w700,
                  // ),
                ),
              );
      },
    );
  }
}

class _ConfigurationsButton extends StatelessWidget {
  /// Create [_ConfigurationsButton] instance
  const _ConfigurationsButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return (state.status == LoadingStatus.inProgress)
            ? const CircularProgressIndicator(
                color: Colors.red,
              )
            : OMDKOutlinedButton(
                key: const Key('configurationForm_button'),
                onPressed: () {},
                child: const Text(
                  'Manage Configurations',
                ),
              );
      },
    );
  }
}
