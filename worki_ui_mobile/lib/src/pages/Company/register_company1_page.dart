import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:worki_ui/src/environment/config.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';

class RegisterCompany1Page extends StatefulWidget {
  @override
  RegisterCompany1PageState createState() => RegisterCompany1PageState();
}

class RegisterCompany1PageState extends State<RegisterCompany1Page> {
  Company company = new Company();
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: '${EnvironmentConfig.MAPS_KEY}');

  final _formKey = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _nitFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final homeScaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text('Registro de empresa', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        elevation: 0.0,
        leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: Color.fromRGBO(0, 167, 255, 0.7)),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          Icon(Icons.add),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      backgroundImage: ExactAssetImage('assets/logo.png'),
                      radius: 60.0,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Divider(
                    height: 30.0,
                  ),
                  SizedBox(width: 10.0),
                  Center(
                    child: Text(
                      'Háblanos de tu empresa',
                      style: TextStyle(
                          fontFamily: 'Trebuchet',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        _nameInput(),
                        SizedBox(height: 10.0),
                        _nitInput(),
                        SizedBox(height: 10.0),
                        _descriptionInput(),
                        SizedBox(height: 10.0),
                        Text("Ubicación", style: TextStyle(fontSize: 20)),
                        SizedBox(height: 10.0),
                        RaisedButton(
                          onPressed: () async {
                            // show input autocomplete with selected mode
                            // then get the Prediction selected
                            Prediction p = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: '${EnvironmentConfig.MAPS_KEY}',
                                mode: Mode.overlay);
                            displayPrediction(p);
                          },
                          child: Text('Buscar dirección'),
                        ),
                        _addressInput(),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 100.0),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: ButtonDecoration.workiButton,
              child: MaterialButton(
                minWidth: 200,
                onPressed: () {
                  if (markers.length == 0) {
                    showAlert(context, 'Debes marcar la ubicación de la empresa');
                  } else if (_formKey.currentState.validate()) {
                    Geolocator()
                        .placemarkFromCoordinates(
                            markers[MarkerId("0")].position.latitude,
                            markers[MarkerId("0")].position.longitude)
                        .then((address) {
                      company.address = address[0].thoroughfare;
                      company.latitude = markers[MarkerId("0")].position.latitude;
                      company.longitude = markers[MarkerId("0")].position.longitude;
                      company.city = address[0].locality;
                      _formKey.currentState.save();
                      print(company.toJson());
                      Navigator.of(context)
                          .pushNamed('registerCompany2', arguments: company);
                    });
                  }
                },
                textColor: Colors.white,
                child:
                    Text("Siguiente".toUpperCase(), style: TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      _places.getDetailsByPlaceId(p.placeId).then((detail) async {
        var placeId = p.placeId;
        double lat = detail.result.geometry.location.lat;
        double lng = detail.result.geometry.location.lng;

        var address =
            await Geocoder.local.findAddressesFromQuery(p.description);

        print(lat);
        print(lng);
        setState(() {
          final MarkerId markerId = MarkerId("0");
          Marker marker = Marker(
            markerId: markerId,
            draggable: true,
            position: LatLng(lat,
                lng), //With this parameter you automatically obtain latitude and longitude
            infoWindow: InfoWindow(
              title: "Ubicación",
              snippet: 'Has marcado aquí',
            ),
            icon: BitmapDescriptor.defaultMarker,
          );
          markers[markerId] = marker;
          mapController.animateCamera(
              CameraUpdate.newLatLngZoom(LatLng(lat, lng), 17.0));
        });
      });
    }
  }

  Widget _nameInput() {
    return new ListTile(
      leading: const Icon(
        Icons.business,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        textCapitalization: TextCapitalization.sentences,
        focusNode: _nameFocusNode,
        decoration: new InputDecoration(
          hintText: "Nombre de la empresa",
        ),
        validator: (value) {
          if (value == '') {
            return 'Nombre inválido';
          }
          return null;
        },
        onSaved: (value) => company.name = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _nameFocusNode, _nitFocusNode);
        },
      ),
    );
  }

  Widget _nitInput() {
    return new ListTile(
      leading: const Icon(
        Icons.assignment,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        focusNode: _nitFocusNode,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "NIT de tu empresa",
        ),
        validator: (value) {
          if (value == '') {
            return 'NIT inválido';
          }
          return null;
        },
        onSaved: (value) => company.nit = int.parse(value),
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _nitFocusNode, _descriptionFocusNode);
        },
      ),
    );
  }

  Widget _descriptionInput() {
    return new ListTile(
      leading: const Icon(
        Icons.description,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        textCapitalization: TextCapitalization.sentences,
        focusNode: _descriptionFocusNode,
        maxLines: 3,
        decoration: new InputDecoration(
          hintText: "Descripción de la empresa",
        ),
        validator: (value) {
          if (value == '') {
            return 'Descripción inválida';
          }
          return null;
        },
        onSaved: (value) => company.description = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _descriptionFocusNode, null);
        },
      ),
    );
  }

  _addressInput() {
    return FutureBuilder(
        future: Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
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
                  onLongPress: (latlang) {
                    _addMarkerLongPressed(latlang);
                  },
                  markers: Set<Marker>.of(markers.values),
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
    mapController = controller;
  }

  Future _addMarkerLongPressed(LatLng latlang) async {
    setState(() {
      final MarkerId markerId = MarkerId("0");
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position:
            latlang, //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: "Ubicación",
          snippet: 'Has marcado aquí',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      markers[markerId] = marker;
    });

    //This is optional, it will zoom when the marker has been created
    mapController.animateCamera(CameraUpdate.newLatLngZoom(latlang, 17.0));
  }
}
