part of 'field_image_bloc.dart';

final class FieldImageState extends Equatable {
  const FieldImageState({
    this.loadingStatus = LoadingStatus.initial,
    this.fileList = const [],
    this.attachmentList = const [],
    this.notify = false,
  });

  final LoadingStatus loadingStatus;
  final List<File?> fileList;
  final List<Attachment?> attachmentList;
  final bool notify;

  FieldImageState copyWith({
    LoadingStatus? loadingStatus,
    List<File?>? fileList,
    List<Attachment?>? attachmentList,
    bool? notify,
  }) =>
      FieldImageState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        fileList: fileList ?? this.fileList,
        attachmentList: attachmentList ?? this.attachmentList,
        notify: notify ?? this.notify,
      );

  @override
  List<Object> get props => [
        loadingStatus,
        fileList,
        attachmentList,
        notify,
      ];
}
