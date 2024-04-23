import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/elements.dart';

/// Login form class provide all required field to login
class OMDKAnimatedNavigationPage extends StatelessWidget {
  /// Create [OMDKAnimatedNavigationPage] instance
  const OMDKAnimatedNavigationPage({
    required this.bodyPage,
    required this.appBarTitle,
    required this.childrenKey,
    this.withAppBar = true,
    this.withBottomBar = true,
    this.withDrawer = true,
    this.navigationTree,
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

  /// Tree data organization
  final List<Map<String, dynamic>>? navigationTree;

  /// Children key
  final String childrenKey;

  /// UI of page
  final Widget bodyPage;

  /// List of focus node items
  final List<FocusNode> focusNodeList;

  /// App bar title required to use appbar widget
  final String appBarTitle;

  /// App bar leading widget
  final Widget? leading;

  /// App bar trailing widget
  final Widget? trailing;

  /// App bar details
  final String? previousRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ANPCubit(),
      child: _OMDKAnimatedNavigationPage(
        withAppBar: withAppBar,
        withBottomBar: withBottomBar,
        navigationTree: navigationTree ?? [],
        childrenKey: childrenKey,
        bodyPage: bodyPage,
        focusNodeList: focusNodeList,
        appBarTitle: appBarTitle,
        withDrawer: withDrawer,
        leading: leading,
        trailing: trailing,
        previousRoute: previousRoute,
      ),
    );
  }
}

class _OMDKAnimatedNavigationPage extends StatelessWidget {
  _OMDKAnimatedNavigationPage({
    required this.navigationTree,
    required this.childrenKey,
    required this.focusNodeList,
    required this.bodyPage,
    required this.appBarTitle,
    required this.withDrawer,
    required this.withAppBar,
    required this.withBottomBar,
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
  final List<Map<String, dynamic>> navigationTree;
  final String childrenKey;
  final Widget bodyPage;
  final List<FocusNode> focusNodeList;
  final String? appBarTitle;
  final Widget? leading;
  final Widget? trailing;
  final String? previousRoute;

  @override
  Widget build(BuildContext context) {
    final cubit = context.select((ANPCubit cubit) => cubit.state);
    return Material(
      child: Stack(
        children: [
          const SafeArea(
            child: OMDKAnimatedDrawer(),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(cubit.xOffsetDrawer, 0, 0),
            duration: const Duration(milliseconds: 150),
            child: GestureDetector(
              onTap: () => context.read<ANPCubit>().collapseDrawer(),
              child: AbsorbPointer(
                absorbing: cubit.isDrawerExpanded,
                child: CupertinoPageScaffold(
                  navigationBar: withAppBar
                      ? CupertinoNavigationBar(
                          leading: withDrawer && !Navigator.of(context).canPop()
                              ? GestureDetector(
                                  child: const Icon(
                                    Icons.menu_outlined,
                                    size: 20,
                                  ),
                                  onTap: () =>
                                      context.read<ANPCubit>().expandDrawer(),
                                )
                              : leading,
                          middle: Text(appBarTitle!),
                          trailing: trailing,
                          previousPageTitle: previousRoute,
                          border: const Border(
                            bottom: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        )
                      : null,
                  child: SafeArea(
                    child: _buildPage(context),
                  ),
                ),
              ),
            ),
          ),
        ],
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

  Widget _buildBodyPage(BuildContext context) => CustomKeyboardActions(
        focusNodes: focusNodeList,
        child: (navigationTree.isNotEmpty)
            ? ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  title: Text(navigationTree[index]['title'] as String),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute<dynamic>(
                        builder: (context) => OMDKAnimatedNavigationPage(
                          withBottomBar: false,
                          bodyPage: bodyPage,
                          appBarTitle: navigationTree[index]['title'] as String,
                          navigationTree:
                              navigationTree[index].containsKey(childrenKey) &&
                                      (navigationTree[index][childrenKey]
                                              as List<dynamic>)
                                          .isNotEmpty
                                  ? navigationTree[index][childrenKey]
                                      as List<Map<String, dynamic>>
                                  : null,
                          childrenKey: childrenKey,
                          previousRoute:
                              navigationTree[index].containsKey('path')
                                  ? navigationTree[index]['path'] as String
                                  : 'Root',
                        ),
                      ),
                    );
                  },
                ),
                separatorBuilder: (context, index) => const OMDKDivider(),
                itemCount: navigationTree.length,
              )
            : const Center(
                child: Text('No children'),
              ),
      );
}
