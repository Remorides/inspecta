import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:omdk_inspecta/common/enums/enums.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';

part 'open_ticket_event.dart';

part 'open_ticket_state.dart';

///Page bloc
class OpenTicketBloc extends Bloc<OpenTicketEvent, OpenTicketState> {
  /// Create [OpenTicketBloc] instance
  OpenTicketBloc({
    required this.operaUtils,
    required this.schemaRepo,
    required this.assetRepo,
    required this.schemaListRepo,
    required this.mappingRepo,
    required this.scheduledRepo,
  }) : super(const OpenTicketState()) {
    on<Init>(_onInit);
    on<SelectedSchemaChanged>(_onSchemaChanges);
    on<TicketNameChanged>(_onTicketNameChanged);
    on<TicketDescChanged>(_onTicketDescChanged);
    on<TicketPriorityChanged>(_onTicketPriorityChanged);
    on<TicketEditing>(_onEditingMode);
    on<FieldChanged>(_onFieldChanged);
    on<SubmitTicket>(_onSubmitTicket);
    on<ResetWarning>(_onResetWarning);
  }

  /// [EntityRepo] of [Asset] instance
  final EntityRepo<Asset> assetRepo;

  /// [OperaUtils] instance
  final OperaUtils operaUtils;

  /// [EntityRepo] of [SchemaListItem] instance
  final EntityRepo<SchemaListItem> schemaListRepo;

  /// [EntityRepo] of [OSchema] instance
  final EntityRepo<OSchema> schemaRepo;

  /// [EntityRepo] of [ScheduledActivity] instance
  final EntityRepo<ScheduledActivity> scheduledRepo;

  /// [EntityRepo] of [MappingVersion] instance
  final EntityRepo<MappingVersion> mappingRepo;

