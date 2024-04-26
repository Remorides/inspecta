part of 'open_ticket_bloc.dart';

@immutable
final class OpenTicketState extends Equatable {
  /// Create [OpenTicketState] instance
  const OpenTicketState({
    this.loadingStatus = LoadingStatus.initial,
    this.jMainNode,
    this.ticketName = '',
  });

  final LoadingStatus loadingStatus;
  final JMainNode? jMainNode;
  final String ticketName;

  OpenTicketState copyWith({
    LoadingStatus? loadingStatus,
    JMainNode? jMainNode,
    String? ticketName,
  }) {
    return OpenTicketState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      jMainNode: jMainNode ?? this.jMainNode,
      ticketName: ticketName ?? this.ticketName,
    );
  }

  @override
  List<Object?> get props => [
        loadingStatus,
        jMainNode,
        ticketName,
      ];
}
