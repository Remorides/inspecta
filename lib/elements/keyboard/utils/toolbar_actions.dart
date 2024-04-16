import 'package:flutter/material.dart';

List<Widget Function(FocusNode)>? toolbarActions() {
  return <Widget Function(FocusNode)>[
    (FocusNode node) {
      return GestureDetector(
        onTap: () {
          return node.unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const Text(
            'Done',
          ),
        ),
      );
    },
  ];
}
