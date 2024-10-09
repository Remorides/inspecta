part of 'field_file_bloc.dart';

@immutable
sealed class FieldFileEvent {}

final class LoadData extends FieldFileEvent {
  LoadData(this.guids, [this.selected]);

  final List<String>? guids;
  final String? selected;
}

final class Enable extends FieldFileEvent {}

final class Disable extends FieldFileEvent {}

final class AddFile extends FieldFileEvent {}

final class ChangeSelected extends FieldFileEvent {
  ChangeSelected(this.attachment);

  final Attachment? attachment;
}
