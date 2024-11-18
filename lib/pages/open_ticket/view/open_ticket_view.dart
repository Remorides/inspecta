part of 'open_ticket_page.dart';

/// Login form class provide all required field to login
class _OpenTicketView extends StatelessWidget {
  /// Build [_OpenTicketView] instance
  const _OpenTicketView({
    required this.closePage,
  });

  final bool closePage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpenTicketBloc, OpenTicketState>(
      listenWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      listener: (context, state) {
        if (state.loadingStatus == LoadingStatus.done) {
          if (closePage && kIsWeb) {
            return web.window.close();
          }
          OMDKAlert.show(context, _successAlert(context));
        }
        if (state.loadingStatus == LoadingStatus.failure) {
          OMDKAlert.show(
            context,
            _failureAlert(context, state.failureText),
          );
        }
      },
      child: OMDKSimplePage(
        withBottomBar: false,
        withDrawer: false,
        isForm: true,
        leading: FilledButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: () {
            context.read<AuthRepo>().logOut();
            if (closePage && kIsWeb) {
              return web.window.close();
            }
          },
          child: Text(
            context.l.alert_btn_cancel,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Colors.white),
          ),
        ),
        bodyPage: const _LayoutBuilder(),
      ),
    );
  }

  OMDKAlert _failureAlert(BuildContext context, String? failureText) =>
      OMDKAlert(
        title: AppLocalizations.of(context)!.alert_title_warning,
        type: AlertType.warning,
        message: Text(
          '$failureText',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        confirm: AppLocalizations.of(context)!.alert_btn_ok,
        onConfirm: () => context.read<OpenTicketBloc>().add(ResetWarning()),
      );

  OMDKAlert _successAlert(BuildContext context) => OMDKAlert(
        title: AppLocalizations.of(context)!.alert_title_done,
        type: AlertType.success,
        message: const Text('SUCCESSO', style: TextStyle(color: Colors.black)),
        confirm: AppLocalizations.of(context)!.alert_btn_ok,
        onConfirm: () => context.read<AuthRepo>().logOut(),
      );
}

class _LayoutBuilder extends StatefulWidget {
  const _LayoutBuilder();

  @override
  State<_LayoutBuilder> createState() => _LayoutBuilderState();
}

class _LayoutBuilderState extends State<_LayoutBuilder>
    with LoadingHandler<_LayoutBuilder> {
  late final VirtualKeyboardCubit _keyboardCubit;

  late TextEditingController _activeController;
  late SimpleTextCubit? _activeFieldCubit;

  @override
  void initState() {
    super.initState();
    _keyboardCubit = VirtualKeyboardCubit();
    _activeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OpenTicketBloc, OpenTicketState>(
      listenWhen: (previous, current) =>
          previous.activeFieldCubit != current.activeFieldCubit,
      listener: (context, state) {
        if (state.activeFieldCubit != null) {
          _activeFieldCubit = state.activeFieldCubit;
          _activeController = state.activeFieldCubit!.controller;
        }
        switch (state.loadingStatus) {
          case LoadingStatus.initial:
            showLoading();
          case LoadingStatus.inProgress:
          case LoadingStatus.updated:
          case LoadingStatus.done:
          case LoadingStatus.failure:
          case LoadingStatus.fatal:
            hideLoading();
        }
      },
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) => state.loadingStatus == LoadingStatus.fatal
          ? Container()
          : Padding(
              padding: const EdgeInsets.only(top: 20, left: 14, right: 14),
              child: Column(
                children: [
                  Expanded(
                    child: (ResponsiveWidget.isSmallScreen(context))
                        ? singleColumnLayout(context)
                        : Center(
                            child: twoColumnLayout(context, _keyboardCubit),
                          ),
                  ),
                  CustomVirtualKeyboard(
                    cubit: _keyboardCubit,
                    controller: _activeController,
                    onKeyPress: (key) => _onKeyPress(context, key),
                  ),
                ],
              ),
            ),
    );
  }

  void _onKeyPress(
    BuildContext context,
    VirtualKeyboardKey key,
  ) {
    var text = _activeFieldCubit?.controller.text ?? _activeController.text;

    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text +
          ((_keyboardCubit.state.isShiftEnabled ? key.capsText : key.text) ??
              '');
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.isEmpty) return;
          text = text.substring(0, text.length - 1);
        case VirtualKeyboardKeyAction.Return:
          text = '$text\n';
        case VirtualKeyboardKeyAction.Space:
          text = text + (key.text ?? '');
        case VirtualKeyboardKeyAction.Shift:
          _keyboardCubit.toggleShift();
        case VirtualKeyboardKeyAction.SwithLanguage:
        case null:
          break;
      }
    }
    _activeFieldCubit?.setText(text);
  }

  Widget singleColumnLayout(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            _TicketNameInput(keyboardBloc: _keyboardCubit),
            _TicketDescInput(keyboardBloc: _keyboardCubit),
            const _TicketPriorityInput(),
            _TicketStepList(keyboardBloc: _keyboardCubit),
          ],
        ),
      );

  Widget twoColumnLayout(
    BuildContext context,
    VirtualKeyboardCubit keyboardBloc,
  ) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ListView(
              children: [
                const _AssetReference(),
                _TicketNameInput(keyboardBloc: _keyboardCubit),
                _TicketDescInput(keyboardBloc: _keyboardCubit),
                const _TicketPriorityInput(),
                const _TicketSchemaInput(),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _TicketStepList(keyboardBloc: _keyboardCubit),
          ),
        ),
      ],
    );
  }
}

