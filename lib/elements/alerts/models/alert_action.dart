/// Action of alert item
class AlertAction {

  /// Create [AlertAction] instance
  AlertAction(
    this.text,
    this.action,
  );

  /// Action text
  final String text;
  /// Action to perform on item click
  final void Function()? action;
}
