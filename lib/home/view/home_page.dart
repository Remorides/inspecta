import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_repo/omdk_repo.dart';
import '../../auth/bloc/auth_bloc.dart';

/// Example home page
class HomePage extends StatelessWidget {
  /// Create [HomePage] instance
  const HomePage({super.key});

  /// Define navigation route
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Flutter Theme',
          style: context.theme?.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
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
              child: context.read<ThemeRepo>().currentThemeEnum ==
                  ThemeEnum.light
                  ? const Icon(Icons.light_mode_outlined)
                  : const Icon(Icons.dark_mode_outlined),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(
              builder: (context) {
                final userId = context.select(
                  (AuthBloc bloc) => bloc.state.user.id,
                );
                return Text('UserID: $userId');
              },
            ),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}
