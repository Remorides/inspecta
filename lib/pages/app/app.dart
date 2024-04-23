import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/pages/auth/bloc/auth_bloc.dart';
import 'package:omdk/pages/auth_login/view/login_page.dart';
import 'package:omdk/pages/home/view/home_page.dart';
import 'package:omdk/pages/splash/view/splash_page.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';
import 'package:provider/provider.dart';

/// Create base [App] to instance repo layer
class App extends StatefulWidget {
  /// Build [App] instance
  const App({
    required this.authRepo,
    required this.assetRepo,
    required this.assetListRepo,
    required this.omdkLocalData,
    super.key,
  });

  /// [AuthRepo] instance
  final AuthRepo authRepo;

  /// [EntityRepo] instance
  final EntityRepo<Asset> assetRepo;

  /// [EntityRepo] instance
  final EntityRepo<AssetListItem> assetListRepo;

  /// [OMDKLocalData] instance
  final OMDKLocalData omdkLocalData;

  @override
  State<App> createState() => _AppState();
}

/// AppState builder
class _AppState extends State<App> {
  @override
  void dispose() {
    widget.authRepo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(create: (context) => widget.authRepo),
        RepositoryProvider<EntityRepo<Asset>>(
          create: (context) => widget.assetRepo,
        ),
        RepositoryProvider<EntityRepo<AssetListItem>>(
          create: (context) => widget.assetListRepo,
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeRepo(widget.omdkLocalData),
            lazy: true,
          ),
        ],
        child: BlocProvider(
          create: (_) => AuthBloc(authRepo: widget.authRepo),
          child: const AppView(),
        ),
      ),
    );
  }
}

///
class AppView extends StatefulWidget {
  /// create [AppView] instance
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

/// App widget redirect user to login or home page due auth
class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: true,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

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
