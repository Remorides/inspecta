part of 'open_ticket_bloc.dart';

@immutable
final class OpenTicketState extends Equatable {
  /// Create [OpenTicketState] instance
  const OpenTicketState({
    this.loadingStatus = LoadingStatus.initial,
    this.schemas = const [],
    this.selectedSchemaIndex,
    this.schemaMapping,
    this.ticketSchema,
    this.jMainNode,
    this.ticketName = '',
    this.ticketDescription = '',
    this.ticketPriority = 0,
    this.activeFieldBloc,
    this.ticketEntity,
    this.failureText,
  });

  final LoadingStatus loadingStatus;
  final JMainNode? jMainNode;
  final List<SchemaListItem> schemas;

  final MappingVersion? schemaMapping;
  final OSchema? ticketSchema;

  final int? selectedSchemaIndex;
  final String ticketName;
  final String ticketDescription;
  final int? ticketPriority;
  final SimpleTextBloc? activeFieldBloc;
  final ScheduledActivity? ticketEntity;

  final String? failureText;

  OpenTicketState copyWith({
    LoadingStatus? loadingStatus,
    List<SchemaListItem>? schemas,
    int? selectedSchemaIndex,
    MappingVersion? schemaMapping,
    OSchema? ticketSchema,
    JMainNode? jMainNode,
    String? ticketName,
    String? ticketDescription,
    int? ticketPriority,
    SimpleTextBloc? activeFieldBloc,
    ScheduledActivity? ticketEntity,
    Widget? stepListWidget,
    String? failureText,
  }) {
    return OpenTicketState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      schemas: schemas ?? this.schemas,
      selectedSchemaIndex: selectedSchemaIndex ?? this.selectedSchemaIndex,
      schemaMapping: schemaMapping ?? this.schemaMapping,
      ticketSchema: ticketSchema ?? this.ticketSchema,
      jMainNode: jMainNode ?? this.jMainNode,
      ticketName: ticketName ?? this.ticketName,
      ticketDescription: ticketDescription ?? this.ticketDescription,
      ticketPriority: ticketPriority ?? this.ticketPriority,
      activeFieldBloc: activeFieldBloc ?? this.activeFieldBloc,
      ticketEntity: ticketEntity ?? this.ticketEntity,
      failureText: failureText ?? this.failureText,
    );
  }

  @override
  List<Object?> get props => [
        loadingStatus,
        schemas,
        selectedSchemaIndex,
        schemaMapping,
        ticketSchema,
        jMainNode,
        ticketName,
        ticketDescription,
        ticketPriority,
        activeFieldBloc,
        ticketEntity,
        failureText,
      ];
}
