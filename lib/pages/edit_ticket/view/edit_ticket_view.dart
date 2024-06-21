part of 'edit_ticket_page.dart';

/// Login form class provide all required field to login
class _EditTicketView extends StatefulWidget {
  /// Build [_EditTicketView] instance
  const _EditTicketView({
    required this.closePage,
  });

  final bool closePage;

  @override
  State<_EditTicketView> createState() => _OpenTicketViewState();
}

class _OpenTicketViewState extends State<_EditTicketView> {
  final _controllerKeyboard = TextEditingController();

  final blocKeyboard = VirtualKeyboardBloc();
  final blocName = SimpleTextBloc();
  final blocDesc = SimpleTextBloc();
  final cubitPriority = MrbCubit();

  final focusKeyboard = FocusNode();

  @override
  void dispose() {
    super.dispose();
    focusKeyboard.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late SimpleTextBloc activeBloc;
    return OMDKSimplePage(
      withBottomBar: false,
      withDrawer: false,
      leading: OMDKElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.red),
        ),
        focusNode: FocusNode(),
        onPressed: () {
          context.read<AuthRepo>().logOut();
          if (widget.closePage && kIsWeb) {
            return web.window.close();
          }
        },
        child: Text(
          AppLocalizations.of(context)!.alert_btn_cancel,
          style: TextStyle(
            color: context.theme?.buttonTheme.colorScheme?.onSurface,
          ),
        ),
      ),
      bodyPage: BlocListener<EditTicketBloc, EditTicketState>(
        // listenWhen: (previous, current) =>
        //     previous.loadingStatus != current.loadingStatus ||
        //     previous.activeFieldBloc != current.activeFieldBloc,
        listener: (context, state) {
          if (state.loadingStatus == LoadingStatus.failure) {
            OMDKAlert.show(
              context,
              OMDKAlert(
                title: AppLocalizations.of(context)!.alert_title_warning,
                type: AlertType.warning,
                message: Text(
                  '${state.failureText}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                confirm: AppLocalizations.of(context)!.alert_btn_ok,
                onConfirm: () =>
                    context.read<EditTicketBloc>().add(ResetWarning()),
              ),
            );
          }
          if (state.loadingStatus == LoadingStatus.done) {
            if (widget.closePage && kIsWeb) {
              context.read<AuthRepo>().logOut();
              return web.window.close();
            }
            OMDKAlert.show(
              context,
              OMDKAlert(
                title: AppLocalizations.of(context)!.alert_title_done,
                type: AlertType.success,
                message: Text(
                  '${state.failureText}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                confirm: AppLocalizations.of(context)!.alert_btn_ok,
                onConfirm: () => context.read<AuthRepo>().logOut(),
              ),
            );
          }
          if (state.activeFieldBloc != null) {
            activeBloc = state.activeFieldBloc!;
          }
          if (state.loadingStatus == LoadingStatus.fatal &&
              state.ticketEntity?.scheduled?.state == ActivityState.Scheduled) {
            OMDKAlert.show(
              context,
              OMDKAlert(
                title: AppLocalizations.of(context)!
                    .ticket_btn_alert_execute_title,
                message: Text(
                  AppLocalizations.of(context)!.ticket_btn_alert_execute_msg,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                type: AlertType.info,
                confirm: AppLocalizations.of(context)!.ticket_btn_execute,
                onConfirm: () => context.read<EditTicketBloc>().add(
                      ExecuteTicket(
                        guid: Uri.base.queryParameters['guid']!,
                      ),
                    ),
                close: AppLocalizations.of(context)!.alert_btn_cancel,
                onClose: () {
                  context.read<AuthRepo>().logOut();
                  if (widget.closePage && kIsWeb) {
                    return web.window.close();
                  }
                },
              ),
            );
          }
        },
        child: BlocBuilder<EditTicketBloc, EditTicketState>(
          builder: (context, state) => (context
                          .read<EditTicketBloc>()
                          .state
                          .loadingStatus ==
                      LoadingStatus.fatal &&
                  context
                          .read<EditTicketBloc>()
                          .state
                          .ticketEntity
                          ?.scheduled
                          ?.state !=
                      ActivityState.Scheduled)
              ? Center(
                  child: OMDKAlert(
                    title:
                        AppLocalizations.of(context)!.alert_title_fatal_error,
                    message: Text(
                      '${context.read<EditTicketBloc>().state.failureText}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    type: AlertType.fatalError,
                    confirm: AppLocalizations.of(context)!.alert_btn_ok,
                    onConfirm: () {},
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20, left: 14, right: 14),
                  child: Column(
                    children: [
                      Expanded(
                        child: (ResponsiveWidget.isSmallScreen(context))
                            ? singleColumnLayout(context)
                            : Center(
                                child: twoColumnLayout(context, blocKeyboard),
                              ),
                      ),
                      CustomVirtualKeyboard(
                        bloc: blocKeyboard,
                        focusNode: focusKeyboard,
                        controller: _controllerKeyboard,
                        onKeyPress: (key) => _onKeyPress(
                          context,
                          key,
                          activeBloc,
                          blocKeyboard,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _onKeyPress(
    BuildContext context,
    VirtualKeyboardKey key,
    SimpleTextBloc bloc,
    VirtualKeyboardBloc keyboardBloc,
  ) {
    final text = bloc.state.text ?? '';
    final arrayText =
        List<String>.generate(text.length, (index) => text[index]);

    if (key.keyType == VirtualKeyboardKeyType.String) {
      arrayText.insert(
        bloc.state.cursorPosition,
        (keyboardBloc.state.isShiftEnabled
            ? key.capsText.toString()
            : key.text.toString()),
      );
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.isEmpty) return;
          arrayText.removeAt(bloc.state.cursorPosition - 1);
          return bloc.add(
            TextChanged(arrayText.join(), bloc.state.cursorPosition - 1),
          );
        case VirtualKeyboardKeyAction.Return:
          arrayText.insert(
            bloc.state.cursorPosition,
            '\n',
          );
        case VirtualKeyboardKeyAction.Space:
          arrayText.insert(
            bloc.state.cursorPosition,
            key.text.toString(),
          );
        case VirtualKeyboardKeyAction.Shift:
          return keyboardBloc.add(ChangeShift());
        case VirtualKeyboardKeyAction.SwithLanguage:
        case null:
          break;
      }
    }
    bloc.add(TextChanged(arrayText.join(), bloc.state.cursorPosition + 1));
  }

  Widget twoColumnLayout(
    BuildContext context,
    VirtualKeyboardBloc keyboardBloc,
  ) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ListView(
              children: [
                _TicketNameInput(keyboardBloc: blocKeyboard),
                _TicketDescInput(keyboardBloc: blocKeyboard),
                const _TicketPriorityInput(),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _TicketStepList(keyboardBloc: blocKeyboard),
          ),
        ),
      ],
    );
  }

  Widget singleColumnLayout(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            _TicketNameInput(keyboardBloc: blocKeyboard),
            _TicketDescInput(keyboardBloc: blocKeyboard),
            const _TicketPriorityInput(),
            _TicketStepList(keyboardBloc: blocKeyboard),
          ],
        ),
      );
}

class _TicketNameInput extends StatelessWidget {
  /// Create [_TicketNameInput] instance
  const _TicketNameInput({required this.keyboardBloc});

  final VirtualKeyboardBloc keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTicketBloc, EditTicketState>(
      buildWhen: (previous, current) =>
          previous.ticketEntity?.entity?.name !=
          current.ticketEntity?.entity?.name,
      builder: (context, state) => (state.ticketEntity != null)
          ? FieldString(
              key: const Key('ticketNameInput_textField'),
              keyboardBloc: keyboardBloc,
              onChanged: (text) =>
                  context.read<EditTicketBloc>().add(TicketNameChanged(text)),
              labelText: AppLocalizations.of(context)!.ticket_label_name,
              onTapBloc: (bloc) =>
                  context.read<EditTicketBloc>().add(TicketEditing(bloc: bloc)),
              initialText: state.ticketEntity?.scheduled?.name,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _TicketDescInput extends StatelessWidget {
  /// Create [_TicketDescInput] instance
  const _TicketDescInput({required this.keyboardBloc});

  final VirtualKeyboardBloc keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTicketBloc, EditTicketState>(
      buildWhen: (previous, current) =>
          previous.ticketEntity?.scheduled?.description !=
          current.ticketEntity?.scheduled?.description,
      builder: (context, state) => (state.ticketEntity != null)
          ? FieldString(
              key: const Key('ticketDescInput_textField'),
              keyboardBloc: keyboardBloc,
              onChanged: (text) =>
                  context.read<EditTicketBloc>().add(TicketDescChanged(text)),
              labelText: AppLocalizations.of(context)!.ticket_label_description,
              onTapBloc: (bloc) =>
                  context.read<EditTicketBloc>().add(TicketEditing(bloc: bloc)),
              initialText: state.ticketEntity?.scheduled?.description,
            )
          : Container(),
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
          ? MultiRadioButtons(
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

  final VirtualKeyboardBloc? keyboardBloc;

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
                        '${(state.ticketEntity!.stepsList[index].title?.singleWhereOrNull(
                              (element) =>
                                  element.culture?.contains(
                                    Localizations.localeOf(context)
                                        .languageCode,
                                  ) ??
                                  false,
                            ) ?? state.ticketEntity!.stepsList[index].title?[0])?.value}',
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
    VirtualKeyboardBloc? keyboardBloc,
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
    VirtualKeyboardBloc? keyboardBloc,
    List<JResultState>? finalStateList,
  }) {
    switch (jFieldMapping.type) {
      case FieldType.String:
        switch (jFieldMapping.collectionType) {
          case CollectionType.List:
            return FieldPoolList(
              labelText: '${(jFieldMapping.title?.singleWhereOrNull(
                    (element) =>
                        element.culture?.contains(
                          Localizations.localeOf(context).languageCode,
                        ) ??
                        false,
                  ) ?? jFieldMapping.title?[0])?.value}',
              listItem: jFieldMapping.poolListSettings!.value!,
              isEnabled:
                  jFieldEntity!.operations!.execution!.values!.contains('U'),
              onChanged: (String? s) => context.read<EditTicketBloc>().add(
                    FieldChanged(
                      stepGuid: stepGuid,
                      fieldMapping: jFieldMapping,
                      fieldGuid: jFieldEntity.guid!,
                      fieldValue: <String>[s!],
                    ),
                  ),
            );
          case CollectionType.Single:
            if (jFieldMapping.poolListSettings?.value != null) {
              return FieldPoolList(
                selectedItem: jFieldEntity?.value?.stringsList?.first,
                labelText: '${(jFieldMapping.title?.singleWhereOrNull(
                      (element) =>
                          element.culture?.contains(
                            Localizations.localeOf(context).languageCode,
                          ) ??
                          false,
                    ) ?? jFieldMapping.title?[0])?.value}',
                isEnabled:
                    jFieldEntity!.operations!.execution!.values!.contains('U'),
                listItem: jFieldMapping.poolListSettings!.value!,
                onChanged: (String? s) => context.read<EditTicketBloc>().add(
                      FieldChanged(
                        stepGuid: stepGuid,
                        fieldMapping: jFieldMapping,
                        fieldGuid: jFieldEntity.guid!,
                        fieldValue: <String>[s!],
                      ),
                    ),
              );
            } else if (jFieldMapping.poolListSettings?.multiSelect ?? false) {
              return FieldMultiPoolList(
                labelText: '${(jFieldMapping.title?.singleWhereOrNull(
                      (element) =>
                          element.culture?.contains(
                            Localizations.localeOf(context).languageCode,
                          ) ??
                          false,
                    ) ?? jFieldMapping.title?[0])?.value}',
                isEnabled:
                    jFieldEntity!.operations!.execution!.values!.contains('U'),
                listItem: jFieldMapping.poolListSettings!.value!,
                onSelected: (List<PoolItem?> selectedItems) {},
              );
            } else {
              return FieldString(
                labelText: '${(jFieldMapping.title?.singleWhereOrNull(
                      (element) =>
                          element.culture?.contains(
                            Localizations.localeOf(context).languageCode,
                          ) ??
                          false,
                    ) ?? jFieldMapping.title?[0])?.value}',
                initialText: jFieldEntity?.value?.stringValue,
                isEnabled:
                    jFieldEntity!.operations!.execution!.values!.contains('U'),
                keyboardBloc: keyboardBloc,
                onTapBloc: (bloc) => context
                    .read<EditTicketBloc>()
                    .add(TicketEditing(bloc: bloc)),
                onChanged: (String? s) => context.read<EditTicketBloc>().add(
                      FieldChanged(
                        stepGuid: stepGuid,
                        fieldMapping: jFieldMapping,
                        fieldGuid: jFieldEntity.guid!,
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
        return FieldImage(
          labelText: '${(jFieldMapping.title?.singleWhereOrNull(
                (element) =>
                    element.culture?.contains(
                      Localizations.localeOf(context).languageCode,
                    ) ??
                    false,
              ) ?? jFieldMapping.title?[0])?.value}',
          imageGuid: jFieldEntity?.value?.imagesList?.first,
        );
      case FieldType.Double:
        return FieldDouble(
          labelText: '${(jFieldMapping.title?.singleWhereOrNull(
                (element) =>
                    element.culture?.contains(
                      Localizations.localeOf(context).languageCode,
                    ) ??
                    false,
              ) ?? jFieldMapping.title?[0])?.value}',
          keyboardBloc: keyboardBloc,
          onTapBloc: (bloc) =>
              context.read<EditTicketBloc>().add(TicketEditing(bloc: bloc)),
          isEnabled: jFieldEntity!.operations!.execution!.values!.contains('U'),
          onChanged: (double? d) => context.read<EditTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity.guid!,
                  fieldValue: d,
                ),
              ),
        );
      case FieldType.Int32:
        return FieldInt(
          labelText: '${(jFieldMapping.title?.singleWhereOrNull(
                (element) =>
                    element.culture?.contains(
                      Localizations.localeOf(context).languageCode,
                    ) ??
                    false,
              ) ?? jFieldMapping.title?[0])?.value}',
          keyboardBloc: keyboardBloc,
          isEnabled: jFieldEntity!.operations!.execution!.values!.contains('U'),
          onTapBloc: (bloc) =>
              context.read<EditTicketBloc>().add(TicketEditing(bloc: bloc)),
          onChanged: (int? i) => context.read<EditTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity.guid!,
                  fieldValue: i,
                ),
              ),
        );
      case FieldType.Datetime:
        return Container();
      case FieldType.Bool:
        return FieldBool(
          labelText: '${(jFieldMapping.title?.singleWhereOrNull(
                (element) =>
                    element.culture?.contains(
                      Localizations.localeOf(context).languageCode,
                    ) ??
                    false,
              ) ?? jFieldMapping.title?[0])?.value}',
          isEnabled: jFieldEntity!.operations!.execution!.values!.contains('U'),
          onChanged: (bool? b) => context.read<EditTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity.guid!,
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
                  fieldGuid: jFieldEntity.guid!,
                  fieldValue: j!.value,
                ),
              ),
          isEnabled: jFieldEntity!.operations!.execution!.values!.contains('U'),
          listItem: finalStateList ?? [],
          labelText: '${(jFieldMapping.title?.singleWhereOrNull(
                (element) =>
                    element.culture?.contains(
                      Localizations.localeOf(context).languageCode,
                    ) ??
                    false,
              ) ?? jFieldMapping.title?[0])?.value}',
        );
      case FieldType.File:
      case FieldType.InternalStep:
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
            child: OMDKOutlinedButton(
              focusNode: FocusNode(),
              onPressed: () =>
                  context.read<EditTicketBloc>().add(SubmitTicket()),
              child: Text(
                AppLocalizations.of(context)!.ticket_btn_submit,
                style: TextStyle(color: context.theme?.colorScheme.onSurface),
              ),
            ),
          ),
        ],
      );
}
