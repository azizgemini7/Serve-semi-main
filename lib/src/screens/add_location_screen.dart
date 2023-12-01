import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:geocoding/geocoding.dart' as gl;

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/mixins/validation_mixin.dart';
import 'package:Serve_ios/src/models/address.dart';
import 'package:Serve_ios/src/models/city.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/providers/global_data.dart';
import 'package:Serve_ios/src/providers/maps.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as mylocationpac;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLocationScreen extends StatefulWidget {
  static const routeName = '/add-location';

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen>
    with AlertsMixin, ValidationMixin {
  String placeId;
  Location placeLocation;
  GoogleMapController mapController;
  Addresses _addressesReference;
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    mapController = controller;
    print("Called _onMapCreated");

    getSelectedLocationRes();
    Future.delayed(Duration(microseconds: 50), () {});

    if (!calledDirections) if (addressToEdit == null) {
      if (_mapsProvider.currentLocation != null) {
        // setState(() {
        setHomeMarker(_mapsProvider.currentLocation.latitude,
            _mapsProvider.currentLocation.longitude);
        // });
        mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
            _mapsProvider.currentLocation.latitude,
            _mapsProvider.currentLocation.longitude)));
      }
    } else {
      // setState(() {
      setMarker(double.parse(addressToEdit.latitude),
          double.parse(addressToEdit.longitude));
      // });
      Future.delayed(Duration(milliseconds: 1000), () {
        print("Moved to address");

        mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
            double.parse(addressToEdit.latitude),
            double.parse(addressToEdit.longitude))));
      });
    }

    // print("addressToEdit ${addressToEdit.address}");

    if (_mapsProvider.currentLocation != null || addressToEdit != null) {
      getPointDetails(addressToEdit == null
          ? _mapsProvider.currentLocation != null
              ? Location(_mapsProvider.currentLocation.latitude,
                  _mapsProvider.currentLocation.longitude)
              : Location(0.0, 0.0)
          : Location(double.parse(addressToEdit.latitude),
              double.parse(addressToEdit.longitude)));
    }
    // getPointDetails(Location(_mapsProvider.currentLocation.latitude,
    //     _mapsProvider.currentLocation.longitude));
    // mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
    //     _mapsProvider.currentLocation.latitude,
    //     _mapsProvider.currentLocation.longitude)));
    // mapController.moveCamera(CameraUpdate.newLatLng(LatLng(
    //     _mapsProvider.currentLocation.latitude,
    //     _mapsProvider.currentLocation.longitude)));

    // });
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    } else {
      print("Future already Completed!");
    }

    // getUserCurrentLocation().then((value) => {
    //       if (!calledDirections)
    //         getPointDetails(Location(value.latitude, value.longitude)),
    //       //   mapController.animateCamera(
    //       // CameraUpdate.newLatLng(LatLng(value.latitude, value.longitude))),
    //       //   setState(() {
    //       //     setMarker(value.latitude, value.longitude);
    //       //   }),
    //       if (!_controller.isCompleted)
    //         {
    //           _controller.complete(controller),
    //         }
    //       else
    //         {
    //           print("Future already Completed!"),
    //         }
    //     });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  MapsProvider _mapsProvider;

  Set<Marker> markers;
  Map<String, Marker> addmarkers = {};
  bool calledDirections = false;
  DirectionsResponse _directionsResponse;

  Set<Marker> _myMarker;
  Future<void> getPointDetails2(Location location,
      [String address = '']) async {
    // _choosePlace(location, address);
    calledDirections = true;
    try {
      final placesMarks = await gl.placemarkFromCoordinates(
          location.lat, location.lng,
          localeIdentifier: Localizations.localeOf(context).languageCode);
      final geocodedLocation = [
        placesMarks?.first?.subThoroughfare ?? "",
        placesMarks?.first?.thoroughfare ?? "",
        placesMarks?.first?.locality ?? "",
        placesMarks?.first?.administrativeArea ?? "",
        placesMarks?.first?.postalCode ?? "",
      ];
      geocodedLocation.removeWhere((element) => element.isEmpty);
      detaoisl.text = geocodedLocation.join(", ");
      print("detaoisl==getPointDetails2:: " + detaoisl.text);

      _choosePlace(location, geocodedLocation.join(", "));
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString());
    } catch (error) {
      throw error;
    }
  }

  Future<void> getPointDetails(Location location) async {
    // _choosePlace(location, '');
    getPointDetails2(location);
    calledDirections = true;
    // try {
    //   print('getttttttttttt');
    // GeocodingResponse response = await _mapsProvider.getGeoDetails(
    //     location, _addressesReference.appLanguage);
    //     print(response.results);
    //  _choosePlace(location, response.results.first.formattedAddress);
    // } on HttpException catch (error) {
    //   showErrorDialog(context, error.toString(), null);
    // } catch (error) {
    //   throw error;
    // }
  }

  Address addressToEdit;

  Future<void> setMarker(double lat, double lng) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/pin.png', 150);
    _myMarker = [
      Marker(
        markerId: MarkerId('myLocation'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: LatLng(lat, lng),
//        anchor: Offset(0.0, -75.0),
      )
    ].toSet();

    final MarkerId markerId = MarkerId("myLocation");

    addmarkers["myLocation"] = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markerIcon),
      // infoWindow: infoWindowTitle == null
      //     ? null
      //     : InfoWindow(title: infoWindowTitle, snippet: infoWindowSnippet),
      position: LatLng(lat, lng),
      // anchor: Offset(0.0, -75.0),
    );
  }

  Future<void> setHomeMarker(double lat, double lng) async {
    final MarkerId markerId = MarkerId("myhome");

    addmarkers["myhome"] = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarker,
      // infoWindow: infoWindowTitle == null
      //     ? null
      //     : InfoWindow(title: infoWindowTitle, snippet: infoWindowSnippet),
      position: LatLng(lat, lng),
      // anchor: Offset(0.0, -75.0),
    );
  }

  GlobalData _globalDataReference;

  @override
  void didChangeDependencies() {
    _mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    _globalDataReference = Provider.of<GlobalData>(context, listen: false);
    _addressesReference = Provider.of<Addresses>(context, listen: false);

    // getUserCurrentLocation().then((value) =>
    //     {grapUserLocation(Location(value.latitude, value.longitude))});

    // print(
    // "_addressesReference.selectedAddress ${_addressesReference.selectedAddress.address}");

    detaoisl.text = _addressesReference.selectedAddress != null
        ? _addressesReference.selectedAddress.address
        : '';
    if (mapController != null) {
      print("Called mapController");

      getUserCurrentLocation().then((value) => {
            if (!calledDirections)
              getPointDetails(Location(value.latitude, value.longitude)),
            mapController.animateCamera(CameraUpdate.newLatLng(
                LatLng(value.latitude, value.longitude))),
            // setState(() {
            // setHomeMarker(value.latitude, value.longitude),
            // }),
          });
      if (addressToEdit == null) {
        setState(() {
          setHomeMarker(_mapsProvider.currentLocation.latitude,
              _mapsProvider.currentLocation.longitude);
        });
        mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
            _mapsProvider.currentLocation.latitude,
            _mapsProvider.currentLocation.longitude)));
      } else {
        setState(() {
          setMarker(double.parse(addressToEdit.latitude),
              double.parse(addressToEdit.longitude));
        });
        mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
            double.parse(addressToEdit.latitude),
            double.parse(addressToEdit.longitude))));
      }
    }

    print("Called add location");
    final Map args = ModalRoute.of(context).settings.arguments ?? {};
    addressToEdit = args['address'];

    if (_globalDataReference.cities == null ||
        _globalDataReference.cities.length == 0) {
      print("No Cities Found Calling _getCities()");
      // _getCities();
    }
    if (addressToEdit == null)
      getSelectedLocationRes();
    else {
      print("addressToedit : Not NUll");
      _locationData['city_id'] = '${addressToEdit.cityId}';
      getSelectedLocationRes();
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  grapUserLocation(Location location) async {
    try {
      print('Getting location');
      getPointDetails(location);
      // GeocodingResponse response = await _mapsProvider.getGeoDetails(
      //     location, _addressesReference.appLanguage);
      // print(response.results);
      // _choosePlace(location, response.results.first.formattedAddress);
    } on HttpException catch (error) {
      // showErrorDialog(context, error.toString(), null);
    } catch (error) {
      throw error;
    }
  }

  getSelectedLocationRes() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('selectedaddress')) {
      final saddress = prefs.getString('selectedaddress');
      final saddressLng = prefs.getString('selectedaddressLng');
      final saddressLat = prefs.getString('selectedaddressLat');

      // _choosePlace(Location(double.parse(saddressLat),
      // double.parse(saddressLng)),saddress);

      // setMarker(double.parse(saddressLat ?? ""), double.parse(saddressLng ?? ""));
      // addressToEdit.address = saddress;
      setMarker(
          double.parse(saddressLat ?? "0.0"), double.parse(saddressLng ?? "0.0"));
      currentAddress = saddress;
      chosenLocation = Location(
          double.parse(saddressLat ?? "0.0"), double.parse(saddressLng ?? "0.0"));
      // print("getSelectedLocationRes ${saddress}");
      // print(
      //     "getSelectedLocationCoords Lng :: ${saddressLng} Lat :: ${saddressLat}");
      // _orderData['s_address'] = saddress;
    }
  }

  String currentAddress = '';

  Location chosenLocation;

  void _choosePlace(Location location, String name) {
    chosenLocation = location;
    currentAddress = name;
    detaoisl.text = name;
    print("_editingController==_choosePlace:: " + detaoisl.text);
    Future.delayed(Duration(milliseconds: 1200), () {
      print("Moved");
      mapController.animateCamera(
          CameraUpdate.newLatLng(LatLng(location.lat, location.lng)));
    });

    setState(() {
      setMarker(location.lat, location.lng);
    });
  }

  Future<void> _goToPlace(String placeId) async {
    try {
      PlaceDetails _placeDetails = await _mapsProvider.getPlaceDetails(
          placeId, _addressesReference.appLanguage);
      setMarker(_placeDetails.geometry.location.lat,
          _placeDetails.geometry.location.lng);
      _choosePlace(_placeDetails.geometry.location, _placeDetails.name);
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString(), null);
    } catch (error) {
      throw error;
    }
  }

  TextEditingController _editingController = TextEditingController();

