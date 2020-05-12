import 'dart:io';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/environment/config.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/gradients.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';

class EditCompanyPage extends StatefulWidget {
  EditCompanyPage({Key key}) : super(key: key);

  @override
  _EditCompanyPageState createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _nitFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  Company company = new Company();
  File _image; //foto de perfil de la empresa

  CompanyProvider companyProvider = new CompanyProvider();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _secondaryPhoneFocusNode = FocusNode();
  String category;
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
      company.profilePic = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    company = ModalRoute.of(context).settings.arguments;
    if (!mapChanged)
      _addMarkerLongPressed(LatLng(company.latitude, company.longitude));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Información de tu empresa',
            style: TextStyle(color: Colors.black)),
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
          Icon(Icons.add),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                _profilePhoto(),
                SizedBox(height: 10.0),
                _nameInput(),
                SizedBox(height: 10.0),
                _nitInput(),
                SizedBox(height: 10.0),
                _descriptionInput(),
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
                SizedBox(height: 10.0),
                _inputPhone(),
                SizedBox(height: 10.0),
                _inputSecondaryPhone(),
                SizedBox(height: 25.0),
                _inputCategory(),
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
              company.category = category;
              Geolocator()
                  .placemarkFromCoordinates(
                      markers[MarkerId("0")].position.latitude,
                      markers[MarkerId("0")].position.longitude)
                  .then((address) {
                company.address = address[0].thoroughfare;
                company.latitude = markers[MarkerId("0")].position.latitude;
                company.longitude = markers[MarkerId("0")].position.longitude;
                updateCompany(company);
              });
            }
          },
          textColor: Colors.white,
          child: Text("Guardar".toUpperCase(), style: TextStyle(fontSize: 15)),
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
        initialValue: company.name,
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
        initialValue: company.nit.toString(),
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
        initialValue: company.description,
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
            target: LatLng(company.latitude, company.longitude),
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

  Widget _inputPhone() {
    return ListTile(
      leading: const Icon(
        Icons.phone,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        initialValue: company.phone.toString(),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "Número de contacto (+57)",
        ),
        validator: (value) {
          if (value == '') {
            return 'Número inválido';
          }
          return null;
        },
        onSaved: (value) => company.phone = int.parse(value),
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _phoneFocusNode, _secondaryPhoneFocusNode);
        },
      ),
    );
  }

  Widget _inputSecondaryPhone() {
    return ListTile(
      leading: const Icon(
        Icons.phone_in_talk,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        initialValue: company.secondaryPhone.toString(),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "Número secundario (+57)",
        ),
        validator: (value) {
          if (value == '') {
            return 'Número inválido';
          }
          return null;
        },
        onSaved: (value) => company.secondaryPhone = int.parse(value),
      ),
    );
  }

  Widget _inputCategory() {
    return ListTile(
        leading: const Icon(
          Icons.category,
          color: Color.fromRGBO(0, 167, 255, 1.0),
          size: 30,
        ),
        title: new DropDownFormField(
          onSaved: (value) => company.category = value,
          onChanged: (value) {
            setState(() {
              category = value;
              company.category = value;
            });
          },
          value: company.category,
          titleText: 'Categoría',
          hintText: '',
          dataSource: [
            {'display': 'Logística', 'value': 'Logistica'},
            {'display': 'Publicidad', 'value': 'Publicidad'},
            {'display': 'Produccion', 'value': 'Produccion'},
            {'display': 'Entretenimiento', 'value': 'Entretenimiento'},
            {'display': 'Gastronomía', 'value': 'Gastronomia'},
          ],
          textField: 'display',
          valueField: 'value',
          validator: (value) {
            if (value == null) {
              value = company.category;
            }
            return null;
          },
        ));
  }

  _profilePhoto() {
    return Column(
      children: <Widget>[
        Container(
          height: 180.0,
          width: 180.0,
          child: FloatingActionButton(
              onPressed: getImage,
              tooltip: 'Pick Image',
              child: company.profilePic == '' && _image == null
                  ? CircleAvatar(
                      backgroundImage:
                          ExactAssetImage('assets/no-image.png'),
                      radius: 100.0,
                      backgroundColor: Colors.transparent,
                    )
                  : company.profilePic == '' && _image != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(_image),
                          radius: 100.0,
                          backgroundColor: Colors.transparent,
                        )
                      : company.profilePic != '' && _image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(_image),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(company.profilePic),
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
              Text('Borrar foto de perfil')
            ],
          ),
        ),
      ],
    );
  }

  void updateCompany(Company company) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Actualizando la empresa',
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
      company.profilePic = await firebaseProvider.uploadFile(
          _image, 'profilePic/' + _image.path.split('/').last, 'image');
    }

    Map<String, dynamic> data = await companyProvider.updateCompany(company);
    if (pr.isShowing()) pr.hide();
    if (data['ok']) {
      showAlert(context, 'Se ha actualizado satisfactoriamente');
    } else {
      data['message'] != null
          ? showAlert(
              context, "No es posible actualizar los datos. " + data['message'])
          : showAlert(context, "No es posible actualizar los datos.");
    }
  }
}
