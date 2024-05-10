import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/common/utils/utils.dart';
import 'package:omdk/elements/jfields/final_state/cubit/final_state_cubit.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_entity/opera_api_entity.dart';

class FieldFinalState extends StatelessWidget {
  /// Create [FieldFinalState] instance
  const FieldFinalState({
    required this.onChanged,
    required this.listItem,
    required this.labelText,
    super.key,
    this.cubit,
    this.selectedItem,
    this.isEnabled = true,
    this.focusNode,
  });

  final List<JResultState> listItem;
  final JResultState? selectedItem;
  final String labelText;
  final bool isEnabled;
  final FinalStateCubit? cubit;
  final void Function(JResultState?) onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          cubit ??
          FinalStateCubit(
            isEnabled: isEnabled,
            listItem: listItem,
            selectedItem: selectedItem,
          ),
      child: _FieldFinalState(
        key: key,
        focusNode: focusNode,
        onChanged: onChanged,
        labelText: labelText,
      ),
    );
  }
}

class _FieldFinalState extends StatelessWidget {
  const _FieldFinalState({
    required this.onChanged,
    required this.labelText,
    super.key,
    this.focusNode,
  });

  final void Function(JResultState?) onChanged;
  final FocusNode? focusNode;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    final state = context.select((FinalStateCubit cubit) => cubit.state);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    labelText.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme?.inputDecorationTheme.labelStyle,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Opacity(
                opacity: !state.isEnabled ? 0.5 : 1,
                child: AbsorbPointer(
                  absorbing: !state.isEnabled,
                  child: DropdownButtonFormField(
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: labelText,
                      filled: true,
                      fillColor: Colors.white,
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
                                text: '${(jResultState.title?.singleWhereOrNull(
                                      (element) =>
                                          element.culture?.contains(
                                            Localizations.localeOf(context)
                                                .languageCode,
                                          ) ??
                                          false,
                                    ) ?? jResultState.title?[0])?.value}',
                                style: TextStyle(
                                  color: (jResultState.textColor != null)
                                      ? HexColor(jResultState.textColor!)
                                      : context.theme?.inputDecorationTheme
                                          .labelStyle?.color,
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
            if (state.status == LoadingStatus.failure)
              Positioned(
                bottom: 5,
                child: Text(
                  state.errorText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme?.inputDecorationTheme.errorStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
