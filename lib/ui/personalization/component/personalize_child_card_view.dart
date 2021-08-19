import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/personalization_item.dart';
import '../../../utils/utils.dart';

class PersonalizationChildCardView extends StatelessWidget {
  final Items childPersonal;
  final int index;
  final Function(Items) onSelectItem;

  PersonalizationChildCardView({
    Key key,
    this.index,
    @required this.childPersonal,
    @required this.onSelectItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: index == 2 ? Alignment.bottomCenter : Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            left: sizeIcon,
            right: sizeIcon,
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () => onSelectItem(childPersonal),
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: childPersonal.selected
                              ? Utils.fromHex(childPersonal.color)
                                  .withOpacity(0.5)
                              : Colors.transparent,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeNormalx) //
                              )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(sizeVerySmall),
                      decoration: BoxDecoration(
                          color: Utils.fromHex(childPersonal.color),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeNormal) //
                              )),
                      child: Stack(children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: MyTextView(
                            textStyle: textNormal.copyWith(color: Colors.white),
                            text: childPersonal.title,
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