//  Set<prefix0.Polyline> _myPolyLines;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<void> _getCities() async {
    bool _isLoading = false;

    try {
      setState(() {
        _isLoading = true;
      });
      await _globalDataReference.fetchCities();

      print("Called _getCities:: ");
    } on HttpException catch (e) {
      showErrorDialog(context, e.toString());
    } catch (e) {
      throw e;
    } finally {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  Map _locationData = {
    'longitude': '',
    'latitude': '',
    'city_id': '',
    'address': ''
  };
  final GlobalKey<FormState> _addLocationFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _addAddress() async {
    if (_addLocationFormKey.currentState.validate()) {
      _addLocationFormKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      // _locationData['longitude'] = chosenLocation.lng?.toString();
      // _locationData['latitude'] = chosenLocation.lat?.toString();
      // _locationData['address'] = _editingController.text;
      _locationData['longitude'] = chosenLocation.lng.toString();
      _locationData['latitude'] = chosenLocation.lat.toString();
      _locationData['address'] = detaoisl.text;
      print("detaoisl==_addAddress:: " + detaoisl.text);
      _locationData['is_home'] = '1';
      try {
        final regResponse =
            await _addressesReference.addAddress(json.encode(_locationData));
        Navigator.of(context).pop(true);
      } on HttpException catch (error) {
        showErrorDialog(
            context, error.toString(), Duration(milliseconds: 1500));
      } catch (error) {
        throw error;
      } finally {
        if (this.mounted)
          setState(() {
            _isLoading = false;
          });
      }
    }
  }

  Future<void> _editAddress() async {
    if (_addLocationFormKey.currentState.validate()) {
      _addLocationFormKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      _locationData['longitude'] = chosenLocation.lng?.toString();
      _locationData['latitude'] = chosenLocation.lat?.toString();
      _locationData['address'] = detaoisl.text;
      print("_editingController==_editAddress:: " + detaoisl.text);
      _locationData['address_id'] = '${addressToEdit.id}';
      _locationData['is_home'] = '1';
      try {
        final regResponse =
            await _addressesReference.editAddress(json.encode(_locationData));
        Navigator.of(context).pop(true);
      } on HttpException catch (error) {
        showErrorDialog(
            context, error.toString(), Duration(milliseconds: 1500));
      } catch (error) {
        throw error;
      } finally {
        if (this.mounted)
          setState(() {
            _isLoading = false;
          });
      }
    }
  }

  getinitialLocation() {
    var location = new mylocationpac.Location();
    var myLat, myLng;

    location
        .getLocation()
        .then((value) => {myLat = value.latitude, myLng = value.longitude});

    mylocationpac.LocationData currentLocation;
    try {
      currentLocation = mylocationpac.LocationData.fromMap(
          {'latitude': myLat, 'longitude': myLng});

      print("currentLocation ${currentLocation}");
    } on Exception {
      currentLocation = Location(0.0, 0.0) as mylocationpac.LocationData;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(microseconds: 50), () {});

    final prefs = SharedPreferences.getInstance();
    var saddress, saddressLng, saddressLat;
    prefs.then((value) => {
          value.containsKey('selectedaddress'),
          saddress = value.getString('selectedaddress'),
          saddressLng = value.getString('selectedaddressLng'),
          saddressLat = value.getString('selectedaddressLat')
        });

    var lat, lng;

    getUserCurrentLocation().then((value) => {
          lat = value.latitude,
          lng = value.longitude,
        });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          addressToEdit == null
              ? AppLocalizations.of(context).addLocation
              : AppLocalizations.of(context).editAddress,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xDE000000),
              letterSpacing: 0.26),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
            child: FutureBuilder(
              future:
                  Provider.of<GlobalData>(context, listen: false).fetchCities(),
              builder: (_, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Form(
                      key: _addLocationFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 360 / 370,
                            child: GoogleMap(
                              scrollGesturesEnabled: true,
                              zoomGesturesEnabled: true,
                              compassEnabled: true,
                              indoorViewEnabled: true,
                              myLocationEnabled: true,
                              minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                              onTap: (LatLng latLng) {
                                getPointDetails(Location(
                                    latLng.latitude, latLng.longitude));
                              },
                              tiltGesturesEnabled: true,
                              rotateGesturesEnabled: true,
                              initialCameraPosition: CameraPosition(
                                  target: addressToEdit != null
                                      ? LatLng(
                                          double.parse(
                                              lat ?? addressToEdit.latitude),
                                          double.parse(
                                              lng ?? addressToEdit.longitude))
                                      : LatLng(lat ?? 0.0, lng ?? 0.0),
                                  zoom: 15.0),
                              myLocationButtonEnabled: true,
                              onMapCreated: _onMapCreated,
                              markers: Set<Marker>.of(addmarkers.values),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Text(
                              AppLocalizations.of(context).streetName,
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A).withOpacity(0.7),
                                  fontSize: 11,
                                  letterSpacing: -0.11,
                                  fontFamily: 'ProximaNova-Regular.otf'),
                            ),
                          ),
                          MyCustomInput(
                            validator: validateAddress,
                            onSaved: (val) {
                              _locationData['address'] = val;
                            },
                            textEditingController: detaoisl,
                            focusNode: _focusNode1,
                            onFieldSubmitted: (val) {
                              _focusNode1.unfocus();
                              FocusScope.of(context).requestFocus(_focusNode2);
                            },
                            prefixIcon: Icon(
                              MyCustomIcons != null ? MyCustomIcons.map : "",
                              color: Colors.black,
                            ),
                          ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 10, right: 10, bottom: 10),
                          //   child: Text(
                          //     AppLocalizations.of(context).city,
                          //     style: TextStyle(
                          //         color: Color(0xFF1A1A1A).withOpacity(0.7),
                          //         fontSize: 11,
                          //         letterSpacing: -0.11,
                          //         fontFamily: 'ProximaNova-Regular.otf'),
                          //   ),
                          // ),
                          // Theme(
                          //   data: Theme.of(context).copyWith(
                          //     canvasColor:
                          //         ui.Color.fromARGB(223, 255, 251, 251),
                          //   ),
                          //   child: Selector<GlobalData, List<City>>(
                          //     selector: (_, globalData) => globalData.cities,
                          //     builder: (_, cities, __) => MyCustomComboBox(
                          //       value: _locationData['city_id'].isEmpty
                          //           ? 0
                          //           : int.parse(_locationData['city_id']),
                          //       onSaved: (val) {
                          //         _locationData['city_id'] = '$val';
                          //       },
                          //       validator: validateDropdownCities,
                          //       onChangedEvent: (val) {
                          //         setState(() {
                          //           _locationData['city_id'] = '$val';
                          //         });
                          //       },
                          //       items: <DropdownMenuItem>[
                          //                 DropdownMenuItem(
                          //                   child: Text(
                          //                     AppLocalizations.of(context).city,
                          //                     style: TextStyle(
                          //                         color: Color(0xFF1A1A1A),
                          //                         fontSize: 14.0),
                          //                   ),
                          //                   value: 0,
                          //                 )
                          //               ] +
                          //               cities
                          //                   .map<DropdownMenuItem>((e) =>
                          //                       DropdownMenuItem(
                          //                         child: Text(
                          //                           e.name,
                          //                           style: TextStyle(
                          //                               color:
                          //                                   Color(0xFF1A1A1A),
                          //                               fontSize: 14.0),
                          //                         ),
                          //                         value: e.id,
                          //                       ))
                          //                   ?.toList() ??
                          //           [],
                          //       prefixIcon: Icon(
                          //         MyCustomIcons.pin_2,
                          //         color: Colors.black,
                          //       ),
                          //       suffixIcon: Icon(
                          //         Icons.keyboard_arrow_down,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 70.0,
                          ),
                          Center(
                            child: _isLoading
                                ? SizedBox(
                                    height: 50.0,
                                    child: Center(
                                      child: Platform.isIOS
                                          ? CupertinoActivityIndicator()
                                          : CircularProgressIndicator(),
                                    ),
                                  )
                                : MyCustomFormButton(
                                    buttonText:
                                        AppLocalizations.of(context).save,
                                    onPressedEvent: () {
                                      if (addressToEdit == null)
                                        _addAddress();
                                      else
                                        _editAddress();
                                    },
                                  ),
                          )
                        ],
                      ),
                    ),
            )),
      ),
    );
  }

  TextEditingController detaoisl = new TextEditingController();
}
