import 'package:flutter/material.dart';

import '../../data/model/location_model.dart';
import '../../utils/ui_util.dart';
import '../theme/theme.dart';
import '../utils.dart';
import 'my_text_view.dart';

class StaticMapsProvider extends StatefulWidget {
  final List markers;
  final String googleMapsApiKey;
  final LocationModel locationModel;
  final int width;
  final int height;
  final int zoom;

  StaticMapsProvider(this.googleMapsApiKey,
      {this.markers,
      this.width,
      this.height,
      this.zoom = 14,
      this.locationModel});
  @override
  _StaticMapsProviderState createState() => _StaticMapsProviderState();
}

class _StaticMapsProviderState extends State<StaticMapsProvider> {
  String startUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2000px-Solid_white.svg.png';
  String nextUrl;
  static const int defaultWidth = 600;
  static const int defaultHeight = 400;

  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    _scaleFactor = widget.zoom.toDouble();
  }

  void _buildUrl(List locations, int width, int height) {
    var finalUri = Uri();
    final baseUri = Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {});

    final markers = <String>[];
    // // Add a blue marker for the user
    // final userLat = currentLocation['latitude'];
    // final userLng = currentLocation['longitude'];
    // final marker = '$userLat,$userLng';
    // markers.add(marker);
    // Add a red marker for each location you decide to add
    double centerLat;
    double centerLong;
    widget.markers.forEach((location) {
      centerLat = location['latitude'];
      centerLong = location['longitude'];
      final lat = location['latitude'];
      final lng = location['longitude'];
      final marker = '$lat,$lng';
      markers.add(marker);
    });
    final markersString = markers.join('|');
    finalUri = baseUri.replace(queryParameters: {
      'markers': markersString,
      'center': '$centerLat,$centerLong',
      'zoom': '${_scaleFactor.toInt()}',
      'size': '${width ?? defaultWidth}x${height ?? defaultHeight}',
      'key': '${widget.googleMapsApiKey}',
    });
    setState(() {
      startUrl = nextUrl ?? startUrl;
      nextUrl = finalUri.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildUrl(widget.markers, widget.width ?? defaultWidth,
        widget.height ?? defaultHeight);
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () {
            MapUtils.openMap(
                widget.locationModel.lat, widget.locationModel.long);
          },
          onScaleStart: (details) {
            _baseScaleFactor = _scaleFactor;
          },
          onScaleUpdate: (details) {
            _scaleFactor = _baseScaleFactor * (details.scale);
          },
          onScaleEnd: (D) {
            setState(() {
              _scaleFactor = _scaleFactor.clamp(0, 20).toDouble();
              _buildUrl(widget.markers, widget.width ?? defaultWidth,
                  widget.height ?? defaultHeight);
            });
          },
          child: Container(
              margin: const EdgeInsets.only(bottom: sizeLarge),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(sizeNormal),
                  child:
                      UIUtil.makeImageWidget(nextUrl, boxFit: BoxFit.cover))),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: sizeVerySmall),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: sizeNormal),
                padding: const EdgeInsets.symmetric(
                    vertical: sizeSmall, horizontal: sizeSmall),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1.5),
                        // changes position of shadow
                      ),
                    ],
                    borderRadius:
                        const BorderRadius.all(Radius.circular(sizeSmall))),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyTextView(
                            text: widget.locationModel?.locationAt ?? '',
                            textAlign: TextAlign.start,
                            maxLine: 1,
                            textStyle: textSmallxx.copyWith(
                                fontWeight: MyFontWeight.medium),
                          ),
                          const SizedBox(height: sizeVerySmall),
                          MyTextView(
                            text: widget.locationModel?.address ?? '',
                            textAlign: TextAlign.start,
                            maxLine: 2,
                            textStyle: textSmallx.copyWith(
                                color: Colors.black.withAlpha(128)),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.directions,
                        color: Color(0xff419C9B),
                        size: sizeNormalxx,
                      ),
                      onPressed: () {
                        MapUtils.openMap(widget.locationModel.lat,
                            widget.locationModel.long);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
