import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_button.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';

class CommunityCongratulationScreen extends StatelessWidget {
  static const routeName = '/CommunityCongratulationScreen';
  final String title, description;

  const CommunityCongratulationScreen({
    Key key,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: UIUtil.makeImageDecoration(Res.default_bg_congrats),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(sizeNormalxxx),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(sizeSmall),
                        decoration: BoxDecoration(
                            color: const Color(0xff185D30),
                            borderRadius: BorderRadius.circular(sizeExLarge)),
                        child: const Icon(
                          Icons.check,
                          size: sizeLarge,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: sizeLargexxx),
                    MyTextView(
                      text: title,
                      textStyle: textNormalxx.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: sizeNormal),
                    MyTextView(
                      text: description,
                      textStyle: textSmallx.copyWith(color: Colors.grey),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: sizeNormalxx, bottom: sizeSmall),
                child: MyButton(
                  minWidth: sizeImageLarge,
                  text: Lang.community_post_photo_post_done.tr(),
                  onTap: () {
                    NavigateUtil.pop(context);
                  },
                  isFillParent: false,
                  textStyle: textNormal.copyWith(color: Colors.white),
                  buttonColor: const Color(0xff242655),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
