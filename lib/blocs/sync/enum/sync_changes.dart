enum SyncChanges {
  upload(0),
  added(1),
  updated(2),
  deleted(3);

  final int value;

  const SyncChanges(this.value);
}
