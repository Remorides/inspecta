part of 'open_ticket_page.dart';

/// Login form class provide all required field to login
class _OpenTicketView extends StatelessWidget {
  /// Build [_OpenTicketView] instance
  _OpenTicketView();

  final blocAssetReference = SimpleTextBloc();
  final blocName = SimpleTextBloc();
  final blocDesc = SimpleTextBloc();

  final focusName = FocusNode();
  final focusDesc = FocusNode();

  @override
  Widget build(BuildContext context) {
    return OMDKAnimatedPage(
      withAppBar: false,
      withBottomBar: false,
      withDrawer: false,
      focusNodeList: [],
      bodyPage: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ResponsiveWidget.isSmallScreen(context)
            ? singleColumnLayout(context)
            : Center(
                child: twoColumnLayout(context),
              ),
      ),
    );
  }

  Widget twoColumnLayout(BuildContext context) => Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: [
                _AssetReference(bloc: blocAssetReference),
                const Space.vertical(20),
                _TicketNameInput(
                  widgetFN: focusName,
                  widgetB: blocName,
                  nextWidgetFN: focusDesc,
                ),
                const Space.vertical(20),
                _TicketDescInput(
                  widgetFN: focusDesc,
                  widgetB: blocDesc,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 200,
                ),
              ],
            ),
          ),
        ],
      );

  Widget singleColumnLayout(BuildContext context) => ListView();
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
      listenWhen: (previous, current){
        return current.loadingStatus == LoadingStatus.done &&
            current.jMainNode != null;
      },
      listener: (context, state) {
        if(state.jMainNode?.name != null){
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
    this.nextWidgetFN,
  });

  final FocusNode widgetFN;
  final SimpleTextBloc widgetB;
  final FocusNode? nextWidgetFN;

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
    this.nextWidgetFN,
  });

  final FocusNode widgetFN;
  final SimpleTextBloc widgetB;
  final FocusNode? nextWidgetFN;

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
        );
      },
    );
  }
}
