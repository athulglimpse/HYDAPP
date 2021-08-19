import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName,
    {double extendSize = 0}) async {
  // Read SVG file as String
  final svgString = await DefaultAssetBundle.of(context).loadString(assetName);
  // Create DrawableRoot from SVG String
  final svgDrawableRoot = await svg.fromSvgString(svgString, null);

  final queryData = MediaQuery.of(context);
  final devicePixelRatio = queryData.devicePixelRatio;
  final width = 32 * devicePixelRatio +
      extendSize; // where 32 is your SVG's original width
  final height = 32 * devicePixelRatio + extendSize; // same thing

  // Convert to ui.Picture
  final picture = svgDrawableRoot.toPicture(size: Size(width, height));

  // Convert to ui.Image. toImage() takes width and height as parameters
  // you need to find the best size to suit your needs and take into account the
  // screen DPI
  final image = await picture.toImage(width.toInt(), height.toInt());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}
