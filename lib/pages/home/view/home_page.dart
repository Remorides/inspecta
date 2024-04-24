import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk/pages/home/home.dart';

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
    return const OMDKAnimatedPage(
      appBarTitle: 'Home Page',
        bodyPage: Center(
          child: Text('INSPECTA'),
        ),
    );
  }
}
