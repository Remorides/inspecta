part of 'auth_reset_password_page.dart';

/// Login page builder
class _ResetPasswordView extends StatelessWidget {
  /// Create [_ResetPasswordView] instance
  const _ResetPasswordView();

  @override
  Widget build(BuildContext context) {
    return OMDKAnimatedPage(
      appBarTitle: 'Reset Password',
      bodyPage: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: const [
          Space.vertical(40),
        ],
      ),
      withBottomBar: false,
    );
  }
}
