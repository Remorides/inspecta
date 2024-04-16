import 'package:flutter/material.dart';

/// Keyboard utils
class KeyboardUtils {
  /// List of additional actions to extend keyboard behaviour
  static List<Widget Function(FocusNode)>? toolbarActions({
    String? closeKeyboard,
  }) {
    return <Widget Function(FocusNode)>[
      (FocusNode node) {
        return GestureDetector(
          onTap: () {
            return node.unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              closeKeyboard ?? 'Done',
            ),
          ),
        );
      },
    ];
  }
}
