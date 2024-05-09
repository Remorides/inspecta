part of 'edit_ticket_bloc.dart';

@immutable
final class EditTicketState extends Equatable {
  /// Create [EditTicketState] instance
  const EditTicketState({
    this.loadingStatus = LoadingStatus.initial,
    this.ticketMapping,
    this.ticketEntity,
    this.ticketName,
    this.ticketDescription,
    this.activeFieldBloc,
    this.failureText,
  });

  final LoadingStatus loadingStatus;
  final MappingVersion? ticketMapping;
  final String? ticketName;
  final String? ticketDescription;
  final SimpleTextBloc? activeFieldBloc;
  final ScheduledActivity? ticketEntity;
  final String? failureText;

  EditTicketState copyWith({
    LoadingStatus? loadingStatus,
    MappingVersion? ticketMapping,
    String? ticketName,
    String? ticketDescription,
    SimpleTextBloc? activeFieldBloc,
    ScheduledActivity? ticketEntity,
    String? failureText,
  }) {
    return EditTicketState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      ticketName: ticketName ?? this.ticketName,
      ticketMapping: ticketMapping ?? this.ticketMapping,
      ticketDescription: ticketDescription ?? this.ticketDescription,
      activeFieldBloc: activeFieldBloc ?? this.activeFieldBloc,
      ticketEntity: ticketEntity ?? this.ticketEntity,
      failureText: failureText ?? this.failureText,
    );
  }

  @override
  List<Object?> get props => [
        loadingStatus,
        ticketName,
        ticketMapping,
        ticketDescription,
        activeFieldBloc,
        ticketEntity,
        failureText,
      ];
}
