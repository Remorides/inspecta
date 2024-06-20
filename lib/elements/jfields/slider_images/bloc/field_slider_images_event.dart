part of 'field_slider_images_bloc.dart';

@immutable
sealed class FieldSliderImagesEvent {}

final class DownloadImages extends FieldSliderImagesEvent {
  DownloadImages(this.images);

  final List<String>? images;
}
