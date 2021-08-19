import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_icon_view.dart';
import '../../../common/widget/my_text_view.dart';

class PhoneNumberFormField extends StatefulWidget {
  final FocusNode focusNode;
  final String errorMessage;
  final bool isErrorPassword;
  final FocusNode nextFocusNode;
  final bool obscureText;
  final String text;
  final TextInputAction textInputAction;
  final AutovalidateMode autoValidateMode;
  final TextInputType keyboardType;
  final Function(String) onFieldSubmitted;
  final TextEditingController textController;
  final GestureTapCallback onPressCountryCode;

  const PhoneNumberFormField({
    Key key,
    this.focusNode,
    this.obscureText = false,
    this.nextFocusNode,
    this.textController,
    this.keyboardType = TextInputType.text,
    this.errorMessage,
    this.isErrorPassword,
    this.autoValidateMode,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.next,
    this.text,
    this.onPressCountryCode,
  }) : super(key: key);

  @override
  _PhoneNumberFormFieldState createState() => _PhoneNumberFormFieldState();
}

class _PhoneNumberFormFieldState extends State<PhoneNumberFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: sizeVerySmall),
          padding: const EdgeInsets.all(sizeVerySmall),
          decoration: BoxDecoration(
              boxShadow: [
                widget.focusNode.hasFocus
                    ? BoxShadow(
                        color: const Color(0xffFDCB6B).withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset:
                            const Offset(0, 0.5), // changes position of shadow
                      )
                    : BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset:
                            const Offset(0, 0.5), // changes position of shadow
                      ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(sizeSmall))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: sizeVerySmallx),
                child: MyTextView(
                    onTap: widget.onPressCountryCode,
                    textAlign: TextAlign.start,
                    text: Lang.register_enter_mobile_number.tr(),
                    textStyle:
                        textSmall.copyWith(color: const Color(0x32212237))),
              ),
              Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: sizeLargexxx),
                    child: MyTextIconView(
                      marginText: const EdgeInsets.only(left: sizeVerySmallx),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      iconRight: const Icon(Icons.keyboard_arrow_down,
                          size: sizeSmallxxxx, color: Colors.black),
                      textAlign: TextAlign.start,
                      text: widget.text,
                      textStyle: textSmallx.copyWith(color: Colors.black),
                      onTap: widget.onPressCountryCode,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      focusNode: widget.focusNode,
                      obscureText: widget.obscureText,
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      maxLength: 10,
                      autovalidateMode:
                          widget.autoValidateMode ?? AutovalidateMode.disabled,
                      style: textSmallxx.copyWith(color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(sizeVerySmall),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
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
                          FocusScope.of(context)
                              .requestFocus(widget.nextFocusNode);
                        }
                        if (widget.onFieldSubmitted != null) {
                          widget.onFieldSubmitted(v);
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
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
      ],
    );
  }
}
