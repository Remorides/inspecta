part of 'field_bool_cubit.dart';

@immutable
final class FieldBoolState extends Equatable {
  const FieldBoolState({
    required this.isEnabled,
    required this.fieldValue,
  });

  final bool isEnabled;
  final bool fieldValue;

  FieldBoolState copyWith({
    bool? isEnabled,
    bool? fieldValue,
  }) =>
      FieldBoolState(
        isEnabled: isEnabled ?? this.isEnabled,
        fieldValue: fieldValue ?? this.fieldValue,
      );

  @override
  List<Object?> get props => [isEnabled, fieldValue];
}
