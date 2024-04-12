import 'package:flutter/material.dart';

/// Example splash screen page
class SplashPage extends StatelessWidget {
  /// Create [SplashPage] instance
  const SplashPage({super.key});

  /// Define navigation route
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
