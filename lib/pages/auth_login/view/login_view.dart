part of 'login_page.dart';

/// Login form class provide all required field to login
class _LoginView extends StatelessWidget {
  /// Build [_LoginView] instance
  _LoginView();

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

  /// Focus node of login button field
  final loginFN = FocusNode();

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
      child: OMDKSimplePage(
        appBarTitle: const Text('Login'),
        withBottomBar: false,
        withDrawer: false,
        focusNodeList: [
          companyCodeFN,
          usernameFN,
          passwordFN,
        ],
        bodyPage: ResponsiveWidget.isSmallScreen(context)
            ? ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  const Space.vertical(40),
                  _CompanyCodeInput(
                    widgetFN: companyCodeFN,
                    widgetB: companyCodeB,
                    nextWidgetFN: usernameFN,
                  ),
                  const Space.vertical(20),
                  _UsernameInput(
                    widgetFN: usernameFN,
                    widgetB: usernameB,
                    nextWidgetFN: passwordFN,
                  ),
                  const Space.vertical(20),
                  _PasswordInput(
                    widgetFN: passwordFN,
                    widgetB: passwordB,
                    nextWidgetFN: loginFN,
                  ),
                  const Space.vertical(100),
                  const _ConfigurationsButton(),
                  const Space.vertical(10),
                  _LoginButton(
                    companyCodeB: companyCodeB,
                    usernameB: usernameB,
                    passwordB: passwordB,
                    loginFN: loginFN,
                  ),
                ],
              )
            : Center(
                child: SizedBox(
                  width: 300,
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
                      const Space.vertical(20),
                      _UsernameInput(
                        widgetFN: usernameFN,
                        widgetB: usernameB,
                        nextWidgetFN: passwordFN,
                      ),
                      const Space.vertical(20),
                      _PasswordInput(
                        widgetFN: passwordFN,
                        widgetB: passwordB,
                        nextWidgetFN: loginFN,
                      ),
                      const Space.vertical(100),
                      const _ConfigurationsButton(),
                      const Space.vertical(10),
                      _LoginButton(
                        companyCodeB: companyCodeB,
                        usernameB: usernameB,
                        passwordB: passwordB,
                        loginFN: loginFN,
                      ),
                    ],
                  ),
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
          onSubmit: (companyCode) => context
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
          onSubmit: (username) =>
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
    this.nextWidgetFN,
  });

  final FocusNode widgetFN;
  final SimpleTextBloc widgetB;
  final FocusNode? nextWidgetFN;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return SimpleTextField(
          key: const Key('loginForm_passwordInput_textField'),
          simpleTextBloc: widgetB,
          onSubmit: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password!)),
          labelText: 'Password',
          isObscured: true,
          textFocusNode: widgetFN,
          nextFocusNode: nextWidgetFN,
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
    this.loginFN,
  });

  final SimpleTextBloc companyCodeB;
  final SimpleTextBloc usernameB;
  final SimpleTextBloc passwordB;
  final FocusNode? loginFN;

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
                focusNode: loginFN,
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
                child: const Text(
                  'Login',
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
    return OMDKOutlinedButton(
      key: const Key('configurationForm_button'),
      //onPressed: () => OMDKFullBottomSheet.show(context),
      //onPressed: () => OMDKBottomSheetNavigation.show(context),
      onPressed: () => OMDKAlert.show(
        context,
        OMDKAlert.example,
      ),
      child: const Text('Manage Configurations'),
    );
  }
}
