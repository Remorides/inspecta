part of 'open_ticket_page.dart';

/// Login form class provide all required field to login
class _OpenTicketView extends StatefulWidget {
  /// Build [_OpenTicketView] instance
  const _OpenTicketView();

  @override
  State<_OpenTicketView> createState() => _OpenTicketViewState();
}

class _OpenTicketViewState extends State<_OpenTicketView> {
  final _controllerKeyboard = TextEditingController();

  final blocKeyboard = VirtualKeyboardBloc();

  final Map<String, SimpleTextBloc> mapBlock = <String, SimpleTextBloc>{
    'blocAssetReference': SimpleTextBloc(),
    'blocName': SimpleTextBloc(),
    'blocDesc': SimpleTextBloc(),
    'blocPriority': SimpleTextBloc(),
  };

  final Map<String, FocusNode> mapFocusNode = <String, FocusNode>{
    'focusKeyboard': FocusNode(),
    'focusName': FocusNode(),
    'focusDesc': FocusNode(),
    'focusPriority': FocusNode(),
  };

  @override
  void dispose() {
    super.dispose();
    mapFocusNode.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    late SimpleTextBloc activeBloc;
    return OMDKAnimatedPage(
      withAppBar: false,
      withBottomBar: false,
      withDrawer: false,
      bodyPage: BlocListener<OpenTicketBloc, OpenTicketState>(
        listenWhen: (previous, current) =>
            previous.activeFieldBloc != current.activeFieldBloc,
        listener: (context, state) {
          if (state.activeFieldBloc != null) {
            activeBloc = state.activeFieldBloc!;
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Expanded(
                child: (ResponsiveWidget.isSmallScreen(context))
                    ? singleColumnLayout(context)
                    : Center(child: twoColumnLayout(context, blocKeyboard)),
              ),
              CustomVirtualKeyboard(
                bloc: blocKeyboard,
                focusNode: mapFocusNode['focusKeyboard']!,
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
    );
  }

  void _onKeyPress(
    BuildContext context,
    VirtualKeyboardKey key,
    SimpleTextBloc bloc,
    VirtualKeyboardBloc keyboardBloc,
  ) {
    var text = bloc.state.text ?? '';
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text +
          (keyboardBloc.state.isShiftEnabled
              ? key.capsText.toString()
              : key.text.toString());
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.isEmpty) return;
          text = text.substring(0, text.length - 1);
        case VirtualKeyboardKeyAction.Return:
          text = '$text\n';
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text.toString();
        case VirtualKeyboardKeyAction.Shift:
          keyboardBloc.add(ChangeShift());
        case VirtualKeyboardKeyAction.SwithLanguage:
        case null:
          break;
      }
    }
    bloc.add(TextChanged(text));
  }

  Widget twoColumnLayout(
    BuildContext context,
    VirtualKeyboardBloc keyboardBloc,
  ) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ListView(
            children: [
              _AssetReference(
                bloc: mapBlock['blocAssetReference']!,
              ),
              const Space.vertical(20),
              _TicketNameInput(
                keyboardBloc: blocKeyboard,
                widgetFN: mapFocusNode['focusName']!,
                widgetB: mapBlock['blocName']!,
                nextWidgetFN: mapFocusNode['focusDesc'],
              ),
              const Space.vertical(20),
              _TicketDescInput(
                keyboardBloc: blocKeyboard,
                widgetFN: mapFocusNode['focusDesc']!,
                widgetB: mapBlock['blocDesc']!,
                nextWidgetFN: mapFocusNode['focusPriority'],
              ),
              const Space.vertical(20),
              _TicketPriorityInput(
                widgetFN: mapFocusNode['focusPriority']!,
              ),
              const Space.vertical(20),
              const _TicketSchemaInput(),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: _TicketStepList(keyboardBloc: blocKeyboard),
          ),
        ),
      ],
    );
  }

  Widget singleColumnLayout(BuildContext context) => ListView(
        children: [
          _AssetReference(
            bloc: mapBlock['blocAssetReference']!,
          ),
          const Space.vertical(20),
          _TicketNameInput(
            keyboardBloc: blocKeyboard,
            widgetFN: mapFocusNode['focusName']!,
            widgetB: mapBlock['blocName']!,
            nextWidgetFN: mapFocusNode['focusDesc'],
          ),
          const Space.vertical(20),
          _TicketDescInput(
            keyboardBloc: blocKeyboard,
            widgetFN: mapFocusNode['focusDesc']!,
            widgetB: mapBlock['blocDesc']!,
            nextWidgetFN: mapFocusNode['focusPriority'],
          ),
          const Space.vertical(20),
          _TicketPriorityInput(
            widgetFN: mapFocusNode['focusPriority']!,
          ),
        ],
      );
}

