part of 'field_file_bloc.dart';

@immutable
final class FieldFileState extends Equatable {
  const FieldFileState({
    this.loadingStatus = LoadingStatus.initial,
    this.attachmentEntityList = const [],
    this.selectedAttachment,
    this.fileList = const [],
    this.errorText,
    this.isEnabled = true,
    this.notify = false,
  });

  final LoadingStatus loadingStatus;
  final List<Attachment?> attachmentEntityList;
  final Attachment? selectedAttachment;
  final List<File?> fileList;
  final String? errorText;
  final bool isEnabled;
  final bool notify;

  FieldFileState copyWith({
    LoadingStatus? loadingStatus,
    List<Attachment?>? attachmentEntityList,
    Attachment? selectedAttachment,
    List<File?>? fileList,
    String? errorText,
    bool? isEnabled,
    bool? notify,
  }) =>
      FieldFileState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        attachmentEntityList: attachmentEntityList ?? this.attachmentEntityList,
        fileList: fileList ?? this.fileList,
        selectedAttachment: selectedAttachment ?? this.selectedAttachment,
        errorText: errorText,
        isEnabled: isEnabled ?? this.isEnabled,
        notify: notify ?? this.notify,
      );

  @override
  List<Object?> get props => [
        attachmentEntityList,
        selectedAttachment,
        fileList,
        isEnabled,
        notify,
      ];
}
