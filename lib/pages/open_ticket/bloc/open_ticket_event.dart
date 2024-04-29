part of 'open_ticket_bloc.dart';

@immutable
sealed class OpenTicketEvent extends Equatable {}

final class InitAssetReference extends OpenTicketEvent {
  InitAssetReference({required this.guid});

  final String? guid;

  @override
  List<Object?> get props => [guid];
}

final class InitSchemas extends OpenTicketEvent {
  InitSchemas();

  @override
  List<Object?> get props => [];
}

final class SelectedSchemaChanged extends OpenTicketEvent {
  SelectedSchemaChanged(this.schemaIndex);

  final int? schemaIndex;

  @override
  List<Object?> get props => [schemaIndex];
}

final class TicketNameChanged extends OpenTicketEvent {
  TicketNameChanged(this.name);

  final String? name;

  @override
  List<Object?> get props => [name];
}

final class TicketEditing extends OpenTicketEvent {
  TicketEditing({
    required this.bloc,
  });

  final SimpleTextBloc bloc;

  @override
  List<Object?> get props => [bloc];
}

final class TicketDescChanged extends OpenTicketEvent {
  TicketDescChanged(this.desc);

  final String? desc;

  @override
  List<Object?> get props => [desc];
}

final class TicketPriorityChanged extends OpenTicketEvent {
  TicketPriorityChanged(this.priority);

  final String? priority;

  @override
  List<Object?> get props => [priority];
}
