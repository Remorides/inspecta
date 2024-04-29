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
  Widget build(BuildContext context) {
    late SimpleTextBloc activeBloc;
    return OMDKAnimatedPage(
      withAppBar: false,
      withBottomBar: false,
      withDrawer: false,
      bodyPage: BlocListener<OpenTicketBloc, OpenTicketState>(
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
                    : Center(child: twoColumnLayout(context)),
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
    var text = bloc.state.initialText ?? '';
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
    bloc.add(InitialText(text));
  }

  Widget twoColumnLayout(BuildContext context) => Row(
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
            child: ListView(),
          ),
        ],
      );

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
            current.jMainNode != null;
      },
      listener: (context, state) {
        if (state.jMainNode?.name != null) {
          bloc.add(InitialText(state.jMainNode!.name!));
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
            keyboardBloc.add(ChangeVisibility(isVisibile: true));
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
            keyboardBloc.add(ChangeVisibility(isVisibile: true));
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
    this.cubit,
    this.nextWidgetFN,
  });

  final MrbCubit? cubit;
  final FocusNode widgetFN;
  final FocusNode? nextWidgetFN;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTicketBloc, OpenTicketState>(
      builder: (context, state) {
        return MultiRadioButtons(
          key: const Key('ticketPriorityInput_textField'),
          cubit: cubit,
          onSelectedPriority: (text) =>
              context.read<OpenTicketBloc>().add(TicketPriorityChanged(text)),
          labelText: 'Priority',
          focusNode: widgetFN,
          nextFocusNode: nextWidgetFN,
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
                          onTap: () => context
                              .read<OpenTicketBloc>()
                              .add(SelectedSchemaChanged(index)),
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
