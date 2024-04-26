import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:omdk/elements/texts/simple_text_field/simple_text_field.dart ';

part 'simple_text_event.dart';

part 'simple_text_state.dart';

/// [Bloc] dedicate to [SimpleTextField]
class SimpleTextBloc extends Bloc<SimpleTextEvent, SimpleTextState> {
  /// Create [SimpleTextBloc] instance
  SimpleTextBloc({
    bool isEmptyAllowed = false,
    bool isNullable = false,
  }) : super(
          SimpleTextState(
            isEmptyAllowed: isEmptyAllowed,
            isNullable: isNullable,
          ),
        ) {
    on<TextChanged>(_onTextChanges);
    on<InitialText>(_onInitialText);
    on<ValidateData>(_onValidateData);
  }

  Future<void> _onTextChanges(
    TextChanged event,
    Emitter<SimpleTextState> emit,
  ) async {
    emit(state.copyWith(text: event.text, errorText: ''));
  }

  Future<void> _onInitialText(
    InitialText event,
    Emitter<SimpleTextState> emit,
  ) async {
    emit(state.copyWith(initialText: event.initialText));
  }

  Future<void> _onValidateData(
    ValidateData event,
    Emitter<SimpleTextState> emit,
  ) async {
    emit(state.copyWith(status: SimpleTextStatus.validating));
    if (!state.isNullable && state.text == null) {
      return emit(
        state.copyWith(
          status: SimpleTextStatus.failure,
          errorText: '* Mandatory field',
        ),
      );
    }
    if (!state.isEmptyAllowed && state.text != null && state.text!.isEmpty) {
      return emit(
        state.copyWith(
          status: SimpleTextStatus.failure,
          errorText: '* This field cannot be empty',
        ),
      );
    }
    return emit(state.copyWith(status: SimpleTextStatus.success));
  }
}
