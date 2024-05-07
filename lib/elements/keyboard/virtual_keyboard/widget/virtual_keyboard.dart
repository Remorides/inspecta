import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk/elements/keyboard/virtual_keyboard/bloc/virtual_keyboard_bloc.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class CustomVirtualKeyboard extends StatefulWidget {
  /// Create [CustomVirtualKeyboard] instance
  const CustomVirtualKeyboard({
    required this.bloc,
    required this.focusNode,
    required this.controller,
    required this.onKeyPress,
    super.key,
    this.visible = false,
  });

  final bool visible;
  final VirtualKeyboardBloc bloc;
  final FocusNode focusNode;
  final TextEditingController controller;
  final void Function(VirtualKeyboardKey) onKeyPress;

  @override
  State<CustomVirtualKeyboard> createState() => _CustomVirtualKeyboardState();
}

class _CustomVirtualKeyboardState extends State<CustomVirtualKeyboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VirtualKeyboardBloc>(
      create: (context) => widget.bloc,
      child: BlocBuilder<VirtualKeyboardBloc, VirtualKeyboardState>(
        bloc: widget.bloc,
        builder: (context, state) {
          return state.isVisible
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(
                              color: Colors.red,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: IconButton(
                            onPressed: () => context
                                .read<VirtualKeyboardBloc>()
                                .add(ChangeVisibility()),
                            icon: const Icon(
                              Icons.close_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    VirtualKeyboard(
                      textController: widget.controller,
                      defaultLayouts: const <VirtualKeyboardDefaultLayouts>[
                        VirtualKeyboardDefaultLayouts.English,
                      ],
                      //reverseLayout :true,
                      type: state.keyboardType,
                      onKeyPress: widget.onKeyPress,
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }
}
