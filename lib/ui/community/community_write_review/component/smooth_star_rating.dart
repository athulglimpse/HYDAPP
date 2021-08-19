import 'package:flutter/material.dart';

typedef RatingChangeCallback = void Function(double rating);

class SmoothStarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color borderColor;
  final double size;
  final bool allowHalfRating;
  final IconData filledIconData;
  final IconData halfFilledIconData;
  final IconData
      defaultIconData;
  //this is needed only when having fullRatedIconData && halfRatedIconData
  final double spacing;

  SmoothStarRating({
    this.starCount = 5,
    this.spacing = 0.0,
    this.rating = 0.0,
    this.defaultIconData,
    this.onRatingChanged,
    this.color,
    this.borderColor,
    this.size = 25,
    this.filledIconData,
    this.halfFilledIconData,
    this.allowHalfRating = true,
  }) {
    // ignore: prefer_asserts_in_initializer_lists
    assert(rating != null, 'a must not be null');
  }

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        defaultIconData ?? Icons.star_border,
        color: borderColor ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else if ((index > rating - (allowHalfRating ? 0.5 : 1.0)) &&
        (index < rating)) {
      icon = Icon(
        halfFilledIconData ?? Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else {
      icon = Icon(
        filledIconData ?? Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    }

    return GestureDetector(
      onTapDown: (details) {
        double value;
        if (index == 0 && (rating == 1 || rating == 0.5)) {
          value = 0;
        } else if (onRatingChanged != null) {
          final tappedPosition = details.localPosition.dx;
          final tappedOnFirstHalf = tappedPosition <= size / 2;
          value = index + (tappedOnFirstHalf && allowHalfRating ? 0.3 : 1.0);
          onRatingChanged(value);
        }
      },
      onHorizontalDragUpdate: (dragDetails) {
        final RenderBox box = context.findRenderObject();
        final _pos = box.globalToLocal(dragDetails.globalPosition);
        final i = _pos.dx / size;
        var newRating = allowHalfRating ? i : i.round().toDouble();
        if (newRating > starCount) {
          newRating = starCount.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        if (onRatingChanged != null) {
          onRatingChanged(newRating);
        }
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: spacing,
          children: List.generate(
              starCount, (index) => buildStar(context, index))),
    );
  }
}
