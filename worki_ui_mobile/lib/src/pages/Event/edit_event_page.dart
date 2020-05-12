import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/environment/config.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/eventType_enum.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';

class EditEventPage extends StatefulWidget {
  EditEventPage({Key key}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _nitFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  Company company = new Company();
  Event event = new Event();
  File _image; //foto de perfil de la empresa
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  CoordinatorProvider coordinatorProvier = new CoordinatorProvider();
  String _coordinator = '';
  List<String> coordIds = [];
  List<String> coordNames = [];

  EventsProvider eventProvider = new EventsProvider();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _secondaryPhoneFocusNode = FocusNode();
  String category;
  String eventType;
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: '${EnvironmentConfig.MAPS_KEY}');
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool mapChanged = false;

  Future getImage() async {
    //Obtener imagen de la galería
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  removeImage() async {
    //Quitar imagen de la empresa
    setState(() {
      _image = null;
      event.eventPic = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context).settings.arguments;
    if(!mapChanged )_addMarkerLongPressed(LatLng(event.latitude, event.longitude)); 
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Editar Evento', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: Color.fromRGBO(0, 167, 255, 0.7)),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesome5.trash_alt, color: Colors.red, size: 18),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                       shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),
                      content: Text(
                          '¿Está seguro que desea eliminar este evento? Se eliminarán todos los trabajos y registros asociados:'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Si'),
                          onPressed: () async {
                            firestoreProvider.deleteChat(event.id);
                            eventProvider.deleteEvent(event.id);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            setState(() {});
                          },
                        ),
                        FlatButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20.0),
                _eventPhoto(),
                SizedBox(height: 10.0),
                _nameInput(),
                SizedBox(height: 10.0),
                _descriptionInput(),
                SizedBox(height: 10.0),
                _coordinatorInput(),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                  ],
                ),
                _addressInput(),
                SizedBox(height: 20.0),
                _inputTotalJobs(),
                SizedBox(height: 25.0),
                _inputEventType(),
                SizedBox(height: 25.0),
                _initialDateInput(),
                SizedBox(height: 25.0),
                _finalDateInput(),
                SizedBox(height: 25.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: Gradients.workiGradient),
        child: MaterialButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              Geolocator()
                  .placemarkFromCoordinates(
                      markers[MarkerId("0")].position.latitude,
                      markers[MarkerId("0")].position.longitude)
                  .then((address) {
                event.address = address[0].thoroughfare;
                event.latitude = markers[MarkerId("0")].position.latitude;
                event.longitude = markers[MarkerId("0")].position.longitude;
                updateEvent(event);
              });
            }
          },
          textColor: Colors.white,
          child: Text("Guardar".toUpperCase(), style: TextStyle(fontSize: 14)),
        ),
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
        initialValue: event.name,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _nameFocusNode,
        decoration: new InputDecoration(
          hintText: "Nombre del evento",
        ),
        validator: (value) {
          if (value == '') {
            return 'Nombre inválido';
          }
          return null;
        },
        onSaved: (value) => event.name = value,
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
        initialValue: event.description,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _descriptionFocusNode,
        maxLines: 3,
        decoration: new InputDecoration(
          hintText: "Descripción del evento",
        ),
        validator: (value) {
          if (value == '') {
            return 'Descripción inválida';
          }
          return null;
        },
        onSaved: (value) => event.description = value,
      ),
    );
  }

  _addressInput() {
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
            target: LatLng(event.latitude, event.longitude),
            zoom: 14.0,
          ),
          onLongPress: (latlang) {
            _addMarkerLongPressed(latlang);
          },
          markers: Set<Marker>.of(markers.values),
        ),
      ),
    );
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
          snippet: 'Ubicación del evento.',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      markers[markerId] = marker;
      mapChanged = true;
    });

    //This is optional, it will zoom when the marker has been created
    mapController.animateCamera(CameraUpdate.newLatLngZoom(latlang, 17.0));
  }

  Widget _inputTotalJobs() {
    return ListTile(
      leading: const Icon(
        Icons.group,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        initialValue: event.totalJobs.toString(),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "Número de trabajos",
        ),
        validator: (value) {
          if (value == '') {
            return 'Número inválido';
          }
          return null;
        },
        onSaved: (value) => event.totalJobs = int.parse(value),
      ),
    );
  }

  Widget _inputEventType() {
    Map<String, String> type = {
      'PUBLICIDAD': 'ADVERTISING',
      'LOGISTICA': 'LOGISTICS',
      'PRODUCCIÓN': 'PRODUCTION',
      'E. MERCADO': 'MARKET_STUDIES',
      'OTROS': 'OTHER',
      '': null
    };
    return ListTile(
      leading: Icon(
        Icons.playlist_add_check,
        color: AppColors.workiColor,
        size: 30,
      ),
      title: DropdownButton(
          hint: Text('Tipo'),
          isExpanded: true,
          value: type.keys.firstWhere(
              (k) => type[k] == EnumToString.parse(event.eventType)),
          itemHeight: 50.0,
          items: <String>[
            'PUBLICIDAD',
            'LOGISTICA',
            'PRODUCCIÓN',
            'E. MERCADO',
            'OTROS',
            ''
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              event.eventType =
                  EnumToString.fromString(EventType.values, type[newValue]);
            });
            print(event.eventType);
          }),
    );
  }

  Widget _initialDateInput() {
    return ListTile(
      leading: Icon(Icons.event, size: 30, color: AppColors.workiColor),
      title: DateTimeField(
        //focusNode: _initialDateFocusNode,
        format: DateFormat('yyyy-MM-dd'),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2021));
        },
        initialValue: event.initialDate,
        validator: (value) {
          if (value == null) {
            return 'Fecha inicial inválida';
          }
          return null;
        },
        onSaved: (value) => event.initialDate = value,
      ),
    );
  }

  Widget _finalDateInput() {
    return ListTile(
      leading: Icon(Icons.event, size: 30, color: AppColors.workiColor),
      title: DateTimeField(
        format: DateFormat('yyyy-MM-dd'),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2021));
        },
        initialValue: event.finalDate,
        validator: (value) {
          if (value == null) {
            return 'Fecha final inválida';
          }
          return null;
        },
        onSaved: (value) {
          event.finalDate = value;
        },
      ),
    );
  }

  _eventPhoto() {
    return Column(
      children: <Widget>[
        Container(
          height: 180.0,
          width: 180.0,
          child: FloatingActionButton(
              onPressed: getImage,
              tooltip: 'Pick Image',
              child: event.eventPic == '' && _image == null
                  ? CircleAvatar(
                      backgroundImage: ExactAssetImage('assets/no-image.png'),
                      radius: 100.0,
                      backgroundColor: Colors.transparent,
                    )
                  : event.eventPic == '' && _image != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(_image),
                          radius: 100.0,
                          backgroundColor: Colors.transparent,
                        )
                      : event.eventPic != '' && _image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(_image),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(event.eventPic),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )),
        ),
        SizedBox(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            removeImage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.delete, color: Color.fromRGBO(0, 167, 255, 1.0)),
              Text('Borrar foto del evento')
            ],
          ),
        ),
      ],
    );
  }

  void updateEvent(Event event) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Actualizando evento',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    pr.show();
    if (_image != null) {
      event.eventPic = await firebaseProvider.uploadFile(
          _image, 'eventPic/' + _image.path.split('/').last, 'image');
    }

    final data = await eventProvider.updateEvent(event);
    if (pr.isShowing()) pr.hide();
    if (data) {
      await firestoreProvider.updateChat(event.id, event.name,event.eventPic);
      showAlert(context, 'Se ha actualizado satisfactoriamente');
    } else {
      data['message'] != null
          ? showAlert(
              context, "No es posible actualizar los datos. " + data['message'])
          : showAlert(context, "No es posible actualizar los datos.");
    }
  }

  Widget _coordinatorInput() {
    return FutureBuilder(
        future: coordinatorProvier.getCoordinatorsByCompanyId(event.companyId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Coordinator> coord = snapshot.data;
            List<String> names = [];
            coord.forEach((f) {
              names.add(f.name + ' - ' + f.email);
              event.coordinatorsId.forEach((c) {
                if (c == f.id) {
                  if (!coordNames.contains(f.name)) {
                    coordNames.add(f.name);
                  }
                }
              });
            });
            names.add('');

            return Column(children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text('Coordinadores:'),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: AppColors.workiColor,
                  size: 30,
                ),
                title: DropdownButton(
                    hint: Text('Coordinador'),
                    isExpanded: true,
                    value: _coordinator,
                    itemHeight: 50.0,
                    items: names.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _coordinator = newValue;
                        print(coordNames.toString());
                      });
                    }),
                trailing: IconButton(
                    icon: Icon(Icons.add_circle_outline,
                        color: AppColors.workiColor),
                    onPressed: () {
                      setState(() {
                        coord.forEach((f) {
                          var aux = f.name + ' - ' + f.email;
                          if (aux == _coordinator) {
                            if (!event.coordinatorsId.contains(f.id)) {
                              event.coordinatorsId.add(f.id);
                              coordNames.add(f.name);
                            }
                          }
                        });
                        _coordinator = '';
                      });
                    }),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: event.coordinatorsId.length == 0 ? 0 : 50,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemCount: coordNames.length,
                  itemBuilder: (context, i) {
                    return Chip(
                      label: Text(coordNames[i]),
                      onDeleted: () {
                        coord.forEach((c) {
                          if (c.name == coordNames[i]) {
                            event.coordinatorsId.remove(c.id);
                          }
                        });
                        coordNames.removeAt(i);
                        setState(() {});
                      },
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      deleteIconColor: AppColors.workiColor,
                    );
                  },
                ),
              ),
            ]);
          } else {
            return Column(children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text('Coordinadores:'),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: AppColors.workiColor,
                  size: 30,
                ),
                title: DropdownButton(
                    hint: Text('Coordinador'),
                    isExpanded: true,
                    value: _coordinator,
                    itemHeight: 50.0,
                    items: [''].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) {}),
                trailing: IconButton(
                    icon: Icon(Icons.add_circle_outline,
                        color: AppColors.workiColor),
                    onPressed: () {}),
              )
            ]);
          }
        });
  }
}
