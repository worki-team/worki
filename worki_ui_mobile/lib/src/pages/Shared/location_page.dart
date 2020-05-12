import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:worki_ui/src/models/event_model.dart';

class LocationPage extends StatefulWidget {
  LocationPage({Key key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<String, dynamic> arguments;
  @override
  void initState() {
    super.initState();
  }

  double latitude;
  double longitude;
  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    latitude = arguments['latitude'];
    longitude = arguments['longitude'];
    return FutureBuilder(
        future: Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            final MarkerId markerIdTarget = MarkerId("0");
            Marker markerTarget = Marker(
              markerId: markerIdTarget,
              draggable: true,
              position: LatLng(
                  snapshot.data.latitude,
                  snapshot.data
                      .longitude), //With this parameter you automatically obtain latitude and longitude
              infoWindow: InfoWindow(
                title: "Tu ubicación",
                snippet: 'Estás aquí',
              ),
              icon: BitmapDescriptor.defaultMarker,
            );
            markers[markerIdTarget] = markerTarget;

            return Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    new Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 14.0,
                  ),
                  markers: Set<Marker>.of(markers.values),
                  polylines: _polylines,
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
    setMarkers();
    setPolylines();
  }

  setMarkers() {
    setState(() {
      final MarkerId markerIdSource = MarkerId("1");
      Marker markerSource = Marker(
        markerId: markerIdSource,
        draggable: true,
        position: LatLng(latitude,
            longitude), //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: "Punto de llegada",
          snippet: 'Debes llegar a este lugar',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      markers[markerIdSource] = markerSource;
    });
  }

  setPolylines() async {
    print(markers);
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        "AIzaSyDMFGSvHB0MkQI3s3pNMOZ1Rsjk90R18Mg",
        markers[MarkerId("0")].position.latitude,
        markers[MarkerId("0")].position.longitude,
        markers[MarkerId("1")].position.latitude,
        markers[MarkerId("1")].position.longitude);
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }
}
