import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FieldImage extends StatelessWidget {
  const FieldImage({
    required this.entityType,
    required this.entityGuid,
    required this.labelText,
    this.bloc,
    this.imageGuidList = const [],
    this.isMultiImages = false,
    this.fieldNote,
    this.onImageAdded,
  });

  final String entityGuid;
  final JEntityType entityType;
  final String labelText;
  final FieldImageBloc? bloc;
  final List<String>? imageGuidList;
  final bool isMultiImages;
  final String? fieldNote;
  final void Function(Attachment?)? onImageAdded;

  @override
  Widget build(BuildContext context) {
    return bloc != null
        ? BlocProvider.value(value: bloc!, child: _child)
        : BlocProvider(
            create: (context) => FieldImageBloc(
              entityType: entityType,
              entityGuid: entityGuid,
              assetRepo: context.read<EntityRepo<Asset>>(),
              nodeRepo: context.read<EntityRepo<Node>>(),
              scheduledRepo: context.read<EntityRepo<ScheduledActivity>>(),
              attachmentRepo: context.read<OperaAttachmentRepo>(),
              omdkLocalData: context.read<OMDKLocalData>(),
              operaUtils: context.read<OperaUtils>(),
            )..add(LoadImages(imageGuidList)),
            child: _child,
          );
  }

  Widget get _child => _FieldImage(
        labelText: labelText,
        fieldNote: fieldNote,
        onImageAdded: onImageAdded,
      );
}

class _FieldImage extends StatefulWidget {
  const _FieldImage({
    required this.labelText,
    this.fieldNote,
    this.onImageAdded,
  });

  final String labelText;
  final String? fieldNote;
  final void Function(Attachment?)? onImageAdded;

  @override
  State<_FieldImage> createState() => _FieldImageState();
}

class _FieldImageState extends State<_FieldImage> {
  final _smoothController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FieldImageBloc, FieldImageState>(
      listener: (context, state) {
        if (state.notify) {
          widget.onImageAdded?.call(state.attachmentList.lastOrNull);
        }
      },
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.labelText.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: switch (state.loadingStatus) {
                    LoadingStatus.initial =>
                      const Center(child: CircularProgressIndicator()),
                    LoadingStatus.inProgress =>
                      const Center(child: CircularProgressIndicator()),
                    LoadingStatus.updated => throw UnimplementedError(),
                    LoadingStatus.failure => throw UnimplementedError(),
                    LoadingStatus.fatal => throw UnimplementedError(),
                    LoadingStatus.done => PageView.builder(
                        itemCount: state.fileList.length,
                        controller: _smoothController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, itemIndex) => Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                state.fileList[itemIndex]!,
                                fit: BoxFit.cover,
                                cacheHeight: 250,
                                cacheWidth: 390,
                                errorBuilder: (context, o, s) => Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Center(
                                    child: Image.asset(
                                      IconAsset.iconFileImageAsset.iconAsset,
                                      height: 250,
                                      width: 390,
                                      fit: BoxFit.contain,
                                      color: Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  },
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    child: InkWell(
                      onTap: () => _openThreeDots(
                        state: state,
                        bloc: context.read<FieldImageBloc>(),
                      ),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.ellipsis_vertical,
                            size: 25,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (state.fileList.length > 1)
                  Positioned(
                    bottom: 22,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _smoothController,
                        count: state.fileList.length,
                        effect: WormEffect(
                          activeDotColor: Theme.of(context).colorScheme.primary,
                          dotColor: Theme.of(context).colorScheme.surface,
                          dotHeight: 7,
                          dotWidth: 7,
                          spacing: 7,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (widget.fieldNote != null) _notes,
          ],
        ),
      ),
    );
  }

  Widget get _notes => Row(
        children: [
          Expanded(
            child: Text(
              '${widget.fieldNote}',
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      );

  void _openThreeDots({
    required FieldImageState state,
    required FieldImageBloc bloc,
  }) =>
      OMDKSimpleBottomSheet.show(
        context,
        OMDKSimpleBottomSheet(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Add image from camera'),
                leading: const Icon(CupertinoIcons.add),
                onTap: () {
                  bloc.add(TakeCameraPhoto());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Add image from gallery'),
                leading: const Icon(CupertinoIcons.add),
                onTap: () {
                  bloc.add(PickImage());
                  Navigator.pop(context);
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(),
              ),
              ListTile(
                title: const Text('Modify'),
                leading: const Icon(CupertinoIcons.pencil),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Replace'),
                leading: const Icon(CupertinoIcons.arrow_2_squarepath),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Space.vertical(30),
            ],
          ),
        ),
      );
}
