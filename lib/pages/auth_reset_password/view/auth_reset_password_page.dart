import 'package:flutter/cupertino.dart';
import 'package:omdk/elements/elements.dart';

part 'auth_reset_password_view.dart';

/// Login page builder
class ResetPasswordPage extends StatelessWidget {
  /// Create [ResetPasswordPage] instance
  const ResetPasswordPage({super.key});

  /// Global route of login page
  static Route<void> route() {
    return CupertinoPageRoute<dynamic>(
      builder: (_) => const ResetPasswordPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _ResetPasswordView();
  }
}
