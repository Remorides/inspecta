part of 'edit_ticket_bloc.dart';

@immutable
final class EditTicketState extends Equatable {
  /// Create [EditTicketState] instance
  const EditTicketState({
    this.loadingStatus = LoadingStatus.initial,
    this.ticketMapping,
    this.ticketEntity,
    this.activeFieldBloc,
    this.failureText,
  });

  final LoadingStatus loadingStatus;
  final MappingVersion? ticketMapping;
  final SimpleTextBloc? activeFieldBloc;
  final ScheduledActivity? ticketEntity;
  final String? failureText;

  EditTicketState copyWith(
      {LoadingStatus? loadingStatus,
      MappingVersion? ticketMapping,
      SimpleTextBloc? activeFieldBloc,
      ScheduledActivity? ticketEntity,
      String? failureText}) {
    return EditTicketState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      ticketMapping: ticketMapping ?? this.ticketMapping,
      activeFieldBloc: activeFieldBloc ?? this.activeFieldBloc,
      ticketEntity: ticketEntity ?? this.ticketEntity,
      failureText: failureText ?? this.failureText,
    );
  }

  @override
  List<Object?> get props => [
        loadingStatus,
        ticketMapping,
        activeFieldBloc,
        ticketEntity,
        failureText
      ];
}
