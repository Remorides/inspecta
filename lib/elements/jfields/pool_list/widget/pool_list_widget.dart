import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_inspecta/elements/jfields/pool_list/cubit/pool_list_cubit.dart';

class FieldPoolList extends StatelessWidget {
  /// Create [FieldPoolList] instance
  const FieldPoolList({
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
    this.backgroundColor,
  });

  final List<String?> listItem;
  final String? selectedItem;
  final String? hintText;
  final String labelText;
  final bool isEnabled;
  final PoolListCubit? cubit;
  final void Function(String?) onChanged;
  final FocusNode? focusNode;
  final String? fieldNote;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return cubit != null
        ? BlocProvider.value(value: cubit!, child: _child)
        : BlocProvider(
            create: (_) => PoolListCubit(
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
        hintText: hintText,
        fieldNote: fieldNote,
        backgroundColor: backgroundColor,
      );
}

class _FieldPoolList extends StatelessWidget {
  const _FieldPoolList({
    required this.onChanged,
    required this.labelText,
    super.key,
    this.focusNode,
    this.hintText,
    this.fieldNote,
    this.backgroundColor,
  });

  final void Function(String?) onChanged;
  final FocusNode? focusNode;
  final String labelText;
  final String? hintText;
  final String? fieldNote;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final state = context.select((PoolListCubit cubit) => cubit.state);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                labelText.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
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
                      // enabledBorder: OutlineInputBorder(
                      //   //borderRadius: BorderRadius.circular(10),
                      //   borderSide: BorderSide(
                      //     color: backgroundColor ??
                      //         Theme.of(context).colorScheme.surface,
                      //   ),
                      // ),
                      // focusedBorder: OutlineInputBorder(
                      //   //borderRadius: BorderRadius.circular(10),
                      //   borderSide: BorderSide(
                      //     color: backgroundColor ??
                      //         Theme.of(context).colorScheme.surface,
                      //   ),
                      // ),
                      hintText: hintText,
                      filled: true,
                      // fillColor: backgroundColor ??
                      //     Theme.of(context).colorScheme.surface,
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
                      context.read<PoolListCubit>().changeSelected(s);
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
    );
  }
}
