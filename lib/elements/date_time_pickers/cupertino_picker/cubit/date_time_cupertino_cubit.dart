import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:omdk_inspecta/common/common.dart';

part 'date_time_cupertino_state.dart';

class DateTimeCupertinoCubit extends Cubit<DateTimeCupertinoState> {
  /// Create [DateTimeCupertinoCubit] instance
  DateTimeCupertinoCubit({bool isEnabled = true})
      : super(DateTimeCupertinoState(isEnabled: isEnabled));

  void updateDate(DateTime dateTime) =>
      emit(state.copyWith(dateTime: dateTime));
}
