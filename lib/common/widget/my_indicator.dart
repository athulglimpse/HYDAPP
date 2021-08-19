import 'package:flutter/material.dart';
import '../theme/theme.dart';

class MyIndicator extends StatefulWidget {
  static const routeName = 'IndicatorScreen';
  final PageController controller;
  final int itemCount;
  final Color normalColor;
  final Color selectedColor;
  final bool needScaleSelected;

  MyIndicator({
    Key key,
    this.controller,
    this.itemCount,
    this.needScaleSelected = true,
    this.normalColor,
    this.selectedColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyIndicatorState();
  }
}

class MyIndicatorState extends State<MyIndicator> {
  /// PageView Controller
  PageController controller;

  /// Number of indicators
  int itemCount;

  /// Ordinary colours
  Color normalColor = const Color.fromARGB(127, 255, 255, 255);

  /// Selected color
  Color selectedColor = Colors.white;

  /// Size of points
  final double size = sizeVerySmallx;

  /// Size of points selected
  double sizeSelected = sizeSmallx;

  /// Spacing of points
  final double spacing = 4.0;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    itemCount = widget.itemCount;

    normalColor =
        widget.normalColor ?? const Color.fromARGB(127, 255, 255, 255);
    selectedColor = widget.selectedColor ?? Colors.white;

    sizeSelected = widget.needScaleSelected ? sizeSmallx : size;
  }

  void pageChanged(int index) {
    setState(() {});
  }

  /// Point Widget
  Widget _buildIndicator(int index, int pageCount, double dotSize,
      dotSizeSelected, double spacing) {
    // Is the current page selected?
    final isCurrentPageSelected = index ==
        (controller.page != null ? controller.page.round() % pageCount : 0);

    return Container(
      height: sizeSelected,
      width: sizeSelected + (2 * spacing),
      child: Center(
        child: Material(
          color: isCurrentPageSelected ? selectedColor : normalColor,
          type: MaterialType.circle,
          child: Container(
            width: isCurrentPageSelected ? dotSizeSelected : dotSize,
            height: isCurrentPageSelected ? dotSizeSelected : dotSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, (int index) {
        return _buildIndicator(index, itemCount, size, sizeSelected, spacing);
      }),
    );
  }
}
