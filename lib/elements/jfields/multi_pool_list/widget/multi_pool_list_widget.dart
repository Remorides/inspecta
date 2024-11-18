import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:omdk_inspecta/common/enums/enums.dart';
import 'package:omdk_inspecta/elements/elements.dart';

class FieldMultiPoolList extends StatelessWidget {
  const FieldMultiPoolList({
    required this.listItem,
    required this.labelText,
    this.focusNode,
    required this.onSelected,
    super.key,
    this.cubit,
    this.isEnabled = true,
    this.selectedItems,
    this.fieldNote,
  });

  final String labelText;
  final List<String> listItem;
  final List<String>? selectedItems;
  final bool isEnabled;
  final MultiPoolListCubit? cubit;
  final FocusNode? focusNode;
  final void Function(List<PoolItem?> selectedItems) onSelected;
  final String? fieldNote;

  @override
  Widget build(BuildContext context) {
    return cubit != null
        ? BlocProvider.value(value: cubit!, child: _child)
        : BlocProvider(
            create: (_) => MultiPoolListCubit(
              isEnabled: isEnabled,
              listItem: listItem,
              selectedItems: selectedItems ?? [],
            ),
            child: _child,
          );
  }

  Widget get _child => _FieldMultiPoolList(
        labelText: labelText,
        focusNode: focusNode,
        onSelected: onSelected,
        fieldNote: fieldNote,
      );
}

class _FieldMultiPoolList extends StatelessWidget {
  const _FieldMultiPoolList({
    required this.labelText,
    this.focusNode,
    required this.onSelected,
    this.fieldNote,
  });

  final String labelText;
  final FocusNode? focusNode;
  final void Function(List<PoolItem?> selectedItems) onSelected;
  final String? fieldNote;

  @override
  Widget build(BuildContext context) {
    final state = context.select((MultiPoolListCubit cubit) => cubit.state);
    return Container(
      margin: const EdgeInsets.only(top: 20),
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
          const Space.vertical(3),
          Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: !state.isEnabled ? 0.5 : 1,
                  child: AbsorbPointer(
                    absorbing: !state.isEnabled,
                    child: MultiSelectDialogField<PoolItem?>(
                      buttonIcon: const Icon(
                        Icons.expand_more_outlined,
                      ),
                      buttonText: Text(
                        'Selected fields:',
                        style:
                            Theme.of(context).inputDecorationTheme.labelStyle,
                      ),
                      selectedColor: Theme.of(context).colorScheme.primary,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      items: selectableOptions(state.listItem)
                          .map(
                            (PoolItem? poolItem) => MultiSelectItem<PoolItem?>(
                              poolItem,
                              poolItem!.value,
                            ),
                          )
                          .toList(),
                      initialValue: defaultSelectedOptions(state.selectedItems),
                      chipDisplay: MultiSelectChipDisplay<PoolItem?>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        chipColor: Theme.of(context).colorScheme.primary,
                        textStyle: Theme.of(context)
                            .inputDecorationTheme
                            .labelStyle
                            ?.copyWith(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                            ),
                      ),
                      onConfirm: onSelected,
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

  List<PoolItem> selectableOptions(List<String> inputItems) {
    final outputList = <PoolItem>[];
    for (final s in inputItems) {
      outputList.add(PoolItem(displayText: s, value: s));
    }
    return outputList;
  }

  List<PoolItem> defaultSelectedOptions(List<String>? initialValues) {
    final outputList = <PoolItem>[];
    if (initialValues != null) {
      for (final s in initialValues) {
        outputList.add(PoolItem(displayText: s, value: s));
      }
    }
    return outputList;
  }
}
