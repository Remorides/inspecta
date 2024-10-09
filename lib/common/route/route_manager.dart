import 'package:flutter/cupertino.dart';
import 'package:omdk_inspecta/common/route/routes.dart';
import 'package:omdk_inspecta/pages/pages.dart';

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case splashRoute:
        return CupertinoPageRoute(
          //settings: const RouteSettings(name: splashRoute),
          builder: (_) => const SplashPage(),
        );
      case loginRoute:
        return CupertinoPageRoute(
          //settings: const RouteSettings(name: loginRoute),
          builder: (_) => const LoginPage(),
        );
      case otpFailsRoute:
        return CupertinoPageRoute(
          //settings: const RouteSettings(name: otpFailsRoute),
          builder: (_) => const OTPFailsPage(),
        );
      case openTicketRoute:
        return CupertinoPageRoute(
          //settings: const RouteSettings(name: openTicketRoute),
          builder: (_) => const OpenTicketPage(),
        );
      case editTicketRoute:
        return CupertinoPageRoute(
          //settings: const RouteSettings(name: editTicketRoute),
          builder: (_) => const EditTicketPage(),
        );
      default:
        return CupertinoPageRoute(builder: (_) => const SplashPage());
    }
  }
}
