import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/pages/asset_api/asset_api.dart';
import 'package:omdk/pages/asset_download/asset_download.dart';
import 'package:omdk/pages/asset_isar/asset_isar.dart';
import 'package:omdk/pages/asset_rt_isar/asset_rt_isar.dart';
import 'package:omdk/pages/auth/auth.dart';
import 'package:omdk/pages/home/home.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Example home page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Define navigation route
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  /// Create [HomeView] instance
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Assets',
          style: context.theme?.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
              child: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () async => Future.delayed(
                const Duration(milliseconds: 200),
                () => context.read<ThemeRepo>().changeTheme(
                      context.read<ThemeRepo>().currentThemeEnum ==
                              ThemeEnum.light
                          ? ThemeEnum.dark
                          : ThemeEnum.light,
                    ),
              ),
              child:
                  context.read<ThemeRepo>().currentThemeEnum == ThemeEnum.light
                      ? const Icon(Icons.light_mode_outlined)
                      : const Icon(Icons.dark_mode_outlined),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedTab.index,
        children: const [
          AssetListIsarPage(),
          AssetRTListIsarPage(),
          AssetListApiPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key('homeView_addAsset_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(AssetDownloadForm.route()),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.localAsset,
              icon: const Icon(Icons.looks_one_outlined),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.rtLocalAsset,
              icon: const Icon(Icons.looks_two_outlined),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.apiAsset,
              icon: const Icon(Icons.three_g_mobiledata),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color:
          groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}
