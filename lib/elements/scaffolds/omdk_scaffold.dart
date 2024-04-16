import 'package:flutter/material.dart';

class OMDKScaffold extends StatelessWidget {
  /// Create [OMDKScaffold] instance
  const OMDKScaffold({
    required this.body,
    this.appBar,
    this.drawer,
    this.backgroundLogo = true,
    this.floatingbutton,
    super.key,
  });

  final AppBar? appBar;
  final Widget body;
  final bool backgroundLogo;
  final Widget? drawer;
  final Widget? floatingbutton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingbutton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: drawer,
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Container(
        decoration: backgroundLogo
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bulb.jpg'),
                  fit: BoxFit.cover,
                ),
              )
            : null,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: context._unFocus,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: body,
          ),
        ),
      ),
    );
  }
}

extension _RealUnfocus on BuildContext {
  void _unFocus() {
    final currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      currentScope.unfocus();
    }
  }
}
