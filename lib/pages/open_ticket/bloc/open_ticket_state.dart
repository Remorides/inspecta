part of 'open_ticket_bloc.dart';

@immutable
final class OpenTicketState extends Equatable {
  /// Create [OpenTicketState] instance
  const OpenTicketState({
    this.loadingStatus = LoadingStatus.initial,
    this.schemas = const [],
    this.selectedSchemaIndex,
    this.schemaMapping,
    this.jMainNode,
    this.ticketName = '',
    this.ticketDescription = '',
    this.ticketPriority = '',
    this.activeFieldBloc,
  });

  final LoadingStatus loadingStatus;
  final JMainNode? jMainNode;
  final List<SchemaListItem> schemas;
  final MappingVersion? schemaMapping;
  final int? selectedSchemaIndex;
  final String ticketName;
  final String ticketDescription;
  final String ticketPriority;
  final SimpleTextBloc? activeFieldBloc;

  OpenTicketState copyWith({
    LoadingStatus? loadingStatus,
    List<SchemaListItem>? schemas,
    int? selectedSchemaIndex,
    MappingVersion? schemaMapping,
    JMainNode? jMainNode,
    String? ticketName,
    String? ticketDescription,
    String? ticketPriority,
    SimpleTextBloc? activeFieldBloc,
  }) {
    return OpenTicketState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      schemas: schemas ?? this.schemas,
      selectedSchemaIndex: selectedSchemaIndex ?? this.selectedSchemaIndex,
      schemaMapping: schemaMapping ?? this.schemaMapping,
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
        selectedSchemaIndex,
        schemaMapping,
        jMainNode,
        ticketName,
        ticketDescription,
        ticketPriority,
        activeFieldBloc,
      ];
}
