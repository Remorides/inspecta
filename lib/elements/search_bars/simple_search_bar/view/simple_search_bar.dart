import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/elements.dart';

/// Generic input text field
class OMDKSearchBar extends StatefulWidget {
  /// Create [OMDKSearchBar] instance
  const OMDKSearchBar({
    required this.isEnabled,
    super.key,
    this.focusNode,
    this.onTap,
    this.onSuffixTap,
    this.onChanged,
    this.onSubmitted,
    this.bloc,
  });

  /// Enable or not widget
  final bool isEnabled;

  /// If needed, you can provide focus node
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function()? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final SimpleSearchBarBloc? bloc;

  @override
  State<OMDKSearchBar> createState() => _OMDKSearchBarState();
}

class _OMDKSearchBarState extends State<OMDKSearchBar> {
  late SimpleSearchBarBloc widgetBloc;

  @override
  void initState() {
    super.initState();
    widgetBloc = widget.bloc ?? SimpleSearchBarBloc();
  }

  @override
  Widget build(BuildContext context) {
    return widget.bloc != null
        ? BlocProvider.value(value: widget.bloc!, child: _child)
        : BlocProvider(
            create: (context) => SimpleSearchBarBloc(),
            child: _child,
          );
  }

  Widget get _child => _OMDKSearchBarWidget(
        bloc: widgetBloc,
        focusNode: widget.focusNode,
        onTap: widget.onTap,
        onSuffixTap: widget.onSuffixTap,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        searchText: widgetBloc.state.searchText,
      );
}

class _OMDKSearchBarWidget extends StatefulWidget {
  const _OMDKSearchBarWidget({
    required this.bloc,
    this.focusNode,
    this.onTap,
    this.onSuffixTap,
    this.onChanged,
    this.onSubmitted,
    this.searchText,
  });

  final SimpleSearchBarBloc bloc;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function()? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? searchText;

  @override
  State<_OMDKSearchBarWidget> createState() => _OMDKSearchBarWidgetState();
}

class _OMDKSearchBarWidgetState extends State<_OMDKSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  int _cursorPosition = 0;

  @override
  void initState() {
    super.initState();
    _controller
      ..text = widget.searchText ?? ''
      ..addListener(() {
        _cursorPosition = _controller.selection.baseOffset;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SimpleSearchBarBloc, SimpleSearchBarState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (mounted) {
          _controller.value = TextEditingValue(
            text: state.searchText,
            selection: TextSelection.fromPosition(
              TextPosition(offset: _cursorPosition),
            ),
          );
        }
      },
      builder: (context, state) => Card(
        elevation: 0,
        child: Row(
          children: [
            Expanded(
              child: CupertinoSearchTextField(
                enabled: state.isEnabled,
                controller: _controller,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                onTap: widget.onTap,
                onChanged: (s) {
                  widget.onChanged?.call(s);
                  widget.bloc.add(NewSearch(s));
                },
                onSubmitted: (s) {
                  widget.onSubmitted?.call(s);
                  widget.bloc.add(NewSearch(s));
                },
                onSuffixTap: () {
                  widget.bloc.add(const NewSearch(''));
                  widget.onSuffixTap?.call();
                },
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
