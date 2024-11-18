import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class CustomVirtualKeyboard extends StatelessWidget {
  /// Create [CustomVirtualKeyboard] instance
  const CustomVirtualKeyboard({
    required this.cubit,
    required this.controller,
    required this.onKeyPress,
    super.key,
    this.visible = false,
  });

  final bool visible;
  final VirtualKeyboardCubit cubit;
  final TextEditingController controller;
  final void Function(VirtualKeyboardKey) onKeyPress;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VirtualKeyboardCubit, VirtualKeyboardState>(
      bloc: cubit,
      builder: (context, state) => state.isVisible
          ? Column(
              children: [
                Row(
                  children: [
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
                        onPressed: () => cubit.hiddenKeyboard(),
                        icon: const Icon(
                          Icons.close_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                VirtualKeyboard(
                  textController: controller,
                  defaultLayouts: const <VirtualKeyboardDefaultLayouts>[
                    VirtualKeyboardDefaultLayouts.English,
                  ],
                  //reverseLayout :true,
                  type: state.keyboardType,
                  postKeyPress: onKeyPress,
                  textColor: Theme.of(context).textTheme.labelLarge?.color ??
                      Colors.white,
                ),
              ],
            )
          : Container(),
    );
  }
}
