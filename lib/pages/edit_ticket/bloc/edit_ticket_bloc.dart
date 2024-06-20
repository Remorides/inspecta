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
    on<CheckStateTicket>(_onCheckStateTicket);
    on<ExecuteTicket>(_onExecuteTicket);
    on<InitTicket>(_onInitTicket);
    on<TicketNameChanged>(_onTicketNameChanged);
    on<TicketDescChanged>(_onTicketDescChanged);
    on<TicketEditing>(_onEditingMode);
    on<FieldChanged>(_onFieldChanged);
    on<TicketPriorityChanged>(_onTicketPriorityChanged);
    on<SubmitTicket>(_onTicketSubmitted);
    on<ResetWarning>(_onResetWarning);
  }

  /// [OperaRepo] instance
  final OperaRepo operaRepo;

  /// [EntityRepo] of [ScheduledActivity] instance
  final EntityRepo<ScheduledActivity> scheduledRepo;

  /// [EntityRepo] of [MappingVersion] instance
  final EntityRepo<MappingVersion> mappingRepo;

  Future<void> _onCheckStateTicket(
    CheckStateTicket event,
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
      switch (entity.scheduled?.state) {
        case ActivityState.unknown:
        case null:
          return emit(
            state.copyWith(
              loadingStatus: LoadingStatus.fatal,
              failureText: 'There was a problem retrieving ticket data..',
            ),
          );
        case ActivityState.Scheduled:
          return emit(
            state.copyWith(
              ticketEntity: entity,
              loadingStatus: LoadingStatus.fatal,
              failureText: 'Ticket state is ${ActivityState.Scheduled.name},'
                  ' you must execute it to modify',
            ),
          );
        case ActivityState.Running:
          return add(InitTicket(guid: event.guid));
        case ActivityState.Paused:
          return emit(
            state.copyWith(
              loadingStatus: LoadingStatus.fatal,
              failureText: 'Ticket state is ${ActivityState.Running.name},'
                  ' you must resume it to modify',
            ),
          );
        case ActivityState.Finished:
          return emit(
            state.copyWith(
              loadingStatus: LoadingStatus.fatal,
              failureText: 'Ticket state is ${ActivityState.Finished.name},'
                  ' you cannot edit anything',
            ),
          );
        case ActivityState.Approving:
          return emit(
            state.copyWith(
              loadingStatus: LoadingStatus.fatal,
              failureText: 'Ticket state is ${ActivityState.Approving.name},'
                  ' you cannot edit anything',
            ),
          );
        case ActivityState.Signing:
          return emit(
            state.copyWith(
              loadingStatus: LoadingStatus.fatal,
              failureText: 'Ticket state is ${ActivityState.Signing.name},'
                  ' you cannot edit anything',
            ),
          );
        case ActivityState.Rejected:
          return emit(
            state.copyWith(
              loadingStatus: LoadingStatus.fatal,
              failureText: 'Ticket state is ${ActivityState.Rejected.name},'
                  ' you cannot edit anything',
            ),
          );
        case ActivityState.Create:
          return emit(
            state.copyWith(
              loadingStatus: LoadingStatus.fatal,
              failureText: 'Ticket state is ${ActivityState.Create.name},'
                  ' you must scheduled it to modify',
            ),
          );
        case ActivityState.Expired:
          return emit(
            state.copyWith(
              loadingStatus: LoadingStatus.fatal,
              failureText: 'Ticket state is ${ActivityState.Expired.name},'
                  ' you cannot edit anything',
            ),
          );
      }
    } catch (_) {
      return emit(
        state.copyWith(
          loadingStatus: LoadingStatus.fatal,
          failureText: 'There was a problem retrieving ticket data..',
        ),
      );
    }
  }

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

  Future<void> _onExecuteTicket(
    ExecuteTicket event,
    Emitter<EditTicketState> emit,
  ) async {
    try {
      final entity = await scheduledRepo.getAPIItem(guid: event.guid);

      final participationList =
          List<JUserParticipation>.from(entity.partecipationsList);
      final stateList =
          List<JEntityState>.from(entity.statesList ?? []);

      final userParticipation = await operaRepo.getUserParticipation();
      if (!participationList.contains(userParticipation)) {
        participationList.add(userParticipation);
      }
      stateList.add(
        JEntityState(
          value: ActivityState.Running,
          modified: await operaRepo.getParticipationDate(),
        ),
      );

      await scheduledRepo.putAPIItem(
        entity.copyWith(
          dates: entity.dates?.copyWith(
            modified: await operaRepo.getParticipationDate(),
            executed: await operaRepo.getParticipationDate(),
          ),
          scheduled: entity.scheduled?.copyWith(
            state: ActivityState.Running,
          ),
          statesList: stateList,
          partecipationsList: participationList,
        ),
      );
      add(InitTicket(guid: entity.scheduled?.guid));
    } on Exception catch (_) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          failureText: 'There was a problem, please try again later..',
        ),
      );
    }
  }

  Future<void> _onTicketSubmitted(
    SubmitTicket event,
    Emitter<EditTicketState> emit,
  ) async {
    if (state.ticketEntity!.entity!.name!.isEmpty) {
      return emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          failureText: 'Name is required to send ticket changes,'
              ' please fill it and try again.',
        ),
      );
    }

    try {
      final participationList =
          List<JUserParticipation>.from(state.ticketEntity!.partecipationsList);
      final stateList =
          List<JEntityState>.from(state.ticketEntity!.statesList ?? []);

      final userParticipation = await operaRepo.getUserParticipation();
      if (!participationList.contains(userParticipation)) {
        participationList.add(userParticipation);
      }
      stateList.add(
        JEntityState(
          value: ActivityState.Finished,
          modified: await operaRepo.getParticipationDate(),
        ),
      );

      await scheduledRepo.putAPIItem(
        state.ticketEntity!.copyWith(
          dates: state.ticketEntity?.dates?.copyWith(
            modified: await operaRepo.getParticipationDate(),
            closed: await operaRepo.getParticipationDate(),
          ),
          scheduled: state.ticketEntity?.scheduled?.copyWith(
            state: ActivityState.Finished,
          ),
          statesList: stateList,
          partecipationsList: participationList,
        ),
      );
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.done,
          failureText: 'Ticket closed successfully!',
        ),
      );
    } on Exception catch (_) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          failureText: 'There was a problem, please try again later..',
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
          template: state.ticketEntity?.template?.copyWith(
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
            description: event.desc,
          ),
          template: state.ticketEntity?.template?.copyWith(
            description: event.desc,
          ),
        ),
      ),
    );
  }

  Future<void> _onTicketPriorityChanged(
    TicketPriorityChanged event,
    Emitter<EditTicketState> emit,
  ) async {
    emit(
      state.copyWith(
        ticketEntity: state.ticketEntity?.copyWith(
          template: state.ticketEntity?.template?.copyWith(
            urgencyCode: event.priority,
          ),
        ),
      ),
    );
  }

  void _onResetWarning(
    ResetWarning event,
    Emitter<EditTicketState> emit,
  ) {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));
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
        case FieldType.StepResult:
          state.ticketEntity!.stepsList[indexStep!].fieldsList?[indexField!] =
              state.ticketEntity!.stepsList[indexStep].fieldsList![indexField]
                  .copyWith(
            modified: await operaRepo.getParticipationDate(),
            value: JFieldValue(
              intValue: event.fieldValue as int?,
            ),
          );
        case FieldType.unknown:
        case FieldType.Image:
        case FieldType.InternalStep:
        case FieldType.File:
          break;
      }
      emit(state.copyWith(loadingStatus: LoadingStatus.updated));
    } catch (_) {
      emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
  }
}
