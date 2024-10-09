extension DateTimeStringExtension on DateTime? {
  String get presentableDateString {
    return '${this!.day}/${this!.month}/${this!.year}';
  }

  String get presentableDateAndTimeString {
    return '${this!.day}/${this!.month}/${this!.year} '
        "${this!.hour.toString().padLeft(2, '0')}:${this!.minute.toString().padLeft(2, '0')}";
  }
}
