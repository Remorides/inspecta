part of 'virtual_keyboard_bloc.dart';

@immutable
final class VirtualKeyboardState extends Equatable {
  const VirtualKeyboardState({
    required this.isVisible,
    this.keyboardType = VirtualKeyboardType.Alphanumeric,
    this.isShiftEnabled = false,
    this.isNumericMode = false,
  });

  final bool isVisible;
  final bool isShiftEnabled;
  final bool isNumericMode;
  final VirtualKeyboardType keyboardType;

  VirtualKeyboardState copyWith({
    bool? isVisible,
    bool? isShiftEnabled,
    bool? isNumericMode,
    VirtualKeyboardType? keyboardType,
  }) =>
      VirtualKeyboardState(
        isVisible: isVisible ?? this.isVisible,
        isShiftEnabled: isShiftEnabled ?? this.isShiftEnabled,
        isNumericMode: isNumericMode ?? this.isNumericMode,
        keyboardType: keyboardType ?? this.keyboardType,
      );

  @override
  List<Object?> get props => [
        isVisible,
        isNumericMode,
        isShiftEnabled,
        keyboardType,
      ];
}
