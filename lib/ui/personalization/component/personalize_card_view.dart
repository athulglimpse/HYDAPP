import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/personalization_item.dart';
import '../../../utils/ui_util.dart';

class PersonalizationCardView extends StatelessWidget {
  final PersonalizationItem personalizationItem;
  final int index;
  final Function(PersonalizationItem) onSelectItem;

  PersonalizationCardView({
    Key key,
    this.index,
    this.onSelectItem,
    @required this.personalizationItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment:
            index % 2 != 0 ? Alignment.bottomCenter : Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            left: sizeVerySmall,
            right: sizeVerySmall,
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () => onSelectItem(personalizationItem),
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: personalizationItem.selected
                              ? Border.all(
                                  color: const Color(0xffFDCB6B),
                                  width: sizeIcon)
                              : null,
                          image: DecorationImage(
                            image: UIUtil.makeImageDecoration(
                                personalizationItem.image),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeNormalx) //
                              )),
                      child: Stack(children: <Widget>[
                        personalizationItem.selected
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(20),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(sizeNormalx) //
                                        )),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(60),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            sizeNormalx) //                 <--- border radius here
                                        )),
                              ),
                        Align(
                          alignment: Alignment.center,
                          child: MyTextView(
                            textStyle: textNormal.copyWith(color: Colors.white),
                            text: personalizationItem.title,
                          ),
                        ),
                      ]),
                    ),
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
