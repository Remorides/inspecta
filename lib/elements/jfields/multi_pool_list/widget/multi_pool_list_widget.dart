import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/elements/jfields/multi_pool_list/cubit/multi_pool_list_cubit.dart';
import 'package:omdk/elements/jfields/multi_pool_list/models/pool_item.dart';
import 'package:omdk_repo/omdk_repo.dart';

class FieldMultiPoolList extends StatelessWidget {
  const FieldMultiPoolList({
    required this.listItem,
    required this.labelText,
    required this.onSelected,
    this.focusNode,
    super.key,
    this.cubit,
    this.isEnabled = true,
    this.selectedItems,
  });

  final String labelText;
  final List<String> listItem;
  final List<String>? selectedItems;
  final bool isEnabled;
  final MultiPoolListCubit? cubit;
  final FocusNode? focusNode;
  final void Function(List<PoolItem?> selectedItems) onSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          cubit ??
          MultiPoolListCubit(
            isEnabled: isEnabled,
            listItem: listItem,
            selectedItems: selectedItems ?? [],
          ),
      child: _FieldMultiPoolList(
        labelText: labelText,
        focusNode: focusNode,
        onSelected: onSelected,
      ),
    );
  }
}

class _FieldMultiPoolList extends StatelessWidget {
  const _FieldMultiPoolList({
    required this.labelText,
    required this.onSelected,
    this.focusNode,
  });

  final String labelText;
  final FocusNode? focusNode;
  final void Function(List<PoolItem?> selectedItems) onSelected;

  @override
  Widget build(BuildContext context) {
    final state = context.select((MultiPoolListCubit cubit) => cubit.state);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  labelText.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.theme?.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          Opacity(
            opacity: !state.isEnabled ? 0.5 : 1,
            child: AbsorbPointer(
              absorbing: !state.isEnabled,
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme?.colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.only(top: 20),
                child: MultiSelectDialogField<PoolItem?>(
                  title: Text(
                    labelText,
                    style: TextStyle(
                      color: context.theme?.colorScheme.onBackground,
                    ),
                  ),
                  buttonIcon: const Icon(
                    Icons.expand_more_outlined,
                  ),
                  buttonText: Text(
                    'Selected fields:',
                    style:  TextStyle(
                      color: context.theme?.colorScheme.onBackground,
                    ),
                  ),
                  selectedColor: context.theme?.primaryColor,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
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
                    chipColor: context.theme?.primaryColor,
                    textStyle: TextStyle(
                      color: context.theme?.colorScheme.onBackground,
                    ),
                  ),
                  onConfirm: onSelected,
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
                style: TextStyle(
                  color: context.theme?.colorScheme.onError,
                ),
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
