import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/alerts/alerts.dart';

/// Example splash screen page
class SplashPage extends StatelessWidget {
  /// Create [SplashPage] instance
  const SplashPage({
    super.key,
    this.alert,
  });

  /// Define navigation route
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  final OMDKAlert? alert;

  @override
  Widget build(BuildContext context) {
    if(alert != null){
      OMDKAlert.show(
        context,
        alert!,
      );
    }
    return Scaffold(
      body: Center(
        child: alert != null
            ? const CircularProgressIndicator()
            : Container(
                color: Colors.transparent,
              ),
      ),
    );
  }
}
