/// Generic enums to show data loading status
enum LoadingStatus {
  /// default value
  initial,
  /// loading data in progress
  inProgress,
  /// loading updated successfully
  updated,
  /// loading finished successfully
  done,
  /// there was a problem
  failure,
  /// there was a fatal problem
  fatal;
}
