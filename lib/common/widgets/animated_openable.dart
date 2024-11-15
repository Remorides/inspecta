import 'package:flutter/material.dart';
import 'package:omdk_inspecta/common/assets/assets.dart';
import 'package:omdk_inspecta/elements/elements.dart';

Widget animatedOpenable({
  required BuildContext context,
  required VoidCallback? onTap,
  required String leadingIconPath,
  required String title,
  required String? trailing,
}) =>
    ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18,
            right: 14,
            top: 10,
            bottom: 10,
          ),
          child: Row(
            children: <Widget>[
              Image.asset(
                leadingIconPath,
                width: 25,
                height: 25,
                fit: BoxFit.contain,
                color: Theme.of(context).colorScheme.primary,
              ),
              const Space.horizontal(12),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                  ),
                ),
              ),
              if (trailing != null) const Space.horizontal(12),
              if (trailing != null)
                Text(
                  trailing,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                  ),
                ),
              if (trailing != null) const Space.horizontal(6),
              Center(
                child: Image.asset(
                  IconAsset.arrowNextAsset.iconAsset,
                  width: 10,
                  height: 10,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );