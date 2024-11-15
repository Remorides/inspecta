import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/blocs/mode/mode.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_repo/omdk_repo.dart';

class OMDKLogoSliverAppBar extends StatelessWidget {
  /// Create [OMDKLogoSliverAppBar] instance
  const OMDKLogoSliverAppBar({
    this.withLeading = true,
    this.leadingCallback,
    super.key,
    this.leadingIcon,
    this.customLogoPath,
    this.collapsedSize = 88,
    this.expandedSize = 180,
  });

  final bool withLeading;
  final IconAsset? leadingIcon;
  final VoidCallback? leadingCallback;
  final double collapsedSize;
  final double expandedSize;
  final String? customLogoPath;

  @override
  Widget build(BuildContext context) {
    return OMDKAnimatedAppBar(
      leading: withLeading
          ? IconButton(
              padding: const EdgeInsets.only(left: 20),
              enableFeedback: false,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: leadingCallback,
              icon: Image.asset(
                leadingIcon?.iconAsset ?? IconAsset.menu.iconAsset,
                color: Theme.of(context).colorScheme.outline,
                fit: BoxFit.contain,
                width: 22,
                height: 22,
              ),
            )
          : null,
      actions: [_offlineMode(context)],
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context, open) => Material(
        type: MaterialType.transparency,
        elevation: 6,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 1,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60 * (open + 0.01)),
                ),
                child: _appBarLogo(
                  context,
                  open,
                  customLogoPath: customLogoPath,
                ),
              ),
            ),
            if (open > 0.35)
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: _connectionDetails(context),
              ),
          ],
        ),
      ),
      collapsedSize: collapsedSize,
      expandedSize: expandedSize,
    );
  }

  Widget? _appBarLogo(
    BuildContext context,
    double open, {
    String? customLogoPath,
  }) {
    if (customLogoPath != null && File(customLogoPath).existsSync()) {
      return Image.file(
        File(customLogoPath),
        height: open.mapToRange(40, 90),
        fit: BoxFit.contain,
        color: Theme.of(context).colorScheme.onSurface,
      );
    }
    return Image.asset(CompanyAssets.operaLogo.iconAsset);
  }

  Row _connectionDetails(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          context.isConnected ? '🟢 Internet' : '⚠️ Connection not found',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Space.horizontal(20),
        Text(
          context.watch<SessionModeCubit>().state == SessionMode.online
              ? '🟢 Online'
              : '🔴 Offline',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _offlineMode(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Switch(
          value: context.watch<SessionModeCubit>().state == SessionMode.offline,
          onChanged: (b) => context.read<SessionModeCubit>().switchMode(),
          trackColor: Theme.of(context).switchTheme.trackColor,
          thumbColor: Theme.of(context).switchTheme.thumbColor,
        ),
      );
}
