import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/places_model.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../theme/theme.dart';
import 'my_text_view.dart';

class AssetItemForGrid extends StatelessWidget {
  final PlaceModel item;
  final Function(PlaceModel) onItemClick;

  AssetItemForGrid({
    Key key,
    this.item,
    this.onItemClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: sizeSmall),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1.5), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(sizeSmall))),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: () {
                onItemClick(item);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  UIUtil.makeCircleImageWidget(Res.image_lorem,
                      size: constraints.maxWidth - sizeLarge),
                  Column(
                    children: [
                      MyTextView(
                        text: item.title,
                        textStyle: textSmallxx,
                      ),
                      const SizedBox(
                        height: sizeVerySmall,
                      ),
                      MyTextView(
                        text: item.title,
                        textStyle: textSmallx,
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
