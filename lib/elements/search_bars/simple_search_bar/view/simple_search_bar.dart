import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/search_bars/simple_search_bar/bloc/simple_search_bar_bloc.dart';

/// Generic input text field
class OMDKSearchBar extends StatelessWidget {
  /// Create [OMDKSearchBar] instance
  const OMDKSearchBar({
    required this.isEnabled,
    super.key,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
  });

  /// Enable or not widget
  final bool isEnabled;

  /// If needed, you can provide focus node
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SimpleSearchBarBloc(),
      child: _OMDKSearchBar(
        focusNode: focusNode,
        onTap: onTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _OMDKSearchBar extends StatefulWidget {
  const _OMDKSearchBar({
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
  });

  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  @override
  State<_OMDKSearchBar> createState() => _OMDKSearchBarState();
}

class _OMDKSearchBarState extends State<_OMDKSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimpleSearchBarBloc, SimpleSearchBarState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Opacity(
            opacity: !state.isEnabled ? 0.5 : 1,
            child: AbsorbPointer(
              absorbing: !state.isEnabled,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 24,
                  right: 5,
                ),
                child: CupertinoSearchTextField(
                  controller: _controller,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusNode: widget.focusNode,
                  onTap: widget.onTap,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    size: 22,
                  ),
                  suffixIcon: const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
