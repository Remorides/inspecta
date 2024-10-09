import 'package:flutter/cupertino.dart';
import 'package:omdk_inspecta/elements/alerts/alerts.dart';
import 'package:omdk_inspecta/elements/elements.dart';

/// Login page builder
class OTPFailsPage extends StatefulWidget {
  /// Create [OTPFailsPage] instance
  const OTPFailsPage({super.key});

  @override
  State<OTPFailsPage> createState() => _OTPFailsPageState();
}

class _OTPFailsPageState extends State<OTPFailsPage> {
  @override
  Widget build(BuildContext context) {
    return OMDKSimplePage(
      withAppbar: false,
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
