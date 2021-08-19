import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../localization/lang.dart';
import '../theme/theme.dart';
import 'my_text_icon_view.dart';
import 'my_text_view.dart';

class MyInputField extends StatefulWidget {
  final FocusNode focusNode;
  final String errorMessage;
  final FocusNode nextFocusNode;
  final bool obscureText;
  final TextInputAction textInputAction;
  final AutovalidateMode autoValidateMode;
  final String textHint;
  final TextInputType keyboardType;
  final Function(String) onFieldSubmitted;
  final bool isEnable;
  final TextEditingController textController;

  ///these variable for Password Rule
  final bool hasPasswordRule;
  final bool hasUppercase;
  final bool hasDigits;
  final bool hasSpaceCharacters;
  final bool hasSpecialCharacters;
  final bool hasMinLength;

  const MyInputField(
      {Key key,
      this.focusNode,
      this.obscureText = false,
      this.isEnable = true,
      this.hasUppercase = false,
      this.hasDigits = false,
      this.hasSpaceCharacters = false,
      this.hasSpecialCharacters = false,
      this.hasMinLength = false,
      this.nextFocusNode,
      this.textController,
      this.keyboardType = TextInputType.text,
      this.errorMessage,
      this.hasPasswordRule = false,
      this.autoValidateMode,
      this.textHint,
      this.onFieldSubmitted,
      this.textInputAction = TextInputAction.next})
      : super(key: key);

  @override
  _MyInputFieldState createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  bool obs;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    obs = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: sizeSmall),
          padding: const EdgeInsets.all(sizeVerySmall),
          decoration: BoxDecoration(
              boxShadow: [
                widget.focusNode?.hasFocus ?? false
                    ? BoxShadow(
                        color: const Color(0xffFDCB6B).withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset: const Offset(0, 0.5),
                        // changes position of shadow
                      )
                    : BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset: const Offset(0, 0.5),
                        // changes position of shadow
                      ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(sizeSmall))),
          child: TextFormField(
            focusNode: widget.focusNode,
            obscureText: !_passwordVisible && obs,
            enabled: widget.isEnable,
            autovalidateMode:
                widget.autoValidateMode ?? AutovalidateMode.disabled,
            style: textSmallxx.copyWith(color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(sizeVerySmall),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: obs
                  ? IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )
                  : null,
              isDense: true,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              labelText: widget.textHint,
              labelStyle: textSmallxx.copyWith(
                color: (widget?.focusNode?.hasFocus ?? false)
                    ? const Color(0xffFDCB6B)
                    : const Color(0x32212237),
              ),
            ),
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            controller: widget.textController,
            onFieldSubmitted: (v) {
              if (widget.nextFocusNode != null) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              }
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted(v);
              }
            },
          ),
        ),
        widget.errorMessage != null
            ? Container(
                alignment: Alignment.topLeft,
                padding:
                    const EdgeInsets.only(left: sizeSmall, top: sizeVerySmall),
                child: MyTextView(
                  textAlign: TextAlign.start,
                  text: widget.errorMessage,
                  textStyle: textSmall.copyWith(color: Colors.redAccent),
                ),
              )
            : const SizedBox(),
        widget.hasPasswordRule
            ? Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: sizeSmall, top: sizeSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextView(
                      textAlign: TextAlign.start,
                      text: Lang.register_your_password_must_contain.tr(),
                      textStyle: textSmallx.copyWith(color: Colors.grey[600]),
                    ),
                    MyTextIconView(
                      marginText: const EdgeInsets.only(right: sizeVerySmall),
                      textAlign: TextAlign.start,
                      iconLeft: Icon(Icons.fiber_manual_record,
                          size: sizeVerySmall, color: Colors.grey[600]),
                      iconRight: widget.hasMinLength
                          ? Icon(Icons.check,
                              size: sizeSmallxxxx, color: Colors.green[800])
                          : null,
                      text: Lang.register_at_least_character.tr(),
                      textStyle: textSmallx.copyWith(
                          color: Colors.grey[600],
                          decoration: widget.hasMinLength
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    MyTextIconView(
                      marginText: const EdgeInsets.only(right: sizeVerySmall),
                      iconLeft: Icon(Icons.fiber_manual_record,
                          size: sizeVerySmall, color: Colors.grey[600]),
                      iconRight: widget.hasDigits
                          ? Icon(Icons.check,
                              size: sizeSmallxxxx, color: Colors.green[800])
                          : null,
                      textAlign: TextAlign.start,
                      text: Lang.register_at_least_number.tr(),
                      textStyle: textSmallx.copyWith(
                          color: Colors.grey[600],
                          decoration: widget.hasDigits
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    MyTextIconView(
                      marginText: const EdgeInsets.only(right: sizeVerySmall),
                      iconLeft: Icon(Icons.fiber_manual_record,
                          size: sizeVerySmall, color: Colors.grey[600]),
                      iconRight: widget.hasUppercase
                          ? Icon(Icons.check,
                              size: sizeSmallxxxx, color: Colors.green[800])
                          : null,
                      textAlign: TextAlign.start,
                      text: Lang.register_at_least_an_upper_case_letter.tr(),
                      textStyle: textSmallx.copyWith(
                          color: Colors.grey[600],
                          decoration: widget.hasUppercase
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    MyTextIconView(
                      marginText: const EdgeInsets.only(right: sizeVerySmall),
                      iconLeft: Icon(Icons.fiber_manual_record,
                          size: sizeVerySmall, color: Colors.grey[600]),
                      iconRight: widget.hasSpaceCharacters
                          ? Icon(Icons.check,
                              size: sizeSmallxxxx, color: Colors.green[800])
                          : null,
                      textAlign: TextAlign.start,
                      text: Lang.register_no_use_spaces.tr(),
                      textStyle: textSmallx.copyWith(
                          color: Colors.grey[600],
                          decoration: widget.hasSpaceCharacters
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    MyTextIconView(
                      marginText: const EdgeInsets.only(right: sizeVerySmall),
                      iconLeft: Icon(Icons.fiber_manual_record,
                          size: sizeVerySmall, color: Colors.grey[600]),
                      iconRight: widget.hasSpecialCharacters
                          ? Icon(Icons.check,
                              size: sizeSmallxxxx, color: Colors.green[800])
                          : null,
                      textAlign: TextAlign.start,
                      text: Lang.register_at_least_an_special_letter.tr(),
                      textStyle: textSmallx.copyWith(
                          color: Colors.grey[600],
                          decoration: widget.hasSpecialCharacters
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                  ],
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
