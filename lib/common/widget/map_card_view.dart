import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/model/location_model.dart';
import '../theme/theme.dart';
import '../utils.dart';
import 'my_text_view.dart';

class MapCardView extends StatelessWidget {
  final LocationModel locationModel;
  final Completer<GoogleMapController> _controller = Completer();
  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  MapCardView({
    Key key,
    this.locationModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(locationModel?.lat ?? '0'),
          double.parse(locationModel?.long ?? '0')),
      zoom: 14.4746,
    );

    final markerId = MarkerId(locationModel?.id?.toString() ?? '');

    final marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(locationModel?.lat ?? '0'),
        double.parse(locationModel?.long ?? '0'),
      ),
      infoWindow:
          InfoWindow(title: locationModel?.locationAt ?? '', snippet: '*'),
      onTap: () {},
    );

    markers[markerId] = marker;

    return Container(
      height: sizeImageLargex,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: sizeLarge),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(sizeNormal),
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: Set<Marker>.of(markers.values),
                padding: const EdgeInsets.only(bottom: sizeLarge),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                initialCameraPosition: _kGooglePlex,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
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
                              text: locationModel?.locationAt ?? '',
                              textAlign: TextAlign.start,
                              maxLine: 1,
                              textStyle: textSmallxxx,
                            ),
                            const SizedBox(height: sizeVerySmall),
                            MyTextView(
                              text: locationModel?.address ?? '',
                              textAlign: TextAlign.start,
                              maxLine: 2,
                              textStyle: textSmallxxx.copyWith(
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
                          MapUtils.openMap(10.8060134, 106.6643722);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
