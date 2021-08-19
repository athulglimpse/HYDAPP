import 'dart:async';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';

class CupertinoPickerView extends StatefulWidget {
  final List<dynamic> listData;
  final List<Widget> listWidget;
  final int positionSelected;
  final ValueChanged<int> onSelectedItemChanged;

  const CupertinoPickerView(
      {Key key,
      this.listData,
      this.onSelectedItemChanged,
      this.listWidget,
      this.positionSelected})
      : super(key: key);

  @override
  _CupertinoPickerState createState() => _CupertinoPickerState();
}

class _CupertinoPickerState extends State<CupertinoPickerView> {
  final FixedExtentScrollController scrollController =
      FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      scrollController.animateToItem(max(0, widget.positionSelected),
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeImageLargexx,
      child: Scaffold(
          appBar: CupertinoNavigationBar(
            leading: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
                  onPressed: () {
                    scrollController.animateToItem(
                        max(0, scrollController.selectedItem - 1),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onPressed: () {
                    scrollController.animateToItem(
                        min(widget.listData.length,
                            scrollController.selectedItem + 1),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                ),
              ],
            ),
            trailing: MyTextView(
              onTap: () {
                widget.onSelectedItemChanged(scrollController.selectedItem);
                Navigator.of(context).pop();
              },
              text: Lang.done.tr(),
              textStyle: textSmallxxx.copyWith(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          body: Container(
              child: CupertinoPicker(
            scrollController: scrollController,
            backgroundColor: Colors.transparent,
            itemExtent: sizeLargex,
            onSelectedItemChanged: (int value) {
              ///not thing update
            },
            children: widget.listWidget,
            //height of each item
          ))),
    );
  }
}
