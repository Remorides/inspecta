part of 'field_slider_images_bloc.dart';

@immutable
final class FieldSliderImagesState extends Equatable {
  const FieldSliderImagesState({
    this.loadingStatus = LoadingStatus.initial,
    this.imageList,
  });

  final LoadingStatus loadingStatus;
  final List<Uint8List>? imageList;

  FieldSliderImagesState copyWith({
    LoadingStatus? loadingStatus,
    List<Uint8List>? imageList,
  }) =>
      FieldSliderImagesState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        imageList: imageList ?? this.imageList,
      );

  @override
  List<Object?> get props => [loadingStatus, imageList];
}
