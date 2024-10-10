import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OMDKSimpleActionButton extends StatelessWidget {
  OMDKSimpleActionButton({this.onTapAddBTN});

  final VoidCallback? onTapAddBTN;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      onPressed: onTapAddBTN,
      shape: const CircleBorder(),
      child: Icon(
        CupertinoIcons.plus,
        size: 26,
      ),
    );
  }
}
