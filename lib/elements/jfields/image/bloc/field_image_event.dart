part of 'field_image_bloc.dart';

@immutable
sealed class FieldImageEvent {}

final class DownloadImage extends FieldImageEvent {
  DownloadImage(this.imageGuid);

  final String? imageGuid;
}