  Future<void> _onInit(
    Init event,
    Emitter<OpenTicketState> emit,
  ) async {
    if (event.guid == null) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.fatal,
          failureText: 'Asset guid is required',
        ),
      );
      return;
    }

    // Get enabled schemas
    final schemasRequest = await schemaListRepo.getAPIItems(
      0,
      15,
      optionalParams: {
        'IsEnabled': true,
        'EntityType': JEntityType.Ticket.name,
      },
    );
    final schemas = schemasRequest.fold(
      (schemas) => schemas,
      (failure) => null,
    );
    if (schemas == null || schemas.isEmpty) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.fatal,
          failureText: schemas == null
              ? 'There was a problem retrieving schemas data..'
              : 'There are no available schemas',
        ),
      );
    }

    final assetRequest = await assetRepo.getAPIItem(guid: event.guid!);
    assetRequest.fold(
      (asset) => emit(
        state.copyWith(
          loadingStatus: LoadingStatus.inProgress,
          schemas: schemas,
          jMainNode: JMainNode(
            id: asset.entity.id,
            guid: asset.entity.guid,
            type: NodeType.Asset,
            name: asset.entity.name,
            description: asset.asset?.description,
            path: asset.asset?.path,
          ),
        ),
      ),
      (failure) => emit(
        state.copyWith(
          loadingStatus: LoadingStatus.fatal,
          failureText: 'There was a problem retrieving asset data..',
        ),
      ),
    );
  }

  Future<void> _onSchemaChanges(
    SelectedSchemaChanged event,
    Emitter<OpenTicketState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.initial));
    final schemaMappingRequest =
        await mappingRepo.getAPIItem(guid: event.schemaMappingGuid);
    await schemaMappingRequest.fold(
      (schemaMapping) async {
        final schemaRequest =
            await schemaRepo.getAPIItem(guid: event.schemaGuid);
        await schemaRequest.fold(
          (schema) async {
            final ticketEntity = await operaUtils.generateTicketOEFromSchema(
              schema,
              schemaMapping,
            );
            return emit(
              state.copyWith(
                loadingStatus: LoadingStatus.inProgress,
                schemaMapping: schemaMapping,
                selectedSchemaIndex: event.schemaIndex,
                ticketSchema: schema,
                ticketEntity: ticketEntity,
              ),
            );
          },
          (failure) async => emit(
            state.copyWith(
              loadingStatus: LoadingStatus.failure,
              failureText: 'There was a problem with selected schema, '
                  'please choose another one to open ticket.',
            ),
          ),
        );
      },
      (failure) async => emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          failureText: 'There was a problem with selected schema, '
              'please choose another one to open ticket.',
        ),
      ),
    );
  }

  Future<void> _onSubmitTicket(
    SubmitTicket event,
    Emitter<OpenTicketState> emit,
  ) async {
    if (state.ticketName.isEmpty) {
      return emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          failureText: 'Name is required to open ticket,'
              ' please fill it and try again.',
        ),
      );
    }
    if (state.ticketPriority == 0) {
      return emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          failureText: 'Please select a priority and try again.',
        ),
      );
    }
    final scheduledDate = operaUtils.getParticipationDate();
    final scheduledActivity = state.ticketEntity?.copyWith(
      entity: state.ticketEntity?.entity.copyWith(
        name: state.ticketName,
      ),
      dates: state.ticketEntity?.dates.copyWith(
        scheduled: await operaUtils.getParticipationDate(),
        modified: await operaUtils.getParticipationDate(),
      ),
      scheduled: state.ticketEntity?.scheduled?.copyWith(
        name: state.ticketName,
        description: state.ticketDescription,
      ),
      template: state.ticketEntity?.template?.copyWith(
        name: state.ticketName,
        description: state.ticketDescription,
        urgencyCode: state.ticketPriority,
      ),
      mainNode: state.jMainNode,
    );
    debugPrint(jsonEncode(scheduledActivity));
    try {
      await scheduledRepo.postAPIItem(scheduledActivity!);
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.done,
          failureText: 'Ticket opened successfully!',
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          failureText: 'There was a problem, please try again later..',
        ),
      );
    }
  }

  void _onEditingMode(
    TicketEditing event,
    Emitter<OpenTicketState> emit,
  ) {
    emit(state.copyWith(activeFieldCubit: event.cubit));
  }

  void _onResetWarning(
    ResetWarning event,
    Emitter<OpenTicketState> emit,
  ) {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));
  }

  void _onTicketNameChanged(
    TicketNameChanged event,
    Emitter<OpenTicketState> emit,
  ) {
    emit(state.copyWith(ticketName: event.name));
  }

  void _onTicketDescChanged(
    TicketDescChanged event,
    Emitter<OpenTicketState> emit,
  ) {
    emit(state.copyWith(ticketDescription: event.desc));
  }

  void _onTicketPriorityChanged(
    TicketPriorityChanged event,
    Emitter<OpenTicketState> emit,
  ) {
    emit(state.copyWith(ticketPriority: event.priority));
  }

  Future<void> _onFieldChanged(
    FieldChanged event,
    Emitter<OpenTicketState> emit,
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
            modified: await operaUtils.getParticipationDate(),
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
            modified: await operaUtils.getParticipationDate(),
            value: JFieldValue(
              floatValue: event.fieldValue as double?,
            ),
          );
        case FieldType.Int32:
          state.ticketEntity!.stepsList[indexStep!].fieldsList?[indexField!] =
              state.ticketEntity!.stepsList[indexStep].fieldsList![indexField]
                  .copyWith(
            modified: await operaUtils.getParticipationDate(),
            value: JFieldValue(
              intValue: event.fieldValue as int?,
            ),
          );
        case FieldType.DateTime:
          state.ticketEntity!.stepsList[indexStep!].fieldsList?[indexField!] =
              state.ticketEntity!.stepsList[indexStep].fieldsList![indexField]
                  .copyWith(
            modified: await operaUtils.getParticipationDate(),
            value: JFieldValue(
              dateTimeValue: event.fieldValue as DateTime?,
            ),
          );
        case FieldType.Bool:
          state.ticketEntity!.stepsList[indexStep!].fieldsList?[indexField!] =
              state.ticketEntity!.stepsList[indexStep].fieldsList![indexField]
                  .copyWith(
            modified: await operaUtils.getParticipationDate(),
            value: JFieldValue(
              boolValue: event.fieldValue as bool?,
            ),
          );
        case FieldType.unknown:
        case FieldType.Image:
        case FieldType.InternalStep:
        case FieldType.StepResult:
        case FieldType.File:
        case FieldType.LinkToEntities:
          break;
      }
      emit(state.copyWith(loadingStatus: LoadingStatus.updated));
    } catch (_) {
      emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
  }
}
