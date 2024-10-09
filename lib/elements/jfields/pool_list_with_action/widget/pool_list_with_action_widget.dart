import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/enums/enums.dart';
import 'package:omdk_inspecta/elements/jfields/pool_list_with_action/pool_list_with_action.dart';

class FieldPoolListWithAction extends StatelessWidget {
  /// Create [FieldPoolListWithAction] instance
  const FieldPoolListWithAction({
    required this.onChanged,
    required this.listItem,
    required this.labelText,
    super.key,
    this.cubit,
    this.hintText,
    this.selectedItem,
    this.isEnabled = true,
    this.focusNode,
    this.fieldNote,
    this.isActionEnabled = true,
    this.onTapAction,
    this.actionIcon,
    this.dropdownIcon,
  });

  final List<String?> listItem;
  final String? selectedItem;
  final String labelText;
  final String? hintText;
  final bool isEnabled;
  final PoolListWithActionCubit? cubit;
  final void Function(String?) onChanged;
  final FocusNode? focusNode;
  final String? fieldNote;
  final bool isActionEnabled;
  final void Function()? onTapAction;
  final Icon? actionIcon;
  final Icon? dropdownIcon;

  @override
  Widget build(BuildContext context) {
    return cubit != null
        ? BlocProvider.value(
            value: cubit!,
            child: _child,
          )
        : BlocProvider(
            create: (_) => PoolListWithActionCubit(
              isEnabled: isEnabled,
              listItem: listItem,
              selectedItem: selectedItem,
            ),
            child: _child,
          );
  }

  Widget get _child => _FieldPoolList(
        key: key,
        focusNode: focusNode,
        onChanged: onChanged,
        labelText: labelText,
        fieldNote: fieldNote,
        onTapAction: onTapAction,
        isActionEnabled: isActionEnabled,
        actionIcon: actionIcon,
        dropdownIcon: dropdownIcon,
        hintText: hintText,
      );
}

class _FieldPoolList extends StatelessWidget {
  const _FieldPoolList({
    required this.onChanged,
    required this.labelText,
    required this.isActionEnabled,
    super.key,
    this.hintText,
    this.focusNode,
    this.fieldNote,
    this.onTapAction,
    this.actionIcon,
    this.dropdownIcon,
  });

  final void Function(String?) onChanged;
  final FocusNode? focusNode;
  final String labelText;
  final String? hintText;
  final String? fieldNote;
  final bool isActionEnabled;
  final void Function()? onTapAction;
  final Icon? actionIcon;
  final Icon? dropdownIcon;

  @override
  Widget build(BuildContext context) {
    final state =
        context.select((PoolListWithActionCubit cubit) => cubit.state);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  labelText.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
                      icon: dropdownIcon,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        hintText: hintText,
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.surface,
                      ),
                      items: state.listItem.map((map) {
                        return DropdownMenuItem(
                          value: map,
                          child: Text(map ?? ''),
                        );
                      }).toList(),
                      value: state.selectedItem,
                      isExpanded: true,
                      onChanged: (String? s) {
                        context
                            .read<PoolListWithActionCubit>()
                            .changeSelected(s);
                        onChanged(s);
                      },
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: !isActionEnabled ? 0.7 : 1,
                child: AbsorbPointer(
                  absorbing: !isActionEnabled,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 42,
                    width: 42,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: onTapAction,
                      child: actionIcon ??
                          Icon(
                            CupertinoIcons.add,
                            color: Theme.of(context).colorScheme.outline,
                          ),
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
