part of 'field_image_bloc.dart';

@immutable
final class FieldImageState extends Equatable {
  const FieldImageState({
    this.loadingStatus = LoadingStatus.initial,
    this.attachment,
  });

  final LoadingStatus loadingStatus;
  final Uint8List? attachment;

  FieldImageState copyWith({
    LoadingStatus? loadingStatus,
    Uint8List? attachment,
  }) =>
      FieldImageState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        attachment: attachment ?? this.attachment,
      );

  @override
  List<Object?> get props => [loadingStatus, attachment];
}
