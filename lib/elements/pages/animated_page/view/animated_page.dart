import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Login form class provide all required field to login
class OMDKAnimatedPage extends StatelessWidget {
  /// Create [OMDKAnimatedPage] instance
  const OMDKAnimatedPage({
    required this.bodyPage,
    this.withAppBar = true,
    this.withBottomBar = true,
    this.withDrawer = true,
    this.appBarTitle,
    this.focusNodeList = const [],
    super.key,
    this.leading,
    this.trailing,
    this.previousRoute,
  });

  /// Choose if you want to show or not appbar
  final bool withAppBar;

  /// Choose if you want to show or not bottom bar
  final bool withBottomBar;

  /// Choose if you want to integrate drawer or not in appBar
  final bool withDrawer;

  /// UI of page
  final Widget bodyPage;

  /// List of focus node items
  final List<FocusNode> focusNodeList;

  /// App bar title required to use appbar widget
  final String? appBarTitle;

  /// App bar leading widget
  final Widget? leading;

  /// App bar trailing widget
  final Widget? trailing;

  /// App bar details
  final String? previousRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OMDKAnimatedPageCubit(),
      child: _OMDKAnimatedPage(
        bodyPage: bodyPage,
        focusNodeList: focusNodeList,
        withAppBar: withAppBar,
        withBottomBar: withBottomBar,
        withDrawer: withDrawer,
        appBarTitle: appBarTitle,
        leading: leading,
        trailing: trailing,
        previousRoute: previousRoute,
      ),
    );
  }
}

class _OMDKAnimatedPage extends StatelessWidget {
  _OMDKAnimatedPage({
    required this.focusNodeList,
    required this.bodyPage,
    required this.withAppBar,
    required this.withBottomBar,
    required this.withDrawer,
    this.appBarTitle,
    this.leading,
    this.trailing,
    this.previousRoute,
  }) : assert(
          withAppBar && appBarTitle != null || !withAppBar,
          throw AssertionError('appBarTitle param is required if '
              'you want to show AppVBar widget'),
        );

  final bool withAppBar;
  final bool withBottomBar;
  final bool withDrawer;
  final Widget bodyPage;
  final List<FocusNode> focusNodeList;
  final String? appBarTitle;
  final Widget? leading;
  final Widget? trailing;
  final String? previousRoute;

  @override
  Widget build(BuildContext context) {
    final cubit = context.select((OMDKAnimatedPageCubit cubit) => cubit.state);
    return Material(
      child: withDrawer
          ? Stack(
              children: [
                const OMDKAnimatedDrawer(),
                AnimatedContainer(
                  transform:
                      Matrix4.translationValues(cubit.xOffsetDrawer, 0, 0),
                  duration: const Duration(milliseconds: 150),
                  child: GestureDetector(
                    onTap: () =>
                        context.read<OMDKAnimatedPageCubit>().collapseDrawer(),
                    child: AbsorbPointer(
                      absorbing: cubit.isDrawerExpanded,
                      child: CupertinoPageScaffold(
                        navigationBar: withAppBar
                            ? CupertinoNavigationBar(
                                backgroundColor:
                                    context.theme?.appBarTheme.backgroundColor,
                                brightness: Brightness.light,
                                leading: withDrawer &&
                                        !Navigator.of(context).canPop()
                                    ? GestureDetector(
                                        child: const Icon(
                                          Icons.menu_outlined,
                                          size: 20,
                                        ),
                                        onTap: () => context
                                            .read<OMDKAnimatedPageCubit>()
                                            .expandDrawer(),
                                      )
                                    : leading,
                                middle: Text(appBarTitle!),
                                trailing: trailing,
                                previousPageTitle: previousRoute,
                              )
                            : null,
                        child: _buildPage(context),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : CupertinoPageScaffold(
              navigationBar: withAppBar
                  ? CupertinoNavigationBar(
                      backgroundColor:
                          context.theme?.appBarTheme.backgroundColor,
                      brightness: Brightness.light,
                      leading: withDrawer && !Navigator.of(context).canPop()
                          ? GestureDetector(
                              child: const Icon(
                                Icons.menu_outlined,
                                size: 20,
                              ),
                              onTap: () => context
                                  .read<OMDKAnimatedPageCubit>()
                                  .expandDrawer(),
                            )
                          : leading,
                      middle: Text(appBarTitle!),
                      trailing: trailing,
                      previousPageTitle: previousRoute,
                    )
                  : null,
              child: _buildPage(context),
            ),
    );
  }

  Widget _buildPage(BuildContext context) => Scaffold(
        body: withBottomBar
            ? FloatingBottom(
                bottom: const OMDKBottomBar(),
                child: _buildBodyPage(context),
              )
            : _buildBodyPage(context),
      );

  Widget _buildBodyPage(BuildContext context) {
    if (kIsWeb) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: bodyPage,
        ),
      );
    }
    return SafeArea(
      child: (Platform.isAndroid || Platform.isIOS)
          ? CustomKeyboardActions(
              focusNodes: focusNodeList,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: bodyPage,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: bodyPage,
            ),
    );
  }
}
