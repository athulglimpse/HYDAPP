import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/save_item_model.dart';
import '../../../utils/ui_util.dart';

class CardSaveItem extends StatelessWidget {
  final double height;
  final Function(SaveItemModel) onItemClick;
  final SaveItemModel item;

  CardSaveItem({Key key, this.onItemClick, this.item, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imgCard = (item.images != null && item.images.isNotEmpty)
        ? item.images[0]
        : (item.image ?? item?.place?.image);
    final imgThumb = (item.thumb != null) ? item.thumb : null;
    return GestureDetector(
      onTap: () => onItemClick(item),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: AspectRatio(
              aspectRatio: 1.6,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(sizeVerySmall),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imgCard != null
                        ? UIUtil.makeImageWidget(imgCard.url,
                            boxFit: BoxFit.cover)
                        : UIUtil.makeImageWidget(Res.image_lorem,
                            boxFit: BoxFit.cover),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: sizeSmall,
          ),
          MyTextView(
            textAlign: TextAlign.start,
            text: item?.title ?? '',
            textStyle: textSmallxxx,
          ),
          MyTextView(
            text: item?.pickOneLocation?.address ?? '',
            textAlign: TextAlign.start,
            textStyle:
                textSmallx.copyWith(color: Colors.black.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }
}
