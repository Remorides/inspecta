import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/elements.dart';

/// Generic input text field
class SimpleTextField extends StatelessWidget {
  /// Create [SimpleTextField] instance
  const SimpleTextField({
    required this.labelText,
    required this.textFocusNode,
    this.onSubmit,
    this.onChanged,
    this.simpleTextBloc,
    this.initialText = '',
    this.nextFocusNode,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.placeholder,
    this.isInputTextEnabled = true,
    this.isActionEnabled = true,
    this.isObscured = false,
    this.customBoxBorder,
    this.isEmptyAllowed = false,
    this.isTextValueNullable = false,
    this.onTap,
    this.onTapAction,
    this.onCursorPosition,
    this.onFocusChange,
    this.withBorder = false,
    this.withAction = false,
    this.autofocus = false,
    this.actionIcon,
    this.textAlign = TextAlign.start,
    this.fieldNote,
    super.key,
  });

  /// Optional param to allow user to create bloc externally
  final SimpleTextBloc? simpleTextBloc;

  /// Result function with input data
  final void Function(String?)? onChanged;

  final void Function(String?)? onSubmit;

  /// Manage on tap event
  final void Function()? onTap;

  /// Manage on change event (cursor position)
  final void Function(int)? onCursorPosition;

  /// Label text
  final String labelText;

  /// Focus node of current widget
  final FocusNode textFocusNode;

  /// If exist, pass next focus node to autofocus if on editing complete
  final FocusNode? nextFocusNode;

  /// initial text of widget
  final String initialText;

  /// Set input type of data with [TextInputType] enums
  final TextInputType keyboardType;

  /// If input data is text you can capitalize is
  final TextCapitalization textCapitalization;

  /// Specify special action on complete
  final TextInputAction textInputAction;

  /// Max allowed string lines
  final int maxLines;

  /// If exist, set widget placeholder
  final String? placeholder;

  /// Enable or not widget
  final bool isInputTextEnabled;

  /// Enable or not autofocus
  final bool autofocus;

  /// Enable or not action widget
  final bool isActionEnabled;

  /// Obscure text (like password)
  final bool isObscured;

  /// Allow nullable text value
  final bool isTextValueNullable;

  /// Allow empty text
  final bool isEmptyAllowed;

  /// Show or not field border
  final bool withBorder;

  /// Show or not action button
  final bool withAction;

  /// Manage on tap event on action button
  final void Function()? onTapAction;

  final void Function(bool)? onFocusChange;

  /// Icon of action button
  final Icon? actionIcon;

  /// Specify custom border to add on the widget
  final BoxBorder? customBoxBorder;

  final TextAlign textAlign;

  final String? fieldNote;

  @override
  Widget build(BuildContext context) {
    return simpleTextBloc != null
        ? BlocProvider<SimpleTextBloc>.value(
            value: simpleTextBloc!,
            child: _child,
          )
        : BlocProvider(
            create: (context) => SimpleTextBloc(
              isActionEnabled: isActionEnabled,
              isInputTextEnabled: isInputTextEnabled,
              isEmptyAllowed: isEmptyAllowed,
              isNullable: isTextValueNullable,
            ),
            child: _child,
          );
  }

  Widget get _child => _SimpleTextFieldView(
        onTap: onTap,
        onSubmit: onSubmit,
        labelText: labelText,
        textFocusNode: textFocusNode,
        initialText: initialText,
        nextFocusNode: nextFocusNode,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        maxLines: maxLines,
        placeholder: placeholder,
        onChanged: onChanged,
        customBoxBorder: customBoxBorder,
        isObscured: isObscured,
        onCursorPosition: onCursorPosition,
        withBorder: withBorder,
        withAction: withAction,
        onTapAction: onTapAction,
        actionIcon: actionIcon,
        autofocus: autofocus,
        textAlign: textAlign,
        fieldNote: fieldNote,
        onFocusChange: onFocusChange,
      );
}

