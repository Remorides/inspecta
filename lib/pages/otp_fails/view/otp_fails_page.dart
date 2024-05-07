import 'package:flutter/cupertino.dart';
import 'package:omdk/elements/alerts/alerts.dart';
import 'package:omdk/elements/alerts/simple_alert/simple_alert.dart';
import 'package:omdk/elements/elements.dart';

/// Login page builder
class OTPFailsPage extends StatefulWidget {
  /// Create [OTPFailsPage] instance
  const OTPFailsPage({super.key});

  /// Global route of login page
  static Route<void> route() {
    return CupertinoPageRoute<void>(
      builder: (_) => const OTPFailsPage(),
    );
  }

  @override
  State<OTPFailsPage> createState() => _OTPFailsPageState();
}

class _OTPFailsPageState extends State<OTPFailsPage> {
  @override
  Widget build(BuildContext context) {
    return OMDKAnimatedPage(
      withAppBar: false,
      withBottomBar: false,
      withDrawer: false,
      bodyPage: ResponsiveWidget.isSmallScreen(context)
          ? Center(
              child: OMDKAlert(
                title: 'Warning',
                message: const Text('OTP is not valid'),
                confirm: 'OK',
                type: AlertType.warning,
                onConfirm: () async {},
              ),
            )
          : Center(
              child: SizedBox(
                width: 300,
                child: OMDKAlert(
                  title: 'Warning',
                  message: const Text('OTP is not valid'),
                  confirm: 'OK',
                  type: AlertType.warning,
                  onConfirm: () async {
                    // await Navigator.pushAndRemoveUntil(
                    //   context,
                    //   LoginPage.route(),
                    //   (route) => false,
                    // );
                  },
                ),
              ),
            ),
    );
  }
}
