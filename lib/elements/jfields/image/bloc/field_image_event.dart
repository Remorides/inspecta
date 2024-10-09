part of 'field_image_bloc.dart';

sealed class FieldImageEvent {}

final class LoadImages extends FieldImageEvent {
  LoadImages(this.imageGuidList);

  final List<String>? imageGuidList;
}

final class AddImage extends FieldImageEvent {
  AddImage(this.file);

  final File file;
}

class TakeCameraPhoto extends FieldImageEvent {}

class PickImage extends FieldImageEvent {}
