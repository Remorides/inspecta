import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'field_bool_state.dart';

class FieldBoolCubit extends Cubit<FieldBoolState> {
  /// Create [FieldBoolCubit] instance
  FieldBoolCubit({
    bool isEnabled = false,
    bool fieldValue = true,
  }) : super(FieldBoolState(isEnabled: isEnabled, fieldValue: fieldValue));

  /// toggle field value
  void toggle() => emit(state.copyWith(fieldValue: !state.fieldValue));

  /// disable possibility to toggle field value
  void disable() => emit(state.copyWith(isEnabled: false));

  /// disable possibility to toggle field value
  void enable() => emit(state.copyWith(isEnabled: true));
}
