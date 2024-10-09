import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/blocs/auth/auth.dart';
import 'package:omdk_inspecta/blocs/sync/configs/configs_cubit.dart';
import 'package:omdk_inspecta/blocs/sync/theme/theme_cubit.dart';
import 'package:omdk_inspecta/common/assets/assets.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_local_data/omdk_local_data.dart';

class OMDKAnimatedDrawer extends StatelessWidget {
  /// Create [OMDKAnimatedDrawer] instance
  const OMDKAnimatedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 22,
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Align(child: _userDetails(context)),
            ),
          ),
          Expanded(
            flex: 70,
            child: ListView(
              children: [
                _menuVoice(context: context, title: 'Privacy Policy'),
                divider,
                _menuVoice(context: context, title: 'Settings'),
                divider,
                _menuVoice(
                  context: context,
                  title: 'Update themes',
                  onTap: () => context.read<ThemeCubit>().updateCustomThemes(),
                ),
                divider,
                switchTheme(context),
                divider,
                _menuVoice(
                  context: context,
                  title: 'Sign Out',
                  onTap: () => context.read<AuthBloc>().add(LogoutRequested()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget switchTheme(BuildContext context) {
    final currentTheme = context.watch<ThemeCubit>().state.themeEnum;
    return ListTile(
      title: Text(
        switch (currentTheme) {
          ThemeEnum.dark => 'Dark theme',
          ThemeEnum.light => 'Light theme',
          ThemeEnum.customDark => 'Dark theme',
          ThemeEnum.customLight => 'Light theme',
        },
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: Switch(
        value: switch (currentTheme) {
          ThemeEnum.dark => true,
          ThemeEnum.light => false,
          ThemeEnum.customDark => true,
          ThemeEnum.customLight => false,
        },
        onChanged: (b) => context.read<ThemeCubit>().switchTheme(
              context.read<ConfigsCubit>().state.currentCompany,
            ),
      ),
    );
  }

  Widget get divider => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: OMDKDivider(thickness: 1),
      );

  Widget _menuVoice({
    required BuildContext context,
    required String title,
    VoidCallback? onTap,
    IconAsset? iconAsset,
  }) =>
      ListTile(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
        leading: iconAsset != null
            ? Image.asset(
                iconAsset.iconAsset,
                height: 24,
                color: Colors.grey,
              )
            : null,
      );

  Widget _userDetails(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(IconAsset.userAsset.iconAsset),
                  foregroundColor: Colors.grey,
                  backgroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  minRadius: MediaQuery.of(context).size.width / 14,
                ),
                const Space.horizontal(14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.read<AuthBloc>().state.user.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                      Text(
                        context
                            .read<AuthBloc>()
                            .state
                            .user
                            .username
                            .toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Space.vertical(20),
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'COMPANY CODE:\n',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.normal,
                          ),
                      children: [
                        TextSpan(
                          text:
                              '${context.read<ConfigsCubit>().state.currentCompany}',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