class _AssetReference extends StatelessWidget {
  /// Create [_AssetReference] instance
  const _AssetReference({
    required this.bloc,
  });

  final SimpleTextBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OpenTicketBloc, OpenTicketState>(
      listenWhen: (previous, current) {
        return current.loadingStatus == LoadingStatus.done &&
            previous.jMainNode != current.jMainNode;
      },
      listener: (context, state) {
        if (state.jMainNode?.name != null) {
          bloc.add(TextChanged(state.jMainNode!.name!));
        }
      },
      child: SimpleTextField(
        key: const Key('assetReference_textField'),
        simpleTextBloc: bloc,
        enabled: false,
        onEditingComplete: (text) {},
        labelText: 'Asset reference',
        textFocusNode: FocusNode(),
      ),
    );
  }
}

class _TicketNameInput extends StatelessWidget {
  /// Create [_TicketNameInput] instance
  const _TicketNameInput({
    required this.widgetFN,
    required this.widgetB,
    required this.keyboardBloc,
    this.nextWidgetFN,
  });

  final FocusNode widgetFN;
  final SimpleTextBloc widgetB;
  final FocusNode? nextWidgetFN;
  final VirtualKeyboardBloc keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTicketBloc, OpenTicketState>(
      builder: (context, state) {
        return SimpleTextField(
          key: const Key('ticketNameInput_textField'),
          simpleTextBloc: widgetB,
          onEditingComplete: (text) =>
              context.read<OpenTicketBloc>().add(TicketNameChanged(text)),
          labelText: 'Name',
          textFocusNode: widgetFN,
          nextFocusNode: nextWidgetFN,
          onTap: () {
            context.read<OpenTicketBloc>().add(TicketEditing(bloc: widgetB));
            keyboardBloc
              ..add(ChangeType())
              ..add(ChangeVisibility(isVisibile: true));
          },
        );
      },
    );
  }
}

class _TicketDescInput extends StatelessWidget {
  /// Create [_TicketDescInput] instance
  const _TicketDescInput({
    required this.widgetFN,
    required this.widgetB,
    required this.keyboardBloc,
    this.nextWidgetFN,
  });

  final FocusNode widgetFN;
  final SimpleTextBloc widgetB;
  final FocusNode? nextWidgetFN;
  final VirtualKeyboardBloc keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTicketBloc, OpenTicketState>(
      builder: (context, state) {
        return SimpleTextField(
          key: const Key('ticketDescInput_textField'),
          simpleTextBloc: widgetB,
          onEditingComplete: (text) =>
              context.read<OpenTicketBloc>().add(TicketDescChanged(text)),
          labelText: 'Description',
          textFocusNode: widgetFN,
          nextFocusNode: nextWidgetFN,
          onTap: () {
            context.read<OpenTicketBloc>().add(TicketEditing(bloc: widgetB));
            keyboardBloc
              ..add(ChangeType())
              ..add(ChangeVisibility(isVisibile: true));
          },
        );
      },
    );
  }
}

class _TicketPriorityInput extends StatelessWidget {
  /// Create [_TicketPriorityInput] instance
  const _TicketPriorityInput({
    required this.widgetFN,
  });

