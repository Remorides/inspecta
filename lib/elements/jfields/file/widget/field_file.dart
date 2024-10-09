import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/enums/loading_status.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_inspecta/elements/jfields/file/file.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';

class FieldFile extends StatelessWidget {
  const FieldFile({
    required this.entityType,
    required this.entityGuid,
    required this.attachmentsGuid,
    required this.labelText,
    this.selectedAttachment,
    this.bloc,
    this.onThreeDots,
    this.isMultiFile = false,
    this.isEnabled = true,
    this.isThreeDotsEnabled = true,
    this.fieldNote,
    this.hintText,
    this.focusNode,
    this.onSelected,
    this.onFileAdded,
  });

  final String entityGuid;
  final List<String>? attachmentsGuid;
  final String? selectedAttachment;
  final JEntityType entityType;
  final String labelText;
  final FieldFileBloc? bloc;
  final VoidCallback? onThreeDots;
  final bool isMultiFile;
  final bool isEnabled;
  final bool isThreeDotsEnabled;
  final String? hintText;
  final String? fieldNote;
  final FocusNode? focusNode;
  final void Function(Attachment?)? onSelected;
  final void Function(Attachment?)? onFileAdded;

  @override
  Widget build(BuildContext context) {
    return bloc != null
        ? BlocProvider.value(
            value: bloc!,
            child: _child,
          )
        : BlocProvider(
            create: (_) => FieldFileBloc(
              entityType: entityType,
              entityGuid: entityGuid,
              isEnabled: isEnabled,
              assetRepo: context.read<EntityRepo<Asset>>(),
              nodeRepo: context.read<EntityRepo<Node>>(),
              scheduledRepo: context.read<EntityRepo<ScheduledActivity>>(),
              attachmentRepo: context.read<OperaAttachmentRepo>(),
              omdkLocalData: context.read<OMDKLocalData>(),
              operaUtils: context.read<OperaUtils>(),
            )..add(LoadData(attachmentsGuid, selectedAttachment)),
            child: _child,
          );
  }

  Widget get _child => _FieldFile(
        labelText: labelText,
        onThreeDots: onThreeDots,
        isMultiFile: isMultiFile,
        isThreeDotsEnabled: isThreeDotsEnabled,
        fieldNote: fieldNote,
        hintText: hintText,
        focusNode: focusNode,
        onSelected: onSelected,
        onFileAdded: onFileAdded,
      );
}

class _FieldFile extends StatelessWidget {
  const _FieldFile({
    required this.labelText,
    required this.isMultiFile,
    required this.isThreeDotsEnabled,
    this.onThreeDots,
    this.fieldNote,
    this.hintText,
    this.focusNode,
    this.onSelected,
    this.onFileAdded,
  });

  final String labelText;
  final VoidCallback? onThreeDots;
  final bool isMultiFile;
  final bool isThreeDotsEnabled;
  final String? fieldNote;
  final String? hintText;
  final FocusNode? focusNode;
  final void Function(Attachment?)? onSelected;
  final void Function(Attachment?)? onFileAdded;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FieldFileBloc, FieldFileState>(
      listener: (context, state) {
        if (state.notify) {
          onFileAdded?.call(state.attachmentEntityList.lastOrNull);
        }
      },
      builder: (context, state) => Padding(
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
                        icon: const Icon(CupertinoIcons.doc),
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: hintText,
                          filled: true,
                          fillColor:
                              Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                        items: state.attachmentEntityList.map((i) {
                          return DropdownMenuItem(
                            value: i,
                            child: Text(i?.attachment.fileName ?? ''),
                          );
                        }).toList(),
                        value: context
                            .watch<FieldFileBloc>()
                            .state
                            .selectedAttachment,
                        isExpanded: true,
                        onChanged: (a) {
                          context.read<FieldFileBloc>().add(ChangeSelected(a));
                          onSelected?.call(a);
                        },
                      ),
                    ),
                  ),
                ),
                if (isMultiFile || state.attachmentEntityList.isEmpty)
                  Opacity(
                    opacity: !state.isEnabled ? 0.7 : 1,
                    child: AbsorbPointer(
                      absorbing: !state.isEnabled,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 42,
                        width: 42,
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(8),
                          shadowColor:
                              Theme.of(context).dialogTheme.shadowColor,
                          child: Focus(
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: onThreeDots ??
                                    () => _openThreeDots(
                                          context: context,
                                          bloc: context.read<FieldFileBloc>(),
                                        ),
                                child: Icon(
                                  CupertinoIcons.add,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
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
            if (state.loadingStatus == LoadingStatus.failure)
              Positioned(
                bottom: 5,
                child: Text(
                  state.errorText!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).inputDecorationTheme.errorStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openThreeDots({
    required BuildContext context,
    required FieldFileBloc bloc,
  }) =>
      OMDKSimpleBottomSheet.show(
        context,
        OMDKSimpleBottomSheet(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Add file'),
                leading: const Icon(CupertinoIcons.add),
                onTap: () {
                  bloc.add(AddFile());
                  Navigator.pop(context);
                },
              ),
              const Space.vertical(30),
            ],
          ),
        ),
      );
}
