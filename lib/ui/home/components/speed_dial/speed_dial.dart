import 'package:flutter/material.dart';
import 'package:marvista/data/source/api_end_point.dart';

import 'animated_child.dart';
import 'animated_floating_button.dart';
import 'animated_icon_button.dart';
import 'background_overlay.dart';
import 'speed_dial_child.dart';

/// Builds the Speed Dial
class SpeedDial extends StatefulWidget {
  /// Children buttons, from the lowest to the highest.
  final List<SpeedDialChild> children;

  /// Used to get the button hidden on scroll. See examples for more info.
  final bool visible;

  /// The curve used to animate the button on scrolling.
  final Curve curve;

  final String tooltip;
  final String heroTag;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final ShapeBorder shape;

  final double marginRight;
  final double marginBottom;

  /// The color of the background overlay.
  final Color overlayColor;

  /// The opacity of the background overlay when the dial is open.
  final double overlayOpacity;

  /// The animated icon to show as the main button child. If this is provided the [child] is ignored.
  final AnimatedIconButton animatedIcon;

  /// The theme for the animated icon.
  final IconThemeData animatedIconTheme;

  /// The child of the main button, ignored if [animatedIcon] is non [null].
  final Widget child;

  /// Executed when the dial is opened.
  final VoidCallback onOpen;

  /// Executed when the dial is closed.
  final VoidCallback onClose;

  /// Executed when the dial is pressed. If given, the dial only opens on long press!
  final VoidCallback onPress;

  /// If true user is forced to close dial manually by tapping main button. WARNING: If true, overlay is not rendered.
  final bool closeManually;

  /// The speed of the animation
  final int animationSpeed;

  /// Language code
  final String languageCode;

  SpeedDial(
      {this.children = const [],
      this.visible = true,
      this.backgroundColor,
      this.foregroundColor,
      this.elevation = 6.0,
      this.overlayOpacity = 0.8,
      this.overlayColor = Colors.white,
      this.tooltip,
      this.heroTag,
      this.animatedIcon,
      this.animatedIconTheme,
      this.child,
      this.marginBottom = 16,
      this.marginRight = 16,
      this.onOpen,
      this.onClose,
      this.closeManually = false,
      this.shape = const CircleBorder(),
      this.curve = Curves.linear,
      this.onPress,
      this.animationSpeed = 150,
      this.languageCode});

  @override
  _SpeedDialState createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _calculateMainControllerDuration(),
      vsync: this,
    );
  }

  Duration _calculateMainControllerDuration() => Duration(
      milliseconds: widget.animationSpeed +
          widget.children.length * (widget.animationSpeed / 5).round());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performAnimation() {
    if (!mounted) {
      return;
    }
    if (_open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(SpeedDial oldWidget) {
    if (oldWidget.children.length != widget.children.length) {
      _controller.duration = _calculateMainControllerDuration();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _toggleChildren() {
    final newValue = !_open;
    setState(() {
      _open = newValue;
    });
    if (newValue && widget.onOpen != null) {
      widget.onOpen();
    }
    _performAnimation();
    if (!newValue && widget.onClose != null) {
      widget.onClose();
    }
  }

  List<Widget> _getChildrenList() {
    final singleChildrenTween = 1.0 / widget.children.length;

    return widget.children
        .map((SpeedDialChild child) {
          final index = widget.children.indexOf(child);

          final childAnimation = Tween(begin: 0.0, end: 62.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(0, singleChildrenTween * (index + 1)),
            ),
          );

          return AnimatedChild(
            animation: childAnimation,
            index: index,
            visible: _open,
            backgroundColor: child.backgroundColor,
            foregroundColor: child.foregroundColor,
            elevation: child.elevation,
            label: child.label,
            labelStyle: child.labelStyle,
            labelBackgroundColor: child.labelBackgroundColor,
            labelWidget: child.labelWidget,
            onTap: child.onTap,
            toggleChildren: () {
              if (!widget.closeManually) {
                _toggleChildren();
              }
            },
            shape: child.shape,
            heroTag: widget.heroTag != null
                ? '${widget.heroTag}-child-$index'
                : null,
            child: child.child,
          );
        })
        .toList()
        .reversed
        .toList();
  }

  Widget _renderOverlay() {
    return Positioned(
      right: -16.0,
      bottom: -16.0,
      top: _open ? 0.0 : null,
      left: _open ? -16.0 : null,
      child: GestureDetector(
        onTap: _toggleChildren,
        child: BackgroundOverlay(
          animation: _controller,
          color: widget.overlayColor,
          opacity: widget.overlayOpacity,
        ),
      ),
    );
  }

  Widget _renderButton() {
    // ignore: missing_required_param
    final child = AnimatedIconButton(
      size: widget.animatedIconTheme?.size,
      animationController: _controller,
      startBackgroundColor: const Color(0xff314697),
      endBackgroundColor: const Color(0xffFFFFFF),
      endIcon: const Icon(
        Icons.close,
        color: Color(0xff314697),
      ),
      startIcon: const Icon(
        Icons.add,
        color: Color(0xffFFFFFF),
      ),
    );

    final fabChildren = _getChildrenList();

    final animatedFloatingButton = AnimatedFloatingButton(
      visible: widget.visible,
      tooltip: widget.tooltip,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      elevation: widget.elevation,
      onLongPress: _toggleChildren,
      callback:
          (_open || widget.onPress == null) ? _toggleChildren : widget.onPress,
      heroTag: widget.heroTag,
      shape: widget.shape,
      curve: widget.curve,
      child: child,
    );

    return Positioned(
      bottom: widget.marginBottom - 16,
      right: widget.languageCode == PARAM_EN ? widget.marginRight - 16 : 0,
      left: widget.languageCode == PARAM_AR ? widget.marginRight - 16 : 0,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.from(fabChildren)
            ..add(
              Container(
                margin: const EdgeInsets.only(top: 8.0, right: 2.0),
                child: animatedFloatingButton,
              ),
            ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      if (!widget.closeManually) _renderOverlay(),
      _renderButton(),
    ];

    return Stack(
      alignment: Alignment.bottomRight,
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: children,
    );
  }
}