  final FocusNode widgetFN;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTicketBloc, OpenTicketState>(
      builder: (context, state) {
        return MultiRadioButtons(
          key: const Key('ticketPriorityInput_textField'),
          onSelectedPriority: (text) =>
              context.read<OpenTicketBloc>().add(TicketPriorityChanged(text)),
          labelText: 'Priority',
          focusNode: widgetFN,
        );
      },
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
        return SizedBox(
          height: 213,
          child: Stack(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Typology',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.theme?.inputDecorationTheme.labelStyle,
                    ),
                  ),
                ],
              ),
              Opacity(
                opacity: 1,
                child: Container(
                  margin: const EdgeInsets.only(top: 22),
                  child: ListView.builder(
                    itemCount: state.schemas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: (index == state.selectedSchemaIndex)
                              ? context.theme?.primaryColor
                              : Colors.transparent,
                        ),
                        child: ListTile(
                          selected: index == state.selectedSchemaIndex,
                          selectedColor: Colors.white,
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
                            style: (index == state.selectedSchemaIndex)
                                ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )
                                : const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
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

  final VirtualKeyboardBloc? keyboardBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTicketBloc, OpenTicketState>(
      buildWhen: (previous, current) =>
          previous.loadingStatus != current.loadingStatus,
      builder: (context, state) {
        return (state.ticketEntity != null)
            ? ListView.builder(
                itemCount: state.ticketEntity?.stepsList.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    initiallyExpanded: index == 0,
                    title: Text(
                      state.ticketEntity!.stepsList[index].title![0].value!,
                    ),
                    children: buildFieldList(
                      context: context,
                      stepEntity: state.ticketEntity!.stepsList[index],
                      schemaMapping: state.schemaMapping!,
                      keyboardBloc: keyboardBloc,
                    ),
                  );
                },
              )
            : const Center(
                child: Text('Choose a type to generate step list'),
              );
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
    return fieldWidgets;
  }

  Widget buildField({
    required BuildContext context,
    required JFieldMapping jFieldMapping,
    required String stepGuid,
    JFieldEntity? jFieldEntity,
    VirtualKeyboardBloc? keyboardBloc,
  }) {
    switch (jFieldMapping.type) {
      case FieldType.String:
        switch (jFieldMapping.collectionType) {
          case CollectionType.List:
            return FieldPoolList(
              labelText: '${jFieldMapping.title?[0].value}',
              listItem: jFieldMapping.poolListSettings!.value!,
              onChanged: (String? s) {},
            );
          case CollectionType.Single:
            if (jFieldMapping.poolListSettings?.value != null) {
              return FieldPoolList(
                selectedItem: jFieldEntity?.value?.stringsList?.first,
                labelText: '${jFieldMapping.title?[0].value}',
                listItem: jFieldMapping.poolListSettings!.value!,
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
                labelText: '${jFieldMapping.title?[0].value}',
                listItem: jFieldMapping.poolListSettings!.value!,
                focusNode: FocusNode(),
                onSelected: (List<PoolItem?> selectedItems) {},
              );
            } else {
              return FieldString(
                labelText: '${jFieldMapping.title?[0].value}',
                keyboardBloc: keyboardBloc,
                pageBloc: context.read<OpenTicketBloc>(),
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
            return Container();
        }
      case FieldType.Image:
        return Container();
      case FieldType.Double:
        return FieldDouble(
          labelText: '${jFieldMapping.title?[0].value}',
          keyboardBloc: keyboardBloc,
          pageBloc: context.read<OpenTicketBloc>(),
          focusNode: FocusNode(),
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
          labelText: '${jFieldMapping.title?[0].value}',
          focusNode: FocusNode(),
          keyboardBloc: keyboardBloc,
          pageBloc: context.read<OpenTicketBloc>(),
          onChanged: (int? i) => context.read<OpenTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity!.guid!,
                  fieldValue: i,
                ),
              ),
        );
      case FieldType.Datetime:
        return Container();
      case FieldType.Bool:
        return FieldBool(
          labelText: '${jFieldMapping.title?[0].value}',
          focusNode: FocusNode(),
          onChanged: (bool? b) => context.read<OpenTicketBloc>().add(
                FieldChanged(
                  stepGuid: stepGuid,
                  fieldMapping: jFieldMapping,
                  fieldGuid: jFieldEntity!.guid!,
                  fieldValue: b,
                ),
              ),
        );
      case FieldType.File:
      case FieldType.StepResult:
      case FieldType.InternalStep:
      case FieldType.unknown:
        return Container();
    }
  }
}
