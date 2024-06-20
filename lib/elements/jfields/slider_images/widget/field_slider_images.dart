import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/elements/jfields/slider_images/bloc/field_slider_images_bloc.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Generic input text field
class FieldSliderImages extends StatelessWidget {
  /// Create [FieldSliderImages] instance
  const FieldSliderImages({
    required this.labelText,
    super.key,
    this.imageList,
    this.maxWidth = 150,
    this.maxHeight = 150,
  });

  /// Label text
  final String labelText;
  final List<String>? imageList;
  final double maxWidth;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldSliderImagesBloc(context.read<AttachmentRepo>())
        ..add(DownloadImages(imageList)),
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
    return BlocBuilder<FieldSliderImagesBloc, FieldSliderImagesState>(
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (state.loadingStatus == LoadingStatus.done)
                      for(final image in state.imageList!)
                        Image.memory(
                          image,
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
