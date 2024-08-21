import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/elements/texts/simple_text_field/simple_text_field.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Generic input text field
class SimpleTextField extends StatelessWidget {
  /// Create [SimpleTextField] instance
  const SimpleTextField({
    required this.onSubmit,
    required this.labelText,
    this.textFocusNode,
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
    this.onChanged,
    this.onCursorPosition,
    this.onFocusChange,
    this.withBorder = false,
    this.withAction = false,
    this.autofocus = false,
    this.borderColor,
    this.actionIcon,
    super.key,
  });

  /// Optional param to allow user to create bloc externally
  final SimpleTextBloc? simpleTextBloc;

  /// Result function with input data
  final void Function(String?)? onChanged;

  final void Function(String?) onSubmit;

  /// Manage on tap event
  final void Function()? onTap;

  /// Manage on focys event
  final void Function(bool)? onFocusChange;

  /// Manage on change event (cursor position)
  final void Function(int)? onCursorPosition;

  /// Label text
  final String labelText;

  /// Focus node of current widget
  final FocusNode? textFocusNode;

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

  /// Icon of action button
  final Icon? actionIcon;

  /// Customize border color
  final Color? borderColor;

  /// Specify custom border to add on the widget
  final BoxBorder? customBoxBorder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          simpleTextBloc ??
          SimpleTextBloc(
            isActionEnabled: isActionEnabled,
            isInputTextEnabled: isInputTextEnabled,
            isEmptyAllowed: isEmptyAllowed,
            isNullable: isTextValueNullable,
          ),
      child: _SimpleTextFieldView(
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
        borderColor: borderColor,
        withAction: withAction,
        onTapAction: onTapAction,
        actionIcon: actionIcon,
        autofocus: autofocus,
        onFocusChange: onFocusChange,
      ),
    );
  }
}

class _SimpleTextFieldView extends StatefulWidget {
  const _SimpleTextFieldView({
    required this.labelText,
    required this.textFocusNode,
    required this.withAction,
    required this.onSubmit,
    this.onChanged,
    this.onTap,
    this.onTapAction,
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
    this.borderColor,
    this.customBoxBorder,
    this.actionIcon,
  });

  final void Function(String?)? onChanged;
  final void Function(String?) onSubmit;
  final void Function()? onTap;
  final void Function()? onTapAction;
  final void Function(int)? onCursorPosition;
  final void Function(bool)? onFocusChange;
  final String labelText;
  final FocusNode? textFocusNode;
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
  final Color? borderColor;
  final BoxBorder? customBoxBorder;

  @override
  State<_SimpleTextFieldView> createState() => _SimpleTextFieldViewState();
}

class _SimpleTextFieldViewState extends State<_SimpleTextFieldView> {
  bool _passwordVisible = false;
  bool _textShowCursor = false;
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
  Widget build(BuildContext context) {
    return BlocListener<SimpleTextBloc, SimpleTextState>(
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
      child: BlocBuilder<SimpleTextBloc, SimpleTextState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.labelText.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme?.textTheme.labelLarge?.copyWith(
                          color: context.theme?.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Opacity(
                        opacity: (!state.isInputTextEnabled) ? 0.5 : 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.theme?.colorScheme.background,
                            borderRadius: BorderRadius.circular(8),
                            border: widget.withBorder
                                ? Border.all(
                                    color: widget.borderColor ??
                                        context.theme?.colorScheme.outline ??
                                        const Color(0xFF000000),
                                  )
                                : null,
                          ),
                          child: AbsorbPointer(
                            absorbing: !state.isInputTextEnabled,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Focus(
                                onFocusChange: (bool focus) {
                                  setState(() => _textShowCursor = focus);
                                  widget.onFocusChange?.call(focus);
                                },
                                child: _textView(state),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.withAction)
                      Opacity(
                        opacity: (!state.isActionEnabled) ? 0.5 : 1,
                        child: AbsorbPointer(
                          absorbing: !state.isActionEnabled,
                          child: Container(
                            margin: const EdgeInsets.only(top: 22, left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: widget.withBorder
                                  ? Border.all(
                                      color: widget.borderColor ??
                                          context.theme?.colorScheme.outline ??
                                          const Color(0xFF000000),
                                    )
                                  : null,
                            ),
                            height:
                                (52 + ((widget.maxLines - 1) * 16)).toDouble(),
                            width:
                                (52 + ((widget.maxLines - 1) * 16)).toDouble(),
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(8),
                              shadowColor:
                                  context.theme?.dialogTheme.shadowColor,
                              child: Focus(
                                child: InkWell(
                                  onTap: widget.onTapAction,
                                  child: widget.actionIcon,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (state.status == SimpleTextStatus.failure)
                  Positioned(
                    bottom: 5,
                    child: Text(
                      state.errorText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.theme?.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme?.colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _textView(SimpleTextState state) => TextField(
    key: widget.key,
    controller: _controller,
    showCursor: _textShowCursor,
    onTap: widget.onTap,
    autofocus: widget.autofocus,
    readOnly: !state.isInputTextEnabled,
    focusNode: widget.textFocusNode,
    keyboardType: widget.keyboardType,
    textCapitalization: widget.textCapitalization,
    textInputAction: widget.textInputAction,
    obscureText:
    widget.isObscured && !_passwordVisible,
    maxLines: widget.maxLines,
    onChanged: (text) {
      context.read<SimpleTextBloc>().add(
          TextChanged(text, _cursorPosition));
      widget.onChanged?.call(text);
    },
    onSubmitted: widget.onSubmit,
    onEditingComplete: () {
      context
          .read<SimpleTextBloc>()
          .add(ValidateData());
      if (widget.nextFocusNode != null) {
        FocusScope.of(context)
            .requestFocus(widget.nextFocusNode);
      } else {
        FocusScope.of(context).unfocus();
      }
    },
    style: TextStyle(
      color:
      context.theme?.colorScheme.onBackground,
    ),
    decoration: InputDecoration(
      filled: false,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      alignLabelWithHint: true,
      hintText: widget.placeholder,
      hintMaxLines: widget.maxLines,
      suffixIcon: widget.isObscured
          ? IconButton(
        icon: Icon(
          _passwordVisible
              ? Icons.visibility
              : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            _passwordVisible =
            !_passwordVisible;
          });
        },
      )
          : null,
      suffixIconColor: Colors.grey,
    ),
  );
}
