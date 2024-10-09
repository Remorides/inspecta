/// Utilities for int and double type
extension NumExtensions on num {
  double mapToRange(
    double toMin,
    double toMax, {
    num fromMin = 0.0,
    num fromMax = 1.0,
  }) =>
      toMin +
      ((this - fromMin) / (fromMax - fromMin)).clamp(0.0, 1.0) *
          (toMax - toMin);
}
