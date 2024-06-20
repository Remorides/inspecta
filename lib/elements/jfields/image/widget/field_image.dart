import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/elements/jfields/image/image.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Generic input text field
class FieldImage extends StatelessWidget {
  /// Create [FieldImage] instance
  const FieldImage({
    required this.labelText,
    super.key,
    this.imageGuid,
    this.maxWidth = 150,
    this.maxHeight = 150,
  });

  /// Label text
  final String labelText;
  final String? imageGuid;
  final double maxWidth;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldImageBloc(context.read<AttachmentRepo>())
        ..add(DownloadImage(imageGuid)),
      child: _FieldImage(
          labelText: labelText,
        width: maxWidth,
        height: maxHeight,
      ),
    );
  }
}

class _FieldImage extends StatelessWidget {
  const _FieldImage({
    required this.labelText,
    required this.width,
    required this.height,
  });

  final String labelText;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldImageBloc, FieldImageState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      labelText.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.theme?.textTheme.labelLarge?.copyWith(
                        color: context.theme?.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (state.loadingStatus == LoadingStatus.done)
                    Image.memory(
                      state.attachment!,
                      width: width,
                      height: height,
                      fit: BoxFit.contain,
                    )
                  else
                    Container(
                      width: width,
                      height: height,
                      color: context.theme?.colorScheme.background,
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
