import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_inspecta/elements/elements.dart';

class OMDKCupertinoPicker extends StatelessWidget {
  /// Create [OMDKCupertinoPicker] instance
  const OMDKCupertinoPicker({
    super.key,
    this.isEnabled = true,
    this.mode = CupertinoDatePickerMode.dateAndTime,
    this.cubit,
    this.labelText,
    this.focusNode,
  });

  final bool isEnabled;
  final String? labelText;
  final CupertinoDatePickerMode mode;
  final DateTimeCupertinoCubit? cubit;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return cubit != null
        ? BlocProvider.value(value: cubit!, child: _child)
        : BlocProvider(
            create: (context) => DateTimeCupertinoCubit(isEnabled: isEnabled),
            child: _child,
          );
  }

  Widget get _child => _CupertinoPicker(
        mode: mode,
        labelText: labelText,
        key: key,
        focusNode: focusNode,
      );
}

class _CupertinoPicker extends StatefulWidget {
  const _CupertinoPicker({
    required this.mode,
    super.key,
    this.labelText,
    this.focusNode,
  });

  final String? labelText;
  final CupertinoDatePickerMode mode;
  final FocusNode? focusNode;

  @override
  State<_CupertinoPicker> createState() => _CupertinoPickerState();
}

class _CupertinoPickerState extends State<_CupertinoPicker> {
  DateTime date = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final state = context.select((DateTimeCupertinoCubit cubit) => cubit.state);
    return SizedBox(
      height: 100,
      child: Stack(
        children: <Widget>[
          if (widget.labelText != null)
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.labelText!.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).inputDecorationTheme.labelStyle,
                  ),
                ),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: 0.5,
                  child: AbsorbPointer(
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 24,
                        right: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 48,
                      child: Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(
                          top: widget.labelText != null ? 24 : 13,
                          left: 10,
                        ),
                        child: Text(
                          state.dateTime.toString(),
                          style: Theme.of(context)
                              .cupertinoOverrideTheme
                              ?.textTheme
                              ?.textStyle
                              .copyWith(
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 48,
                child: IconButton(
                  focusNode: widget.focusNode,
                  icon: const Icon(Icons.date_range),
                  onPressed: () {
                    _showDialog(context, widget.mode);
                  },
                ),
              ),
            ],
          ),
          if (state.status == LoadingStatus.failure)
            Positioned(
              bottom: 5,
              child: Text(
                state.errorText ?? '!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).inputDecorationTheme.errorStyle,
              ),
            ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, CupertinoDatePickerMode mode) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) {
        final size = MediaQuery.of(context).size;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          height: size.height * 0.27,
          child: CupertinoDatePicker(
            use24hFormat: true,
            mode: mode,
            onDateTimeChanged:
                context.read<DateTimeCupertinoCubit>().updateDate,
          ),
        );
      },
    );
  }
}
