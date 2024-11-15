import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_inspecta/elements/jfields/final_state/cubit/final_state_cubit.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';

class FieldFinalState extends StatelessWidget {
  /// Create [FieldFinalState] instance
  const FieldFinalState({
    required this.onChanged,
    required this.listItem,
    required this.labelText,
    required this.hintText,
    super.key,
    this.cubit,
    this.selectedItem,
    this.isEnabled = true,
    this.focusNode,
    this.fieldNote,
    this.fillColor,
  });

  final List<JResultState> listItem;
  final JResultState? selectedItem;
  final String labelText;
  final String hintText;
  final bool isEnabled;
  final FinalStateCubit? cubit;
  final void Function(JResultState?) onChanged;
  final FocusNode? focusNode;
  final String? fieldNote;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return cubit != null
        ? BlocProvider.value(value: cubit!, child: _child)
        : BlocProvider(
            create: (_) => FinalStateCubit(
              isEnabled: isEnabled,
              listItem: listItem,
              selectedItem: selectedItem,
            ),
            child: _child,
          );
  }

  Widget get _child => _FieldFinalState(
        key: key,
        focusNode: focusNode,
        onChanged: onChanged,
        labelText: labelText,
        hintText: hintText,
        fieldNote: fieldNote,
        fillColor: fillColor,
      );
}

class _FieldFinalState extends StatelessWidget {
  const _FieldFinalState({
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    super.key,
    this.focusNode,
    this.fieldNote,
    this.fillColor,
  });

  final void Function(JResultState?) onChanged;
  final FocusNode? focusNode;
  final String labelText;
  final String hintText;
  final String? fieldNote;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final state = context.select((FinalStateCubit cubit) => cubit.state);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  labelText.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: !state.isEnabled ? 0.5 : 1,
                  child: AbsorbPointer(
                    absorbing: !state.isEnabled,
                    child: DropdownButtonFormField(
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: hintText,
                        filled: true,
                        fillColor: fillColor ??
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      items: state.listItem.map((jResultState) {
                        return DropdownMenuItem(
                          value: jResultState,
                          child: RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                if (jResultState.image != null)
                                  WidgetSpan(
                                    child: Image.memory(
                                      base64Decode(
                                        jResultState.image!.content!
                                            .split(',')
                                            .last,
                                      ),
                                    ),
                                  ),
                                TextSpan(
                                  text:
                                      '${context.localizeLabel(jResultState.title)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: (jResultState.textColor != null)
                                            ? HexColor(jResultState.textColor!)
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      value: state.selectedItem,
                      isExpanded: true,
                      onChanged: (JResultState? s) {
                        context.read<FinalStateCubit>().changeSelected(s);
                        onChanged(s);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (fieldNote != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$fieldNote',
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          if (state.status == LoadingStatus.failure)
            Positioned(
              bottom: 5,
              child: Text(
                state.errorText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).inputDecorationTheme.errorStyle,
              ),
            ),
        ],
      ),
    );
  }
}
