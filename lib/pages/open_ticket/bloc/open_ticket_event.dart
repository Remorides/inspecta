part of 'open_ticket_bloc.dart';

@immutable
sealed class OpenTicketEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class Init extends OpenTicketEvent {
  Init({required this.guid});

  final String? guid;

  @override
  List<Object?> get props => [guid];
}


final class SubmitTicket extends OpenTicketEvent {}

final class SelectedSchemaChanged extends OpenTicketEvent {
  SelectedSchemaChanged({
    required this.schemaGuid,
    required this.schemaMappingGuid,
    this.schemaIndex,
  });

  final int? schemaIndex;
  final String schemaGuid;
  final String schemaMappingGuid;

  @override
  List<Object?> get props => [
        schemaIndex,
        schemaGuid,
        schemaMappingGuid,
      ];
}

final class TicketNameChanged extends OpenTicketEvent {
  TicketNameChanged(this.name);

  final String? name;

  @override
  List<Object?> get props => [name];
}

final class TicketEditing extends OpenTicketEvent {
  TicketEditing({
    required this.cubit,
  });

  final SimpleTextCubit cubit;

  @override
  List<Object?> get props => [cubit];
}

final class ResetWarning extends OpenTicketEvent {}

final class TicketDescChanged extends OpenTicketEvent {
  TicketDescChanged(this.desc);

  final String? desc;

  @override
  List<Object?> get props => [desc];
}

final class TicketPriorityChanged extends OpenTicketEvent {
  TicketPriorityChanged(this.priority);

  final int? priority;

  @override
  List<Object?> get props => [priority];
}

final class FieldChanged extends OpenTicketEvent {
  FieldChanged({
    required this.stepGuid,
    required this.fieldGuid,
    required this.fieldMapping,
    required this.fieldValue,
  });

  final String stepGuid;
  final String fieldGuid;
  final JFieldMapping fieldMapping;
  final dynamic fieldValue;

  @override
  List<Object?> get props => [
        stepGuid,
        fieldGuid,
        fieldMapping,
        fieldValue,
      ];
}
