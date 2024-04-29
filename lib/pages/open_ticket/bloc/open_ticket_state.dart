part of 'open_ticket_bloc.dart';

@immutable
final class OpenTicketState extends Equatable {
  /// Create [OpenTicketState] instance
  const OpenTicketState({
    this.loadingStatus = LoadingStatus.initial,
    this.schemas = const [],
    this.jMainNode,
    this.ticketName = '',
    this.ticketDescription = '',
    this.ticketPriority = '',
    this.activeFieldBloc,
  });

  final LoadingStatus loadingStatus;
  final JMainNode? jMainNode;
  final List<SchemaListItem> schemas;
  final String ticketName;
  final String ticketDescription;
  final String ticketPriority;
  final SimpleTextBloc? activeFieldBloc;

  OpenTicketState copyWith({
    LoadingStatus? loadingStatus,
    List<SchemaListItem>? schemas,
    JMainNode? jMainNode,
    String? ticketName,
    String? ticketDescription,
    String? ticketPriority,
    SimpleTextBloc? activeFieldBloc,
  }) {
    return OpenTicketState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      schemas: schemas ?? this.schemas,
      jMainNode: jMainNode ?? this.jMainNode,
      ticketName: ticketName ?? this.ticketName,
      ticketDescription: ticketDescription ?? this.ticketDescription,
      ticketPriority: ticketPriority ?? this.ticketPriority,
      activeFieldBloc: activeFieldBloc ?? this.activeFieldBloc,
    );
  }

  @override
  List<Object?> get props => [
        loadingStatus,
        schemas,
        jMainNode,
        ticketName,
        ticketDescription,
        ticketPriority,
        activeFieldBloc,
      ];
}
