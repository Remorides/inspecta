import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk_mapping/omdk_mapping.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';
import 'package:opera_api_entity/opera_api_entity.dart';
import 'package:opera_repo/opera_repo.dart';

part 'edit_ticket_event.dart';

part 'edit_ticket_state.dart';

///Page bloc
class EditTicketBloc extends Bloc<EditTicketEvent, EditTicketState> {
  /// Create [EditTicketBloc] instance
  EditTicketBloc({
    required this.operaRepo,
    required this.mappingRepo,
    required this.scheduledRepo,
  }) : super(const EditTicketState()) {
    on<InitTicket>(_onInitTicket);
    on<TicketNameChanged>(_onTicketNameChanged);
    on<TicketDescChanged>(_onTicketDescChanged);
    on<TicketEditing>(_onEditingMode);
    on<FieldChanged>(_onFieldChanged);
  }

  /// [OperaRepo] instance
  final OperaRepo operaRepo;

  /// [EntityRepo] of [ScheduledActivity] instance
  final EntityRepo<ScheduledActivity> scheduledRepo;

  /// [EntityRepo] of [MappingVersion] instance
  final EntityRepo<MappingVersion> mappingRepo;

  Future<void> _onInitTicket(
    InitTicket event,
    Emitter<EditTicketState> emit,
  ) async {
    if (event.guid == null) {
      return emit(
        state.copyWith(
          loadingStatus: LoadingStatus.fatal,
          failureText: 'Ticket guid is required',
        ),
      );
    }
    try {
      final entity = await scheduledRepo.getAPIItem(guid: event.guid!);
      final mapping = await mappingRepo.getAPIItem(guid: entity.mapping!.guid!);
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.inProgress,
          ticketEntity: entity,
          ticketMapping: mapping,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.fatal,
          failureText: 'There was a problem retrieving ticket data..',
        ),
      );
    }
  }

  Future<void> _onTicketNameChanged(
    TicketNameChanged event,
    Emitter<EditTicketState> emit,
  ) async {
    emit(
      state.copyWith(
        ticketEntity: state.ticketEntity?.copyWith(
          entity: state.ticketEntity?.entity?.copyWith(
            name: event.name,
          ),
          scheduled: state.ticketEntity?.scheduled?.copyWith(
            name: event.name,
          ),
        ),
      ),
    );
  }

  Future<void> _onTicketDescChanged(
      TicketDescChanged event,
      Emitter<EditTicketState> emit,
      ) async {
    emit(
      state.copyWith(
        ticketEntity: state.ticketEntity?.copyWith(
          scheduled: state.ticketEntity?.scheduled?.copyWith(
            name: event.desc,
          ),
        ),
      ),
    );
  }

  void _onEditingMode(
      TicketEditing event,
      Emitter<EditTicketState> emit,
      ) {
    emit(state.copyWith(activeFieldBloc: event.bloc));
  }

  Future<void> _onFieldChanged(
      FieldChanged event,
      Emitter<EditTicketState> emit,
      ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));
    try {
      final indexStep = state.ticketEntity?.stepsList
          .indexWhere((jStepEntity) => jStepEntity.guid == event.stepGuid);
      final indexField = state.ticketEntity?.stepsList[indexStep!].fieldsList
          ?.indexWhere((jFieldEntity) => jFieldEntity.guid == event.fieldGuid);

      switch (event.fieldMapping.type) {
        case FieldType.String:
          state.ticketEntity!.stepsList[indexStep!].fieldsList?[indexField!] =
              state.ticketEntity!.stepsList[indexStep].fieldsList![indexField]
                  .copyWith(
                modified: await operaRepo.getParticipationDate(),
                value: JFieldValue(
                  stringValue: (event.fieldValue is String?)
                      ? event.fieldValue as String?
                      : null,
                  stringsList: (event.fieldValue is List)
                      ? event.fieldValue as List<String>?
                      : null,
                ),
              );
        case FieldType.Double:
          state.ticketEntity!.stepsList[indexStep!].fieldsList?[indexField!] =
              state.ticketEntity!.stepsList[indexStep].fieldsList![indexField]
                  .copyWith(
                modified: await operaRepo.getParticipationDate(),
                value: JFieldValue(
                  floatValue: event.fieldValue as double?,
                ),
              );
        case FieldType.Int32:
          state.ticketEntity!.stepsList[indexStep!].fieldsList?[indexField!] =
              state.ticketEntity!.stepsList[indexStep].fieldsList![indexField]
                  .copyWith(
                modified: await operaRepo.getParticipationDate(),
                value: JFieldValue(
                  intValue: event.fieldValue as int?,
                ),
              );
        case FieldType.Datetime:
          state.ticketEntity!.stepsList[indexStep!].fieldsList?[indexField!] =
              state.ticketEntity!.stepsList[indexStep].fieldsList![indexField]
                  .copyWith(
                modified: await operaRepo.getParticipationDate(),
                value: JFieldValue(
                  dateTimeValue: event.fieldValue as DateTime?,
                ),
              );
        case FieldType.Bool:
          state.ticketEntity!.stepsList[indexStep!].fieldsList?[indexField!] =
              state.ticketEntity!.stepsList[indexStep].fieldsList![indexField]
                  .copyWith(
                modified: await operaRepo.getParticipationDate(),
                value: JFieldValue(
                  boolValue: event.fieldValue as bool?,
                ),
              );
        case FieldType.unknown:
        case FieldType.Image:
        case FieldType.InternalStep:
        case FieldType.StepResult:
        case FieldType.File:
          break;
      }
      emit(state.copyWith(loadingStatus: LoadingStatus.updated));
    } catch (_) {
      emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
  }
}
