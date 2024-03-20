import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/auth/auth.dart';
import 'package:omdk/auth_login/view/login_page.dart';
import 'package:omdk/home/view/home_page.dart';
import 'package:omdk/splash/splash.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:provider/provider.dart';

/// Create base [App] to instance repo layer
class App extends StatelessWidget {
  /// Build [App] instance
  const App({
    required this.authRepo,
    required this.omdkLocalData,
    super.key,
  });

  /// [AuthRepo] instance
  final AuthRepo authRepo;

  /// [OMDKLocalData] instance
  final OMDKLocalData omdkLocalData;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(create: (context) => authRepo),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeRepo(omdkLocalData)),
        ],
        child: BlocProvider(
          create: (_) => AuthBloc(authRepo: authRepo),
          child: AppView(),
        ),
      ),
    );
  }
}

/// App view redirect user to login or home page due auth
class AppView extends StatelessWidget {
  /// create [AppView] instance
  AppView({super.key});

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: context.theme,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthStatus.authenticated:

                /// Redirect user to home page only if
                /// local session is validated
                _navigator.pushAndRemoveUntil(
                  HomePage.route(),
                  (route) => false,
                );
              case AuthStatus.unauthenticated:

                /// Session doesn't exist
                /// redirect user to login page
                _navigator.pushAndRemoveUntil(
                  LoginPage.route(),
                  (route) => false,
                );
              case AuthStatus.unknown:

                /// Initial and default status of AuthStatus
                /// Wait for changes
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