class _SimpleTextFieldView extends StatefulWidget {
  const _SimpleTextFieldView({
    required this.labelText,
    required this.textFocusNode,
    required this.withAction,
    this.onSubmit,
    this.onChanged,
    this.onTap,
    this.onFocusChange,
    this.onCursorPosition,
    this.initialText = '',
    this.nextFocusNode,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.placeholder,
    this.isObscured = false,
    this.withBorder = false,
    this.autofocus = false,
    this.customBoxBorder,
    this.onTapAction,
    this.actionIcon,
    this.textAlign = TextAlign.start,
    this.fieldNote,
  });

  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmit;
  final void Function()? onTap;
  final void Function()? onTapAction;
  final void Function(int)? onCursorPosition;
  final void Function(bool)? onFocusChange;
  final String labelText;
  final FocusNode textFocusNode;
  final FocusNode? nextFocusNode;
  final String initialText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final int maxLines;
  final String? placeholder;
  final bool autofocus;
  final bool isObscured;
  final bool withBorder;
  final bool withAction;
  final Icon? actionIcon;
  final BoxBorder? customBoxBorder;
  final TextAlign textAlign;
  final String? fieldNote;

  @override
  State<_SimpleTextFieldView> createState() => _SimpleTextFieldViewState();
}

class _SimpleTextFieldViewState extends State<_SimpleTextFieldView> {
  bool _passwordVisible = false;
  final _controller = TextEditingController();
  int _cursorPosition = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _cursorPosition = _controller.selection.baseOffset;
        widget.onCursorPosition?.call(_cursorPosition);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SimpleTextBloc, SimpleTextState>(
      listenWhen: (previous, current) => previous.text != current.text,
      listener: (context, state) {
        if (state.text != null) {
          widget.onChanged?.call(state.text);
          _cursorPosition = state.cursorPosition;
          _controller.value = TextEditingValue(
            text: state.text!,
            selection: TextSelection.fromPosition(
              TextPosition(offset: _cursorPosition),
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.labelText.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
              const Space.vertical(3),
              Row(
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: (!state.isInputTextEnabled) ? 0.5 : 1,
                      child: AbsorbPointer(
                        absorbing: !state.isInputTextEnabled,
                        child: Focus(
                          onFocusChange: (bool focus) {
                            widget.onFocusChange?.call(focus);
                          },
                          child: textField(state),
                        ),
                      ),
                    ),
                  ),
                  if (widget.withAction)
                    Opacity(
                      opacity: (!state.isActionEnabled) ? 0.7 : 1,
                      child: AbsorbPointer(
                        absorbing: !state.isActionEnabled,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: 36,
                          width: 36,
                          child: Focus(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: widget.onTapAction,
                              child: widget.actionIcon,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (widget.fieldNote != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.fieldNote}',
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget textField(SimpleTextState state) => TextField(
        key: widget.key,
        controller: _controller,
        onTap: widget.onTap,
        autofocus: widget.autofocus,
        //enabled: state.isInputTextEnabled,
        readOnly: !state.isInputTextEnabled,
        focusNode: widget.textFocusNode,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        textAlign: widget.textAlign,
        obscureText: widget.isObscured && !_passwordVisible,
        maxLines: widget.maxLines,
        onChanged: (text) {
          context
              .read<SimpleTextBloc>()
              .add(TextChanged(text, _cursorPosition));
          widget.onChanged?.call(text);
        },
        onSubmitted: (s) {
          context.read<SimpleTextBloc>().add(ValidateData());
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
          widget.onSubmit?.call(s);
        },
        onEditingComplete: () =>
            context.read<SimpleTextBloc>().add(ValidateData()),
        decoration: InputDecoration(
          border: widget.withBorder
              ? OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              : null,
          hintText: widget.placeholder,
          hintMaxLines: widget.maxLines,
          errorText: state.errorText,
          suffixIcon: widget.isObscured
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
          suffixIconColor: Colors.grey,
        ),
      );
}
