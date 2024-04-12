import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk/elements/texts/simple_text_field/simple_text_field.dart ';

part 'simple_text_event.dart';

part 'simple_text_state.dart';

/// [Bloc] dedicate to [SimpleTextField]
class SimpleTextBloc extends Bloc<SimpleTextEvent, SimpleTextState> {
  /// Create [SimpleTextBloc] instance
  SimpleTextBloc({
    required bool isEmptyAllowed,
    required bool isNullable,
  }) : super(
          SimpleTextState(
            isEmptyAllowed: isEmptyAllowed,
            isNullable: isNullable,
          ),
        ) {
    on<TextChanged>(_onTextChanges);
    on<ValidateData>(_onValidateData);
  }

  Future<void> _onTextChanges(
    TextChanged event,
    Emitter<SimpleTextState> emit,
  ) async {
    emit(state.copyWith(text: event.text));
  }

  Future<void> _onValidateData(
    ValidateData event,
    Emitter<SimpleTextState> emit,
  ) async {
    emit(state.copyWith(status: SimpleTextStatus.validating));
    if (!state.isNullable && state.text == null) {
      return emit(state.copyWith(status: SimpleTextStatus.failure));
    }
    if (!state.isEmptyAllowed && state.text != null && state.text!.isEmpty) {
      return emit(state.copyWith(status: SimpleTextStatus.failure));
    }
    return emit(state.copyWith(status: SimpleTextStatus.success));
  }
}
