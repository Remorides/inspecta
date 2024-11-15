import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/buttons/buttons.dart';

class OMDKElevatedButton extends StatelessWidget {
  /// Create [OMDKElevatedButton] instance
  const OMDKElevatedButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.cubit,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.enabled = true,
    this.autofocus = true,
    this.focusNode,
  });

  final ElevatedButtonCubit? cubit;
  final void Function() onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final bool autofocus;
  final bool enabled;
  final Widget child;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return cubit != null
        ? BlocProvider.value(value: cubit!, child: _child)
        : BlocProvider(
            create: (_) => ElevatedButtonCubit(enabled: enabled),
            child: _child,
          );
  }

  Widget get _child => _OMDKElevatedButton(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        autofocus: autofocus,
        focusNode: focusNode,
        child: child,
      );
}

class _OMDKElevatedButton extends StatelessWidget {
  const _OMDKElevatedButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.autofocus = false,
    this.focusNode,
  });

  final void Function() onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final bool autofocus;
  final Widget child;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final state = context.select((ElevatedButtonCubit cubit) => cubit.state);
    return ElevatedButton(
      key: key,
      onPressed: state.enabled ? onPressed : null,
      onLongPress: state.enabled ? onLongPress : null,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: state.enabled
          ? style ?? Theme.of(context).elevatedButtonTheme.style
          : Theme.of(context).elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).disabledColor.withOpacity(0.8),
                ),
              ),
      autofocus: autofocus,
      focusNode: focusNode,
      child: child,
    );
  }
}
