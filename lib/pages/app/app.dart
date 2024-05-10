import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/pages/auth/bloc/auth_bloc.dart';
import 'package:omdk/pages/auth_login/view/login_page.dart';
import 'package:omdk/pages/edit_ticket/edit_scheduled.dart';
import 'package:omdk/pages/open_ticket/view/open_ticket_page.dart';
import 'package:omdk/pages/otp_fails/otp_fails.dart';
import 'package:omdk/pages/splash/view/splash_page.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_mapping/omdk_mapping.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';
import 'package:opera_repo/opera_repo.dart';
import 'package:provider/provider.dart';

/// Create base [App] to instance repo layer
class App extends StatefulWidget {
  /// Build [App] instance
  const App({
    required this.authRepo,
    required this.omdkLocalData,
    required this.assetRepo,
    required this.schemaListRepo,
    required this.mappingRepo,
    required this.schemaRepo,
    required this.operaRepo,
    required this.scheduledRepo,
    super.key,
  });

  /// [AuthRepo] instance
  final AuthRepo authRepo;

  /// [OperaRepo] instance
  final OperaRepo operaRepo;

  /// [EntityRepo] instance
  final EntityRepo<Asset> assetRepo;

  /// [EntityRepo] instance
  final EntityRepo<OSchema> schemaRepo;

  /// [EntityRepo] instance
  final EntityRepo<MappingVersion> mappingRepo;

  /// [EntityRepo] instance
  final EntityRepo<SchemaListItem> schemaListRepo;

  /// [EntityRepo] instance
  final EntityRepo<ScheduledActivity> scheduledRepo;

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

  //Get params from url
  final paramOTP = Uri.base.queryParameters['otp'];

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(create: (context) => widget.authRepo),
        RepositoryProvider<OperaRepo>(create: (context) => widget.operaRepo),
        RepositoryProvider<EntityRepo<Asset>>(
          create: (context) => widget.assetRepo,
        ),
        RepositoryProvider<EntityRepo<OSchema>>(
          create: (context) => widget.schemaRepo,
        ),
        RepositoryProvider<EntityRepo<SchemaListItem>>(
          create: (context) => widget.schemaListRepo,
        ),
        RepositoryProvider<EntityRepo<MappingVersion>>(
          create: (context) => widget.mappingRepo,
        ),
        RepositoryProvider<EntityRepo<ScheduledActivity>>(
          create: (context) => widget.scheduledRepo,
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
          create: (_) => AuthBloc(authRepo: widget.authRepo)
            ..add(
              paramOTP != null ? ValidateOTP(otp: paramOTP!) : RestoreSession(),
            ),
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

    final paramMode = Uri.base.queryParameters['mode'];

    return MaterialApp(
      theme: context.theme,
      navigatorKey: _navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: getLocaleFromCode(Uri.base.queryParameters['language']),
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('es'),
        Locale('it'),
      ],
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            switch (state.status) {
              case AuthStatus.authenticated:

                /// Redirect user to home page only if
                /// local session is validated
                switch (Mode.fromJson(paramMode ?? 'none')) {
                  case Mode.editTicket:
                    await _navigator.pushAndRemoveUntil(
                      EditTicketPage.route(),
                      (route) => false,
                    );
                  case Mode.openTicket:
                    await _navigator.pushAndRemoveUntil(
                      OpenTicketPage.route(),
                      (route) => false,
                    );
                  case Mode.none:
                    return;
                }

              case AuthStatus.unauthenticated:

                /// Session doesn't exist
                /// redirect user to login page
                await _navigator.pushAndRemoveUntil(
                  LoginPage.route(),
                  (route) => false,
                );
              case AuthStatus.unknown:

                /// Initial and default status of AuthStatus
                /// Wait for changes
                break;

              case AuthStatus.otpFailed:
                await _navigator.pushAndRemoveUntil(
                  OTPFailsPage.route(),
                  (route) => false,
                );
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }

  Locale getLocaleFromCode(String? inputLanguage) {
    if (inputLanguage == null) {
      return const Locale('en');
    }
    if (inputLanguage.length == 5) {
      return Locale(inputLanguage.substring(0, 2).toLowerCase());
    } else if (inputLanguage.length == 2) {
      return Locale(inputLanguage.toLowerCase());
    } else {
      return const Locale('en');
    }
  }
}
