part of 'edit_ticket_bloc.dart';

@immutable
final class EditTicketState extends Equatable {
  /// Create [EditTicketState] instance
  const EditTicketState({
    this.loadingStatus = LoadingStatus.initial,
    this.ticketMapping,
    this.ticketEntity,
    this.activeFieldCubit,
    this.failureText,
  });

  final LoadingStatus loadingStatus;
  final MappingVersion? ticketMapping;
  final SimpleTextCubit? activeFieldCubit;
  final ScheduledActivity? ticketEntity;
  final String? failureText;

  EditTicketState copyWith({
    LoadingStatus? loadingStatus,
    MappingVersion? ticketMapping,
    SimpleTextCubit? activeFieldCubit,
    ScheduledActivity? ticketEntity,
    String? failureText,
  }) {
    return EditTicketState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      ticketMapping: ticketMapping ?? this.ticketMapping,
      activeFieldCubit: activeFieldCubit ?? this.activeFieldCubit,
      ticketEntity: ticketEntity ?? this.ticketEntity,
      failureText: failureText ?? this.failureText,
    );
  }

  @override
  List<Object?> get props => [
        loadingStatus,
        ticketMapping,
        activeFieldCubit,
        ticketEntity,
        failureText,
      ];
}
