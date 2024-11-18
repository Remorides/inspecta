part of 'edit_ticket_bloc.dart';

@immutable
sealed class EditTicketEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CheckStateTicket extends EditTicketEvent {
  CheckStateTicket({required this.guid});

  final String? guid;

  @override
  List<Object?> get props => [guid];
}

final class ExecuteTicket extends EditTicketEvent {
  ExecuteTicket({required this.guid});

  final String guid;

  @override
  List<Object> get props => [guid];
}

final class InitTicket extends EditTicketEvent {
  InitTicket({required this.guid});

  final String? guid;

  @override
  List<Object?> get props => [guid];
}

final class ResetWarning extends EditTicketEvent {}

final class TicketNameChanged extends EditTicketEvent {
  TicketNameChanged(this.name);

  final String? name;

  @override
  List<Object?> get props => [name];
}

final class TicketDescChanged extends EditTicketEvent {
  TicketDescChanged(this.desc);

  final String? desc;

  @override
  List<Object?> get props => [desc];
}

final class TicketEditing extends EditTicketEvent {
  TicketEditing({
    required this.bloc,
  });

  final SimpleTextCubit bloc;

  @override
  List<Object?> get props => [bloc];
}

final class TicketPriorityChanged extends EditTicketEvent {
  TicketPriorityChanged(this.priority);

  final int? priority;

  @override
  List<Object?> get props => [priority];
}

final class SubmitTicket extends EditTicketEvent {}

final class FieldChanged extends EditTicketEvent {
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
