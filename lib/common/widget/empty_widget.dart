import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marvista/utils/ui_util.dart';

class EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          UIUtil.makeImageWidget(
            'assets/ic_empty.png',
            height: 100,
            width: 100,
          ),
          const Text('No Data')
        ],
      ),
    );
  }
}
