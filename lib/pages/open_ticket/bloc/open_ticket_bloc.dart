import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:omdk/common/enums/enums.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk_mapping/omdk_mapping.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';
import 'package:opera_api_entity/opera_api_entity.dart';
import 'package:opera_repo/opera_repo.dart';

part 'open_ticket_event.dart';
part 'open_ticket_state.dart';


class OpenTicketBloc extends Bloc<OpenTicketEvent, OpenTicketState> {
  /// Create [OpenTicketBloc] instance
  OpenTicketBloc({
    required this.operaRepo,
    required this.schemaRepo,
    required this.assetRepo,
    required this.schemaListRepo,
    required this.mappingRepo,
  }) : super(const OpenTicketState()) {
    on<InitAssetReference>(_onInitAssetReference);
    on<InitSchemas>(_onInitSchemas);
    on<SelectedSchemaChanged>(_onSchemaChanges);
    on<TicketNameChanged>(_onTicketNameChanged);
    on<TicketDescChanged>(_onTicketDescChanged);
    on<TicketPriorityChanged>(_onTicketPriorityChanged);
    on<TicketEditing>(_onEditingMode);
  }

  /// [EntityRepo] of [Asset] instance
  final EntityRepo<Asset> assetRepo;

  /// [OperaRepo] instance
  final OperaRepo operaRepo;

  /// [EntityRepo] of [SchemaListItem] instance
  final EntityRepo<SchemaListItem> schemaListRepo;

  /// [EntityRepo] of [OSchema] instance
  final EntityRepo<OSchema> schemaRepo;

  /// [EntityRepo] of [MappingVersion] instance
  final EntityRepo<MappingVersion> mappingRepo;

  Future<void> _onInitAssetReference(
    InitAssetReference event,
    Emitter<OpenTicketState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));
    if (event.guid == null) {
      return emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
    try {
      final result = await assetRepo.getAPIItem(guid: event.guid!);
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.done,
          jMainNode: JMainNode(
            id: result.entity?.id,
            guid: result.entity?.guid,
            type: NodeType.Asset,
            name: result.entity?.name,
            description: result.asset?.description,
            path: result.asset?.path,
          ),
        ),
      );
    } catch (_) {
      emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
  }

  Future<void> _onInitSchemas(
    InitSchemas event,
    Emitter<OpenTicketState> emit,
  ) async {
    try {
      final schemas = await schemaListRepo.getAPIItems(
        0,
        15,
        optionalParams: {
          'EntityType': JEntityType.Ticket.name,
        },
      );
      emit(state.copyWith(schemas: schemas));
    } catch (_) {
      emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
  }

  Future<void> _onSchemaChanges(
    SelectedSchemaChanged event,
    Emitter<OpenTicketState> emit,
  ) async {
    try {
      final schemaMapping =
          await mappingRepo.getAPIItem(guid: event.schemaMappingGuid);
      final schema = await schemaRepo.getAPIItem(guid: event.schemaGuid);
      final ticketEntity = await operaRepo.generateTicketOEFromSchema(
        schema,
        schemaMapping,
      );
      emit(
        state.copyWith(
          schemaMapping: schemaMapping,
          selectedSchemaIndex: event.schemaIndex,
          ticketSchema: schema,
          ticketEntity: ticketEntity,
        ),
      );
    } catch (_) {
      emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
  }

  void _onEditingMode(
    TicketEditing event,
    Emitter<OpenTicketState> emit,
  ) {
    emit(state.copyWith(activeFieldBloc: event.bloc));
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
}
