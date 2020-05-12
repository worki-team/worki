import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:worki_ui/src/environment/config.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/eventType_enum.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/values/values.dart';
import '../../models/event_model.dart';
import '../../providers/event_provider.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';

class AddEventPage extends StatefulWidget {
  final Administrator admin;
  const AddEventPage({@required this.admin});

  @override
  _AddEventPageState createState() => _AddEventPageState(admin: this.admin);
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  Administrator admin;
  Company company;
  Map<String, dynamic> arguments;
  _AddEventPageState({this.admin});
  Event event = new Event();
  List<String> types = new List(5);
  EventsProvider eventsProvider = new EventsProvider();
  File _image;
  String eventType;
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  CoordinatorProvider coordinatorProvier = new CoordinatorProvider();
  String _coordinator = '';
  List<String> coordIds = [];
  List<String> coordNames = [];

  FocusNode _nameFocusNode = new FocusNode();
  FocusNode _descriptionFocusNode = new FocusNode();
  FocusNode _totalJobsFocusNode = new FocusNode();
  FocusNode _initialDateFocusNode = new FocusNode();
  FocusNode _finalDateFocusNode = new FocusNode();

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: '${EnvironmentConfig.MAPS_KEY}');

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

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
    });
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    admin = arguments['admin'];
    company = arguments['company'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Crear Evento',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        elevation: 0.0,
        iconTheme: IconThemeData(color: AppColors.workiColor),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                _nameInput(),
                _descriptionInput(),
                _coordinatorInput(),
                _totalJobsInput(),
                _initialDateInput(),
                _finalDateInput(),
                _typeEventInput(),
                SizedBox(height: 10.0),
                Text("Ubicación del evento", style: TextStyle(fontSize: 20)),
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
                _eventPicture(),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _submitButton(),
    );
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
    return ListTile(
      leading: Icon(Icons.note_add, size: 30, color: AppColors.workiColor),
      title: TextFormField(
        autofocus: false,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _nameFocusNode,
        decoration: InputDecoration(
          labelText: 'Nombre',
        ),
        onSaved: (value) => event.name = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _nameFocusNode, _descriptionFocusNode);
        },
      ),
    );
  }

  Widget _descriptionInput() {
    return ListTile(
      leading: Icon(Icons.description, size: 30, color: AppColors.workiColor),
      title: TextFormField(
        autofocus: false,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _descriptionFocusNode,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Descripción',
        ),
        onSaved: (value) {
          event.description = value;
        },
      ),
    );
  }

  Widget _addressInput() {
    return FutureBuilder(
        future: Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Container(
              height: 400,
              width: 400,
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
                  zoom: 12.0,
                ),
                onLongPress: (latlang) {
                  _addMarkerLongPressed(latlang);
                },
                markers: Set<Marker>.of(markers.values),
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

  Widget _totalJobsInput() {
    return ListTile(
      leading: Icon(Icons.supervised_user_circle,
          size: 30, color: AppColors.workiColor),
      title: TextFormField(
        autofocus: false,
        focusNode: _totalJobsFocusNode,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Total de trabajos',
        ),
        onSaved: (value) => event.totalJobs = int.parse(value),
      ),
    );
  }

  Widget _initialDateInput() {
    return ListTile(
      leading: Icon(Icons.event, size: 30, color: AppColors.workiColor),
      title: DateTimeField(
        focusNode: _initialDateFocusNode,
        format: DateFormat('yyyy-MM-dd'),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2021));
        },
        decoration: new InputDecoration(
          labelText: "Fecha Inicial",
        ),
        validator: (value) {
          if (value == null) {
            return 'Fecha inicial inválida';
          }
          return null;
        },
        onSaved: (value) => event.initialDate = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _initialDateFocusNode, _finalDateFocusNode);
        },
      ),
    );
  }

  Widget _finalDateInput() {
    return ListTile(
      leading: Icon(Icons.event, size: 30, color: AppColors.workiColor),
      title: DateTimeField(
        focusNode: _finalDateFocusNode,
        format: DateFormat('yyyy-MM-dd'),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2021));
        },
        decoration: new InputDecoration(
          labelText: "Fecha final",
        ),
        validator: (value) {
          if (value == null) {
            return 'Fecha final inválida';
          }
          return null;
        },
        onSaved: (value) {
          event.finalDate = value;
        },
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _initialDateFocusNode, _finalDateFocusNode);
        },
      ),
    );
  }

  Widget _typeEventInput() {
     Map<String, String> type = {
      'PUBLICIDAD' : 'ADVERTISING',
      'LOGISTICA' : 'LOGISTICS',
      'PRODUCCIÓN' : 'PRODUCTION',
      'E. MERCADO' : 'MARKET_STUDIES',
      'OTROS':'OTHER',
      '':null
    };
    return ListTile(
      leading: Icon(Icons.playlist_add_check, color: AppColors.workiColor, size: 30,),
      title: DropdownButton(
          hint: Text('Tipo'),
          isExpanded: true,
          value: type.keys.firstWhere((k) => type[k] == EnumToString.parse(event.eventType)),
          itemHeight: 50.0,
          items: <String>['PUBLICIDAD','LOGISTICA','PRODUCCIÓN','E. MERCADO','OTROS','']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              event.eventType = EnumToString.fromString(EventType.values, type[newValue]);
            });
            print(event.eventType);
          }
      ),
    );
  }

  Widget _coordinatorInput() {
    return FutureBuilder(
      future: coordinatorProvier.getCoordinatorsByCompanyId(admin.companyId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          List<Coordinator> coord = snapshot.data;
          List<String> names = [];
          coord.forEach((f){
            names.add(f.name + ' - '+f.email);
          });
          names.add('');
          return Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Text('Coordinadores:'),
              ListTile(
                leading: Icon(Icons.person, color: AppColors.workiColor, size: 30,),
                title: DropdownButton(
                  hint: Text('Coordinador'),
                  isExpanded: true,
                  value: _coordinator,
                  itemHeight: 50.0,
                  items: names
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                        _coordinator = newValue;
                    });
                  }
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add_circle_outline, color: AppColors.workiColor),
                  onPressed: (){
                    setState(() {
                      coord.forEach((f){
                        var aux = f.name+' - '+f.email;
                        if(aux == _coordinator){
                          if(!coordIds.contains(f.id)){
                            coordIds.add(f.id);
                            coordNames.add(f.name);
                          }
                        }
                      });
                      _coordinator = '';
                    });
                  }
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: coordIds.length == 0 ? 0 : 50,
                child: ListView(
                  padding: EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  children: <Widget>[
                    for(int i=0; i<coordIds.length; i++)
                    Chip(
                      label: Text(coordNames[i]),
                      onDeleted: (){
                        setState(() {
                          coordIds.removeAt(i);
                          coordNames.removeAt(i);
                        });
                      },
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      deleteIconColor: AppColors.workiColor,
                    ),
                  ],
                  
                ),
              ),
            ]
          );
        }else{
          return  Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Text('Coordinadores:'),
              ListTile(
                leading: Icon(Icons.person, color: AppColors.workiColor, size: 30,),
                title: DropdownButton(
                  hint: Text('Coordinador'),
                  isExpanded: true,
                  value: _coordinator,
                  itemHeight: 50.0,
                  items: ['']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                   
                  }
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add_circle_outline, color: AppColors.workiColor),
                  onPressed: (){
                    
                  }
                ),
              )
            ]
          );
        }
      }
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: ButtonDecoration.workiButton,
      child: FlatButton(
          onPressed: () {
            if (markers.length == 0) {
              showAlert(context, 'Debes marcar la ubicación del evento');
            } else if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              Geolocator()
                  .placemarkFromCoordinates(
                      markers[MarkerId("0")].position.latitude,
                      markers[MarkerId("0")].position.longitude)
                  .then((address) {
                event.address =
                    address[0].thoroughfare + ' ' + address[0].locality;
                event.latitude = markers[MarkerId("0")].position.latitude;
                event.longitude = markers[MarkerId("0")].position.longitude;
                event.coordinatorsId = coordIds;
                //event.id;
                saveEvent(event);
              });
            } else {
              showAlert(context, 'No es posible crear el evento');
            }
          },
          child: Text(
            'Guardar',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  saveEvent(Event event) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Creando Evento',
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
          _image, 'event/' + _image.path.split('/').last, 'image');
    }
    event.companyId = company.id;
    event.state = true;
    EventsProvider().saveEvent(event).then((resp) {
      if (pr.isShowing()) pr.hide();

      if (resp['ok']) {
        showAlert(context, 'Evento creado exitosamente');
        List<User> userIds = new List<User>();
        User fireUser = new User();
        fireUser.id = admin.id;
        fireUser.name = admin.name;
        fireUser.profilePic = admin.profilePic;
        fireUser.roles = admin.roles;
        userIds.add(fireUser);
        firestoreProvider.createChat(resp['event']['id'], event.name, event.eventPic != null ?event.eventPic : '', userIds)
            .then((docRef) {
          Navigator.of(context).pushReplacementNamed('admin_main',
              arguments: {'admin': admin, 'company': company});
        });
      } else {
        showAlert(context,
            'Parece que ha ocurrido un error, por favor intenta de nuevo');
      }
    });
  }

  Widget _eventPicture() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Fotografía',
                  style: TextStyle(
                      fontFamily: 'Trebuchet', fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    removeImage();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.delete,
                          color: Color.fromRGBO(0, 167, 255, 1.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 180.0,
            width: 500,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black12),
            child: FlatButton(
                onPressed: getImage,
                child: _image == null
                    ? Center(
                        child: Icon(Icons.image, color: Colors.white, size: 40))
                    : Image.file(_image)),
          ),
        ],
      ),
    );
  }
}
