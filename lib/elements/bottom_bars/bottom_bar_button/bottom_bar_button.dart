import 'package:flutter/material.dart';
import 'package:omdk_inspecta/common/assets/assets.dart';

class OMDKBottomBarButton extends StatelessWidget {
  OMDKBottomBarButton({
    required this.assetImage,
    required this.onTap,
  });

  final VoidCallback onTap;
  final IconAsset assetImage;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      shape: CircleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(300),
        child: SizedBox.square(
          dimension: 40,
          child: Center(
            child: Image.asset(
              assetImage.iconAsset,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              width: 17,
              height: 17,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  static List<OMDKBottomBarButton> get defaultBottomButtons => [
        OMDKBottomBarButton(
          assetImage: IconAsset.searchButton,
          onTap: () => (),
        ),
        OMDKBottomBarButton(
          assetImage: IconAsset.qrcodeAsset,
          onTap: () => (),
        ),
        OMDKBottomBarButton(
          assetImage: IconAsset.nfcAsset,
          onTap: () => (),
        ),
        OMDKBottomBarButton(
          assetImage: IconAsset.helpAsset,
          onTap: () => (),
        ),
      ];
}
