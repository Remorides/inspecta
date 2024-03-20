/// Enum to show authentication process
enum LoginStatus {
  /// start value of login
  initial,
  /// login in progress
  inProgress,
  /// auth done
  isDone,
  /// auth failure, check exception
  isFailure,
}