class _AssetReference extends StatelessWidget {
  /// Create [_AssetReference] instance
  const _AssetReference();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTicketBloc, OpenTicketState>(
      buildWhen: (previous, current) => previous.jMainNode != current.jMainNode,
      builder: (context, state) => (state.jMainNode != null)
          ? FieldString(
              isEnabled: false,
              labelText: context.l.ticket_label_asset_reference,
              initialText: state.jMainNode?.name,
            )
          : FieldString(
              key: const Key('assetReference_textField'),
              isEnabled: false,
              labelText: context.l.ticket_label_asset_reference,
            ),
    );
  }
}

class _TicketNameInput extends StatelessWidget {
  /// Create [_TicketNameInput] instance
  const _TicketNameInput({required this.keyboardBloc});

  final VirtualKeyboardCubit keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return FieldString(
      onChanged: (text) =>
          context.read<OpenTicketBloc>().add(TicketNameChanged(text)),
      labelText: context.l.ticket_label_name,
      keyboardCubit: keyboardBloc,
      onTapCubit: (bloc) =>
          context.read<OpenTicketBloc>().add(TicketEditing(cubit: bloc)),
    );
  }
}

class _TicketDescInput extends StatelessWidget {
  /// Create [_TicketDescInput] instance
  const _TicketDescInput({required this.keyboardBloc});

  final VirtualKeyboardCubit keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return FieldString(
      onChanged: (text) =>
          context.read<OpenTicketBloc>().add(TicketDescChanged(text)),
      labelText: context.l.ticket_label_description,
      keyboardCubit: keyboardBloc,
      onTapCubit: (bloc) =>
          context.read<OpenTicketBloc>().add(TicketEditing(cubit: bloc)),
    );
  }
}

class _TicketPriorityInput extends StatelessWidget {
  /// Create [_TicketPriorityInput] instance
  const _TicketPriorityInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTicketBloc, OpenTicketState>(
      buildWhen: (previous, current) =>
          previous.ticketPriority != current.ticketPriority,
      builder: (context, state) => PriorityButtons(
        key: const Key('ticketPriorityInput_textField'),
        onSelectedPriority: (priorityCode) => context
            .read<OpenTicketBloc>()
            .add(TicketPriorityChanged(priorityCode)),
        labelText: context.l.ticket_label_priority,
        indexSelectedRadio: state.ticketPriority,
      ),
    );
  }
}

