import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_inspecta/blocs/auth/auth.dart';
import 'package:omdk_inspecta/blocs/mode/mode.dart';
import 'package:omdk_inspecta/blocs/sync/configs/configs_cubit.dart';
import 'package:omdk_inspecta/blocs/sync/theme/theme_cubit.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:provider/provider.dart';
import 'package:route_observer_mixin/route_observer_mixin.dart';

/// Create base [App] to instance repo layer
class App extends StatefulWidget {
  /// Build [App] instance
  const App({
    required this.defaultTheme,
    required this.authRepo,
    required this.omdkApi,
    required this.omdkLocalData,
    super.key,
    this.companyCode,
  });

  /// [AuthRepo] instance
  final AuthRepo authRepo;

  /// [OMDKApi] instance
  final OMDKApi omdkApi;

  /// [OMDKLocalData] instance
  final OMDKLocalData omdkLocalData;

  final ThemeData defaultTheme;

  final String? companyCode;

  @override
  State<App> createState() => _AppState();
}

/// AppState builder
class _AppState extends State<App> {
  @override
  void dispose() {
    //widget.authRepo.logOut();
    widget.authRepo.dispose();
    super.dispose();
  }

  //Get params from url
  final paramOTP = Uri.base.queryParameters['otp'];

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: widget.authRepo),
        RepositoryProvider.value(value: widget.omdkLocalData),
        RepositoryProvider<EntityRepo<Asset>>(
          create: (_) => EntityRepo(
            OperaApiAsset(widget.omdkApi.apiClient.client),
            entityIsarSchema: !kIsWeb ? AssetSchema : null,
          ),
        ),
        RepositoryProvider<EntityRepo<Node>>(
          create: (_) => EntityRepo(
            OperaApiNode(widget.omdkApi.apiClient.client),
            entityIsarSchema: !kIsWeb ? NodeSchema : null,
          ),
        ),
        RepositoryProvider<EntityRepo<ScheduledActivity>>(
          create: (_) => EntityRepo(
            OperaApiScheduled(
              widget.omdkApi.apiClient.client,
            ),
            entityIsarSchema: !kIsWeb ? ScheduledActivitySchema : null,
          ),
        ),
        RepositoryProvider<OperaAttachmentRepo>(
          create: (_) => OperaAttachmentRepo(
            OperaApiAttachment(
              widget.omdkApi.apiClient.client,
            ),
            entityIsarSchema: !kIsWeb ? AttachmentSchema : null,
          ),
        ),
        RepositoryProvider<EntityRepo<OSchema>>(
          create: (_) => EntityRepo(
            OperaApiSchema(
              widget.omdkApi.apiClient.client,
            ),
            entityIsarSchema: !kIsWeb ? OSchemaSchema : null,
          ),
        ),
        RepositoryProvider<EntityRepo<Group>>(
          create: (_) => EntityRepo(
            OperaApiGroupManager(
              widget.omdkApi.apiClient.client,
            ),
            entityIsarSchema: !kIsWeb ? GroupSchema : null,
          ),
        ),
        RepositoryProvider<EntityRepo<MappingVersion>>(
          create: (_) => EntityRepo(
            OperaMappingVersionManager(
              widget.omdkApi.apiClient.client,
            ),
            entityIsarSchema: !kIsWeb ? MappingVersionSchema : null,
          ),
        ),
        RepositoryProvider<OperaUserRepo>(
          create: (_) => OperaUserRepo(
            OperaApiUser(
              widget.omdkApi.apiClient.client,
            ),
            entityIsarSchema: !kIsWeb ? UserSchema : null,
          ),
        ),
        RepositoryProvider<OperaMappingMapRepo>(
          create: (_) => OperaMappingMapRepo(
            OperaMappingMapManager(
              widget.omdkApi.apiClient.client,
            ),
            entityIsarSchema: !kIsWeb ? MappingMapSchema : null,
          ),
        ),
        RepositoryProvider<OperaSynchronizationRepo>(
          create: (_) => OperaSynchronizationRepo(
            widget.omdkApi.apiClient.client,
          ),
        ),
        RepositoryProvider<OperaNodeOrganizationRepo>(
          create: (_) => OperaNodeOrganizationRepo(
            OperaApiNodeOrganization(
              widget.omdkApi.apiClient.client,
            ),
            entityIsarSchema: !kIsWeb ? OrganizationNodeSchema : null,
          ),
        ),
        RepositoryProvider<EntityRepo<SchemaListItem>>(
          create: (context) => EntityRepo(
            OperaApiSchemaListItem(widget.omdkApi.apiClient.client),
          ),
        ),
        RepositoryProvider<OperaUtils>(
          create: (_) => OperaUtils(widget.omdkLocalData),
        ),
      ],
      child: MultiProvider(
        providers: [
          RouteObserverProvider(),
          ChangeNotifierProvider<ConnectivityProvider>(
            create: (_) => ConnectivityProvider(),
            lazy: false,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ThemeCubit(
                companyCode: widget.companyCode,
                defaultTheme: widget.defaultTheme,
                localData: widget.omdkLocalData,
                themeRepo: OperaThemeRepo(
                  widget.omdkLocalData,
                  themeApi: OperaApiTheme(widget.omdkApi.apiClient.client),
                ),
              ),
              lazy: false,
            ),
            BlocProvider(create: (_) => ConfigsCubit(omdkApi: widget.omdkApi)),
            BlocProvider(
              create: (_) => AuthBloc(authRepo: widget.authRepo)
                ..add(
                  paramOTP != null
                      ? ValidateOTP(otp: paramOTP!)
                      : RestoreSession(),
                ),
            ),
            BlocProvider(create: (_) => SessionModeCubit()),
          ],
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
      onGenerateRoute: RouteManager.generateRoute,
      initialRoute: splashRoute,
      theme: context.watch<ThemeCubit>().state.themeData,
      navigatorKey: _navigatorKey,
      navigatorObservers: [RouteObserverProvider.of(context)],
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
                    await _navigator.pushReplacementNamed(editTicketRoute);
                  case Mode.openTicket:
                    await _navigator.pushReplacementNamed(openTicketRoute);
                  case Mode.none:
                    return;
                }

              case AuthStatus.tokenExpired:
              case AuthStatus.unauthenticated:

                /// Session doesn't exist
                /// redirect user to login page
                // await _navigator.pushAndRemoveUntil(
                //   LoginPage.route(),
                //   (route) => false,
                // );
                await _navigator.pushReplacementNamed(otpFailsRoute);
              case AuthStatus.unknown:

                /// Initial and default status of AuthStatus
                /// Wait for changes
                break;

              case AuthStatus.otpFailed:
                await _navigator.pushReplacementNamed(otpFailsRoute);
            }
          },
          child: child,
        );
      },
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
