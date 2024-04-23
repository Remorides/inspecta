part of 'date_time_cupertino_cubit.dart';

@immutable
final class DateTimeCupertinoState extends Equatable {
  /// Create [DateTimeCupertinoState] instance
  const DateTimeCupertinoState({
    this.isEnabled = true,
    this.status = LoadingStatus.initial,
    this.dateTime,
    this.errorText,
  });

  final bool isEnabled;
  final LoadingStatus status;
  final DateTime? dateTime;
  final String? errorText;

  DateTimeCupertinoState copyWith({
    bool? isEnabled,
    LoadingStatus? status,
    DateTime? dateTime,
    String? errorText,
  }) =>
      DateTimeCupertinoState(
        isEnabled: isEnabled ?? this.isEnabled,
        status: status ?? this.status,
        dateTime: dateTime ?? this.dateTime,
        errorText: errorText ?? this.errorText,
      );

  @override
  List<Object?> get props => [
        isEnabled,
        status,
        dateTime,
      ];
}