class _TicketSchemaInput extends StatelessWidget {
  /// Create [_TicketSchemaInput] instance
  const _TicketSchemaInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTicketBloc, OpenTicketState>(
      buildWhen: (previous, current) =>
          previous.selectedSchemaIndex != current.selectedSchemaIndex ||
          previous.schemas != current.schemas,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      context.l.ticket_label_typology.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: state.schemas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ColoredBox(
                      color: index == state.selectedSchemaIndex
                          ? Colors.white
                          : Theme.of(context).scaffoldBackgroundColor,
                      child: ListTile(
                        selected: index == state.selectedSchemaIndex,
                        selectedColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                        onTap: () => context.read<OpenTicketBloc>().add(
                              SelectedSchemaChanged(
                                schemaIndex: index,
                                schemaMappingGuid:
                                    state.schemas[index].mapping.guid!,
                                schemaGuid: state.schemas[index].guid,
                              ),
                            ),
                        title: Text(
                          '${state.schemas[index].name}',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: index == state.selectedSchemaIndex
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                                fontWeight: index == state.selectedSchemaIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TicketStepList extends StatelessWidget {
  /// Create [_TicketStepList] instance
  const _TicketStepList({
    this.keyboardBloc,
  });

  final VirtualKeyboardCubit? keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTicketBloc, OpenTicketState>(
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        return (state.ticketEntity != null)
            ? Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: state.ticketEntity!.stepsList.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.ticketEntity!.stepsList.length) {
                      return submitTicket(context: context);
                    }
                    return ExpansionTile(
                      //initiallyExpanded: index == 0, not expand automatically
                      title: Text(
                        '${context.localizeLabel(state.ticketEntity!.stepsList[index].title)}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      children: buildFieldList(
                        context: context,
                        stepEntity: state.ticketEntity!.stepsList[index],
                        schemaMapping: state.schemaMapping!,
                        keyboardBloc: keyboardBloc,
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.ticket_hint_select_schema,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              );
      },
    );
  }

  List<Widget> buildFieldList({
    required BuildContext context,
    required JStepEntity stepEntity,
    required MappingVersion schemaMapping,
    VirtualKeyboardCubit? keyboardBloc,
  }) {
    // Widget list to show
    final fieldWidgets = <Widget>[];

    final stepMapping = schemaMapping.data.defStepsList?.firstWhere(
      (stepMapping) => stepMapping.hash == stepEntity.stepMappingHash,
    );

    for (final jFieldMapping in stepMapping!.fieldsList!) {
      final jFieldEntity = stepEntity.fieldsList?.firstWhereOrNull(
        (JFieldEntity jFieldEntity) =>
            jFieldEntity.mappingHash == jFieldMapping.hash,
      );
      if (jFieldEntity!.operations!.design!.values!.contains('R')) {
        fieldWidgets.add(
          buildField(
            context: context,
            jFieldMapping: jFieldMapping,
            jFieldEntity: jFieldEntity,
            stepGuid: stepEntity.guid!,
            keyboardBloc: keyboardBloc,
          ),
        );
      }
    }
    return fieldWidgets;
  }

  Widget buildField({
    required BuildContext context,
    required JFieldMapping jFieldMapping,
    required String stepGuid,
    JFieldEntity? jFieldEntity,
    VirtualKeyboardCubit? keyboardBloc,
  }) {
    switch (jFieldMapping.type) {
      case FieldType.String:
        switch (jFieldMapping.collectionType) {
          case CollectionType.List:
            return FieldPoolList(
              labelText: '${context.localizeLabel(jFieldMapping.title)}',
              listItem: jFieldMapping.poolListSettings!.value!,
              isEnabled: jFieldMapping.operations!.design.checkU,
              onChanged: (String? s) => context.read<OpenTicketBloc>().add(
                    FieldChanged(
                      stepGuid: stepGuid,
                      fieldMapping: jFieldMapping,
                      fieldGuid: jFieldEntity!.guid!,
                      fieldValue: <String>[s!],
                    ),
                  ),
            );
          case CollectionType.Single:
            if (jFieldMapping.poolListSettings?.value != null) {
              return FieldPoolList(
                selectedItem: jFieldEntity?.value?.stringsList?.first,
                labelText: '${context.localizeLabel(jFieldMapping.title)}',
                listItem: jFieldMapping.poolListSettings!.value!,
                isEnabled: jFieldMapping.operations!.design.checkU,
                onChanged: (String? s) => context.read<OpenTicketBloc>().add(
                      FieldChanged(
                        stepGuid: stepGuid,
                        fieldMapping: jFieldMapping,
                        fieldGuid: jFieldEntity!.guid!,
                        fieldValue: <String>[s!],
                      ),
                    ),
              );
            } else if (jFieldMapping.poolListSettings?.multiSelect ?? false) {
              return FieldMultiPoolList(
                labelText: '${context.localizeLabel(jFieldMapping.title)}',
                isEnabled:
                    jFieldEntity!.operations!.design!.values!.contains('U'),
                listItem: jFieldMapping.poolListSettings!.value!,
                focusNode: FocusNode(),
                onSelected: (List<PoolItem?> selectedItems) {},
              );
            } else {
              return FieldString(
                labelText: '${context.localizeLabel(jFieldMapping.title)}',
                initialText: jFieldEntity?.value?.stringValue,
                keyboardCubit: keyboardBloc,
                onTapCubit: (bloc) => context
                    .read<OpenTicketBloc>()
                    .add(TicketEditing(cubit: bloc)),
                isEnabled: jFieldMapping.operations!.design.checkU,
                focusNode: FocusNode(),
                onChanged: (String? s) => context.read<OpenTicketBloc>().add(
                      FieldChanged(
                        stepGuid: stepGuid,
                        fieldMapping: jFieldMapping,
                        fieldGuid: jFieldEntity!.guid!,
                        fieldValue: s,
                      ),
                    ),
              );
            }
          case CollectionType.unknown:
            return const Stack();
        }
      case FieldType.Image:
        if (jFieldEntity?.value == null) return const Stack();
        // return FieldImage(
        //   labelText: '${(jFieldMapping.title?.singleWhereOrNull(
        //         (element) =>
        //     element.culture?.contains(
        //       Localizations.localeOf(context).languageCode,
        //     ) ??
        //         false,
        //   ) ?? jFieldMapping.title?[0])?.value}',
        //   imageGuid: jFieldEntity?.value?.imagesList?.first,
        // );
        return FieldSliderImages(
          labelText: '${context.localizeLabel(jFieldMapping.title)}',
          imageList: jFieldEntity?.value?.imagesList,
        );
      case FieldType.Double:
        return FieldDouble(
          labelText: '${context.localizeLabel(jFieldMapping.title)}',
          onTapCubit: (bloc) =>
              context.read<OpenTicketBloc>().add(TicketEditing(cubit: bloc)),
          focusNode: FocusNode(),
          isEnabled: jFieldMapping.operations!.design.checkU,
          onChanged: (double? d) => context.read<OpenTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity!.guid!,
                  fieldValue: d,
                ),
              ),
        );
      case FieldType.Int32:
        return FieldInt(
          labelText: '${context.localizeLabel(jFieldMapping.title)}',
          isEnabled: jFieldMapping.operations!.design.checkU,
          onTapCubit: (bloc) =>
              context.read<OpenTicketBloc>().add(TicketEditing(cubit: bloc)),
          onChanged: (int? i) => context.read<OpenTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity!.guid!,
                  fieldValue: i,
                ),
              ),
        );
      case FieldType.Bool:
        return FieldBool(
          labelText: '${context.localizeLabel(jFieldMapping.title)}',
          focusNode: FocusNode(),
          isEnabled: jFieldMapping.operations!.design.checkU,
          onChanged: (bool? b) => context.read<OpenTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity!.guid!,
                  fieldValue: b,
                ),
              ),
        );
      case FieldType.DateTime:
        return FieldDateTime(
          labelText: '${context.localizeLabel(jFieldMapping.title)}',
          isActionEnabled: jFieldMapping.operations!.design.checkU,
          initialDate: jFieldEntity?.value?.dateTimeValue,
          onChanged: (date) => context.read<OpenTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity!.guid!,
                  fieldValue: date,
                ),
              ),
          focusNode: FocusNode(),
        );
      case FieldType.File:
      case FieldType.StepResult:
      case FieldType.InternalStep:
      case FieldType.unknown:
      case FieldType.LinkToEntities:
        return const Stack();
    }
  }

  Widget submitTicket({
    required BuildContext context,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              focusNode: FocusNode(),
              onPressed: () =>
                  context.read<OpenTicketBloc>().add(SubmitTicket()),
              child: Text(context.l.ticket_btn_submit),
            ),
          ),
        ],
      );
}
