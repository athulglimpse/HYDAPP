import 'package:flutter/material.dart';

class TakePhotoButton extends StatefulWidget {
  final Function onTap;

  TakePhotoButton({Key key, this.onTap}) : super(key: key);

  @override
  _TakePhotoButtonState createState() => _TakePhotoButtonState();
}

class _TakePhotoButtonState extends State<TakePhotoButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double _scale;
  final Duration _duration = const Duration(milliseconds: 100);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animationController.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        height: 60,
        width: 60,
        child: Transform.scale(
          scale: _scale,
          child: CustomPaint(
            painter: TakePhotoButtonPainter(),
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(_duration, () {
      _animationController.reverse();
    });

    widget.onTap();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }
}

class TakePhotoButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPainter = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..isAntiAlias = true;
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    bgPainter.color = Colors.white;
    canvas.drawCircle(center, radius - 4, bgPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
