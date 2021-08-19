import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_button.dart';
import '../widget/my_input_field.dart';
import '../widget/my_text_view.dart';
import 'normal_dialog_template.dart';

class LinkAccountDialog extends StatefulWidget {
  final Function(String) onEnterPassword;
  final String email;

  const LinkAccountDialog({Key key, this.onEnterPassword, this.email})
      : super(key: key);
  @override
  _LinkAccountDialogState createState() => _LinkAccountDialogState();
}

class _LinkAccountDialogState extends State<LinkAccountDialog> {
  final FocusNode _focusPassword = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return NormalDialogTemplate.makeTemplate(
      Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextView(
              text: Lang.login_link_account.tr(),
              textStyle: textNormalx,
            ),
            MyInputField(
              textHint: Lang.login_email.tr(),
              autoValidateMode: AutovalidateMode.onUserInteraction,
              isEnable: false,
              keyboardType: TextInputType.text,
              textController: _emailController,
            ),
            MyInputField(
              focusNode: _focusPassword,
              textHint: Lang.login_password.tr(),
              autoValidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              keyboardType: TextInputType.text,
              textController: _passwordController,
              onFieldSubmitted: (v) {
                FocusScope.of(context).unfocus();
                widget.onEnterPassword(v);
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: sizeNormal, bottom: sizeSmall),
              child: MyButton(
                paddingHorizontal: sizeImageSmall,
                text: Lang.login_submit.tr(),
                onTap: () {
                  widget.onEnterPassword(_passwordController.text);
                },
                isFillParent: false,
                textStyle: textNormal.copyWith(color: Colors.white),
                buttonColor: const Color(0xff242655),
              ),
            )
          ],
        ),
      ),
      insetMargin: const EdgeInsets.all(sizeNormal),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
