import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/buttons/buttons.dart';

/// OMDK widget to add possibility to tap
/// over text to invoke function
class OMDKTextButton extends StatelessWidget {
  /// Create [OMDKTextButton] instance
  const OMDKTextButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.cubit,
    this.style,
    this.enabled = true,
  });

  /// Custom cubit to manage [OMDKTextButton] state
  final ClickableTextCubit? cubit;

  /// Function to invoke on button click
  final void Function() onPressed;

  /// Text string
  final String text;

  /// Set custom text style
  final TextStyle? style;

  /// Enable or not tap
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return cubit != null
        ? BlocProvider.value(value: cubit!, child: _child)
        : BlocProvider(
            create: (_) => ClickableTextCubit(enabled: enabled),
            child: _child,
          );
  }

  Widget get _child => _OMDKTextButton(
        key: key,
        onPressed: onPressed,
        text: text,
        style: style,
      );
}

class _OMDKTextButton extends StatelessWidget {
  const _OMDKTextButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.style,
  });

  final void Function() onPressed;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final state = context.select((ClickableTextCubit cubit) => cubit.state);
    return RichText(
      text: TextSpan(
        text: text,
        style: state.enabled
            ? style
            : Theme.of(context).inputDecorationTheme.labelStyle?.copyWith(
                  color: Theme.of(context).disabledColor.withOpacity(0.8),
                ),
        recognizer: TapGestureRecognizer()
          ..onTap = (state.enabled) ? onPressed : null,
      ),
    );
  }
}
