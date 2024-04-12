/// Enum to get SimpleTextBloc status
enum SimpleTextStatus {
  /// Default and initial status
  initial,
  /// Validating status is used to validate input data
  validating,
  /// Success status notify success data validation
  success,
  /// Failure status notify that there was an error in data validation
  failure;
}
