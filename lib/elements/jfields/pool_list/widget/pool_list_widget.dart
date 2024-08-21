import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/enums/enums.dart';
import 'package:omdk_inspecta/elements/jfields/pool_list/cubit/pool_list_cubit.dart';
import 'package:omdk_repo/omdk_repo.dart';

class FieldPoolList extends StatelessWidget {
  /// Create [FieldPoolList] instance
  const FieldPoolList({
    required this.onChanged,
    required this.listItem,
    required this.labelText,
    super.key,
    this.cubit,
    this.selectedItem,
    this.isEnabled = true,
    this.focusNode,
  });

  final List<String> listItem;
  final String? selectedItem;
  final String labelText;
  final bool isEnabled;
  final PoolListCubit? cubit;
  final void Function(String?) onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          cubit ??
          PoolListCubit(
            isEnabled: isEnabled,
            listItem: listItem,
            selectedItem: selectedItem,
          ),
      child: _FieldPoolList(
        key: key,
        focusNode: focusNode,
        onChanged: onChanged,
        labelText: labelText,
      ),
    );
  }
}

class _FieldPoolList extends StatelessWidget {
  const _FieldPoolList({
    required this.onChanged,
    required this.labelText,
    super.key,
    this.focusNode,
  });

  final void Function(String?) onChanged;
  final FocusNode? focusNode;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    final state = context.select((PoolListCubit cubit) => cubit.state);
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
                    style: TextStyle(
                      color: context.theme?.colorScheme.onSurface,
                    ),
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
                      fillColor: context.theme?.colorScheme.background,
                      labelStyle: TextStyle(
                        color: context.theme?.colorScheme.onBackground,
                      ),
                    ),
                    items: state.listItem.map((map) {
                      return DropdownMenuItem(
                        value: map,
                        child: Text(
                          map,
                          style: TextStyle(
                              color: context.theme?.colorScheme.onBackground),
                        ),
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
      ),
    );
  }
}
