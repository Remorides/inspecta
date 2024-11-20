part of 'edit_ticket_page.dart';

/// Login form class provide all required field to login
class _EditTicketView extends StatelessWidget {
  /// Build [_EditTicketView] instance
  const _EditTicketView({
    required this.closePage,
  });

  final bool closePage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTicketBloc, EditTicketState>(
      listener: (context, state) {
        if (state.loadingStatus == LoadingStatus.failure) {
          OMDKAlert.show(context, _warningAlert(context, state.failureText));
        }
        if (state.loadingStatus == LoadingStatus.done) {
          if (closePage && kIsWeb) {
            context.read<AuthRepo>().logOut();
            return web.window.close();
          }
          OMDKAlert.show(context, _successAlert(context));
        }
        if (state.loadingStatus == LoadingStatus.fatal) {
          if (state.ticketEntity?.scheduled?.state == ActivityState.Scheduled) {
            OMDKAlert.show(context, _executeAlert(context));
          } else {
            OMDKAlert.show(context, _failureAlert(context, state.failureText));
          }
        }
      },
      child: OMDKSimplePage(
        withBottomBar: false,
        withDrawer: false,
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

  OMDKAlert _warningAlert(BuildContext context, String? warningText) =>
      OMDKAlert(
        title: AppLocalizations.of(context)!.alert_title_warning,
        type: AlertType.warning,
        message:
            Text('$warningText', style: const TextStyle(color: Colors.black)),
        confirm: AppLocalizations.of(context)!.alert_btn_ok,
        onConfirm: () => context.read<EditTicketBloc>().add(ResetWarning()),
      );

  OMDKAlert _successAlert(BuildContext context) => OMDKAlert(
        title: AppLocalizations.of(context)!.alert_title_done,
        type: AlertType.success,
        message: const Text('SUCCESSO', style: TextStyle(color: Colors.black)),
        confirm: AppLocalizations.of(context)!.alert_btn_ok,
        onConfirm: () => context.read<AuthRepo>().logOut(),
      );

  OMDKAlert _executeAlert(BuildContext context) => OMDKAlert(
        title: AppLocalizations.of(context)!.ticket_btn_alert_execute_title,
        message: Text(
          AppLocalizations.of(context)!.ticket_btn_alert_execute_msg,
          style: const TextStyle(color: Colors.black),
        ),
        type: AlertType.info,
        confirm: AppLocalizations.of(context)!.ticket_btn_execute,
        onConfirm: () => context.read<EditTicketBloc>().add(
              ExecuteTicket(guid: Uri.base.queryParameters['guid']!),
            ),
        close: AppLocalizations.of(context)!.alert_btn_cancel,
        onClose: () {
          context.read<AuthRepo>().logOut();
          if (closePage && kIsWeb) {
            return web.window.close();
          }
        },
      );

  OMDKAlert _failureAlert(BuildContext context, String? failureText) =>
      OMDKAlert(
        title: AppLocalizations.of(context)!.alert_title_fatal_error,
        message:
            Text('$failureText', style: const TextStyle(color: Colors.black)),
        type: AlertType.fatalError,
        confirm: context.l.alert_btn_ok,
        executePop: false,
        onConfirm: () {},
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
    showLoading();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditTicketBloc, EditTicketState>(
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
            const Space.vertical(15),
            _TicketDescInput(keyboardBloc: _keyboardCubit),
            const Space.vertical(15),
            const _TicketPriorityInput(),
            const Space.vertical(15),
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
                _TicketNameInput(keyboardBloc: _keyboardCubit),
                const Space.vertical(15),
                _TicketDescInput(keyboardBloc: _keyboardCubit),
                const Space.vertical(15),
                const _TicketPriorityInput(),
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

class _TicketNameInput extends StatelessWidget {
  /// Create [_TicketNameInput] instance
  const _TicketNameInput({required this.keyboardBloc});

  final VirtualKeyboardCubit keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTicketBloc, EditTicketState>(
      buildWhen: (previous, current) =>
          previous.ticketEntity?.entity.name !=
          current.ticketEntity?.entity.name,
      builder: (context, state) => (state.ticketEntity != null)
          ? FieldString(
              keyboardCubit: keyboardBloc,
              onChanged: (text) =>
                  context.read<EditTicketBloc>().add(TicketNameChanged(text)),
              labelText: AppLocalizations.of(context)!.ticket_label_name,
              onTapCubit: (bloc) =>
                  context.read<EditTicketBloc>().add(TicketEditing(bloc: bloc)),
              initialText: state.ticketEntity?.scheduled?.name,
            )
          : FieldString(
              isEnabled: false,
              labelText: AppLocalizations.of(context)!.ticket_label_name,
            ),
    );
  }
}

class _TicketDescInput extends StatelessWidget {
  /// Create [_TicketDescInput] instance
  const _TicketDescInput({required this.keyboardBloc});

  final VirtualKeyboardCubit keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTicketBloc, EditTicketState>(
      buildWhen: (previous, current) =>
          previous.ticketEntity?.scheduled?.description !=
          current.ticketEntity?.scheduled?.description,
      builder: (context, state) => (state.ticketEntity != null)
          ? FieldString(
              key: const Key('ticketDescInput_textField'),
              keyboardCubit: keyboardBloc,
              onChanged: (text) =>
                  context.read<EditTicketBloc>().add(TicketDescChanged(text)),
              labelText: AppLocalizations.of(context)!.ticket_label_description,
              onTapCubit: (bloc) =>
                  context.read<EditTicketBloc>().add(TicketEditing(bloc: bloc)),
              initialText: state.ticketEntity?.scheduled?.description,
            )
          : FieldString(
              isEnabled: false,
              labelText: AppLocalizations.of(context)!.ticket_label_description,
            ),
    );
  }
}

class _TicketPriorityInput extends StatelessWidget {
  /// Create [_TicketPriorityInput] instance
  const _TicketPriorityInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTicketBloc, EditTicketState>(
      buildWhen: (previous, current) =>
          previous.ticketEntity?.template?.urgencyCode !=
          current.ticketEntity?.template?.urgencyCode,
      builder: (context, state) => (state.ticketEntity?.template?.urgencyCode !=
              null)
          ? PriorityButtons(
              key: const Key('ticketPriorityInput_textField'),
              onSelectedPriority: (priorityCode) {
                context
                    .read<EditTicketBloc>()
                    .add(TicketPriorityChanged(priorityCode));
              },
              labelText: AppLocalizations.of(context)!.ticket_label_priority,
              indexSelectedRadio: state.ticketEntity?.template?.urgencyCode,
            )
          : Container(),
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
    return BlocBuilder<EditTicketBloc, EditTicketState>(
      buildWhen: (previous, current) =>
          current.ticketEntity != null && current.ticketMapping != null,
      builder: (context, state) {
        return (state.loadingStatus != LoadingStatus.initial)
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
                      initiallyExpanded: index == 0,
                      title: Text(
                        '${context.localizeLabel(state.ticketEntity!.stepsList[index].title)}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      children: buildFieldList(
                        context: context,
                        stepEntity: state.ticketEntity!.stepsList[index],
                        schemaMapping: state.ticketMapping!,
                        keyboardBloc: keyboardBloc,
                      ),
                    );
                  },
                ),
              )
            : Container();
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
      if (jFieldEntity!.operations!.execution!.values!.contains('R')) {
        fieldWidgets.add(
          buildField(
            context: context,
            jFieldMapping: jFieldMapping,
            jFieldEntity: jFieldEntity,
            stepGuid: stepEntity.guid!,
            keyboardBloc: keyboardBloc,
            finalStateList: schemaMapping.data.finalStateList,
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
    List<JResultState>? finalStateList,
  }) {
    switch (jFieldMapping.type) {
      case FieldType.String:
        switch (jFieldMapping.collectionType) {
          case CollectionType.List:
            return FieldPoolList(
              labelText: '${context.localizeLabel(jFieldMapping.title)}',
              listItem: jFieldMapping.poolListSettings!.value!,
              isEnabled: jFieldMapping.operations!.design.checkU,
              onChanged: (String? s) => context.read<EditTicketBloc>().add(
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
                isEnabled: jFieldMapping.operations!.design.checkU,
                listItem: jFieldMapping.poolListSettings!.value!,
                onChanged: (String? s) => context.read<EditTicketBloc>().add(
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
                isEnabled: jFieldMapping.operations!.design.checkU,
                listItem: jFieldMapping.poolListSettings!.value!,
                onSelected: (List<PoolItem?> selectedItems) {},
              );
            } else {
              return FieldString(
                labelText: '${context.localizeLabel(jFieldMapping.title)}',
                initialText: jFieldEntity?.value?.stringValue,
                isEnabled: jFieldMapping.operations!.design.checkU,
                keyboardCubit: keyboardBloc,
                onTapCubit: (bloc) => context
                    .read<EditTicketBloc>()
                    .add(TicketEditing(bloc: bloc)),
                onChanged: (String? s) => context.read<EditTicketBloc>().add(
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
            return Container();
        }
      case FieldType.Image:
        if (jFieldEntity?.value == null) return const Stack();
        return FieldSliderImages(
          labelText: '${context.localizeLabel(jFieldMapping.title)}',
          imageList: jFieldEntity?.value?.imagesList,
        );
      case FieldType.Double:
        return FieldDouble(
          labelText: '${context.localizeLabel(jFieldMapping.title)}',
          onTapCubit: (cubit) =>
              context.read<EditTicketBloc>().add(TicketEditing(bloc: cubit)),
          isEnabled: jFieldMapping.operations!.design.checkU,
          keyboardCubit: keyboardBloc,
          onChanged: (double? d) => context.read<EditTicketBloc>().add(
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
          onTapCubit: (cubit) =>
              context.read<EditTicketBloc>().add(TicketEditing(bloc: cubit)),
          keyboardCubit: keyboardBloc,
          onChanged: (int? i) => context.read<EditTicketBloc>().add(
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
          isEnabled: jFieldMapping.operations!.design.checkU,
          onChanged: (bool? b) => context.read<EditTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity!.guid!,
                  fieldValue: b,
                ),
              ),
        );
      case FieldType.StepResult:
        return FieldFinalState(
          selectedItem: finalStateList?.singleWhereOrNull(
            (f) => f.value == jFieldEntity?.value?.intValue,
          ),
          onChanged: (JResultState? j) => context.read<EditTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity!.guid!,
                  fieldValue: j!.value,
                ),
              ),
          isEnabled: jFieldMapping.operations!.design.checkU,
          listItem: finalStateList ?? [],
          labelText: '${context.localizeLabel(jFieldMapping.title)}',
          hintText: '',
        );
      case FieldType.DateTime:
        return FieldDateTime(
          labelText: '${context.localizeLabel(jFieldMapping.title)}',
          isActionEnabled: jFieldMapping.operations!.design.checkU,
          initialDate: jFieldEntity?.value?.dateTimeValue,
          onChanged: (date) => context.read<EditTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity!.guid!,
                  fieldValue: date,
                ),
              ),
        );
      case FieldType.File:
      case FieldType.InternalStep:
      case FieldType.LinkToEntities:
      case FieldType.unknown:
        return Container();
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
              onPressed: () =>
                  context.read<EditTicketBloc>().add(SubmitTicket()),
              child: Text(context.l.ticket_btn_submit),
            ),
          ),
        ],
      );
}
