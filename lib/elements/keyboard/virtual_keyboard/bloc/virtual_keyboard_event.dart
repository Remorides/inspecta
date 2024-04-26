part of 'virtual_keyboard_bloc.dart';

@immutable
sealed class VirtualKeyboardEvent extends Equatable {}

class ChangeVisibility extends VirtualKeyboardEvent {
  ChangeVisibility({this.isVisibile = false});

  final bool isVisibile;

  @override
  List<Object> get props => <Object>[isVisibile];
}

class ChangeType extends VirtualKeyboardEvent {
  ChangeType({
    this.keyboardType = VirtualKeyboardType.Alphanumeric,
  });

  final VirtualKeyboardType keyboardType;

  @override
  List<Object?> get props => <Object?>[keyboardType];
}

class ChangeShift extends VirtualKeyboardEvent {

  ChangeShift();

  @override
  List<Object?> get props => <Object?>[];
}
