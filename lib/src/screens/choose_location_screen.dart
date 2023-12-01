import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/providers/maps.dart';
import 'package:Serve_ios/src/widgets/ScrollingText.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart' as gl;
import 'package:geolocator/geolocator.dart' as glocater;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as dr;
import 'package:google_maps_webservice/places.dart' as pl;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';



class ChooseLocationScreen extends StatefulWidget {
  static const routeName = '/choose-location';
  @override
  _ChooseLocationScreenState createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen>
    with AlertsMixin, SingleTickerProviderStateMixin {
  static const mapsKey = 'AIzaSyAZTDszvefJJZ0YY0LE9m_loneiSrfKeC4';
  String placeId;
  LocationData placeLocation;
  GoogleMapController mapController;
  Marker centerMarker;
  LatLng center = LatLng(0, 0);
//  Completer<GoogleMapController> _controller = Completer();
  String address = '';
  String locationName = '';
  Timer _debounceTimer;
  BitmapDescriptor customMarkerIcon;
  CameraPosition lastCameraPosition;
  Addresses _addressesReference;
  Marker _marker =
      Marker(markerId: MarkerId('center_marker'), position: LatLng(0, 0));

  Map _locationData = {
    'longitude': '',
    'latitude': '',
    'city_id': '',
    'address': ''
  };

  Future<void> _getCurrentLocation([bool isFirst = false]) async {
    gotCurrentLocation = true;
    bool _serviceEnabled;
    Location location = new Location();
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      myCurrentLocation = await location.getLocation();
      // Future.delayed(Duration(microseconds: 30), () {
      mapController?.moveCamera(CameraUpdate.newLatLng(LatLng(
          myCurrentLocation.latitude ?? 0.0,
          myCurrentLocation.longitude ?? 0.0)));
      if (isFirst) if (mounted) {
        getPointDetails(myCurrentLocation);
      }
      // });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        String error = 'Permission denied';
      }
    }
  }

  LocationData myCurrentLocation;
  void _onMapCreated(GoogleMapController controller) async{
    mapController = controller;
    // _updateMarkerPosition(center);
    if (Theme.of(context).brightness == Brightness.dark)
      mapController.setMapStyle(json.encode([
        {
          "elementType": "geometry",
          "stylers": [
            {"color": "#242f3e"}
          ]
        },
        {
          "elementType": "labels.text.fill",
          "stylers": [
            {"color": "#746855"}
          ]
        },
        {
          "elementType": "labels.text.stroke",
          "stylers": [
            {"color": "#242f3e"}
          ]
        },
        {
          "featureType": "administrative.locality",
          "elementType": "labels.text.fill",
          "stylers": [
            {"color": "#d59563"}
          ]
        },
        {
          "featureType": "poi",
          "elementType": "labels.text.fill",
          "stylers": [
            {"color": "#d59563"}
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "geometry",
          "stylers": [
            {"color": "#263c3f"}
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "labels.text.fill",
          "stylers": [
            {"color": "#6b9a76"}
          ]
        },
        {
          "featureType": "road",
          "elementType": "geometry",
          "stylers": [
            {"color": "#38414e"}
          ]
        },
        {
          "featureType": "road",
          "elementType": "geometry.stroke",
          "stylers": [
            {"color": "#212a37"}
          ]
        },
        {
          "featureType": "road",
          "elementType": "labels.text.fill",
          "stylers": [
            {"color": "#9ca5b3"}
          ]
        },
        {
          "featureType": "road.highway",
          "elementType": "geometry",
          "stylers": [
            {"color": "#746855"}
          ]
        },
        {
          "featureType": "road.highway",
          "elementType": "geometry.stroke",
          "stylers": [
            {"color": "#1f2835"}
          ]
        },
        {
          "featureType": "road.highway",
          "elementType": "labels.text.fill",
          "stylers": [
            {"color": "#f3d19c"}
          ]
        },
        {
          "featureType": "transit",
          "elementType": "geometry",
          "stylers": [
            {"color": "#2f3948"}
          ]
        },
        {
          "featureType": "transit.station",
          "elementType": "labels.text.fill",
          "stylers": [
            {"color": "#d59563"}
          ]
        },
        {
          "featureType": "water",
          "elementType": "geometry",
          "stylers": [
            {"color": "#17263c"}
          ]
        },
        {
          "featureType": "water",
          "elementType": "labels.text.fill",
          "stylers": [
            {"color": "#515c6d"}
          ]
        },
        {
          "featureType": "water",
          "elementType": "labels.text.stroke",
          "stylers": [
            {"color": "#17263c"}
          ]
        }
      ]));
     await  getUserCurrentLocation();
    // if (!calledDirections) getPointDetails(myCurrentLocation);

    //  _controller.complete(controller);

    //  Future.delayed(Duration(milliseconds: 300), () {
    //    LatLng latLng1 = LatLng(
    //        _mapsProvider.currentLocation.lat, _mapsProvider.currentLocation.lng);
    //    print('placeLocation.lat  ${placeLocation.lat}');
    //    LatLng latLng2 = LatLng(placeLocation.lat, placeLocation.lng);
    //    LatLngBounds bounds = boundsFromLatLngList([latLng1, latLng2]);
    //    CameraUpdate cu = CameraUpdate.newLatLngBounds(bounds, 80.0);

    //    SchedulerBinding.instance.addPostFrameCallback((_) {
    //      mapController.animateCamera(cu).then((v) {
    //        check(cu, this.mapController);
    //      });
    //    });
    //  });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      // lastCameraPosition = position;
      center = position.target;
      print('called Camer moved');
      updateCenterMarker(LatLng(0.0, 0.0));

      if (_debounceTimer != null && _debounceTimer.isActive) {
        _debounceTimer
            .cancel(); // We will Reset the timer if the camera is still moving
      }

      _debounceTimer = Timer(Duration(milliseconds: 300), () {
        // We Update the location name after a short delay (500ms)
        updateLocationName(center);
        // getPointDetails(LocationData.fromMap({
        //   'latitude': center.latitude,
        //   'longitude': center.longitude
        // }));
      });
    });
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

  Map<String, Marker> markers = {};

  bool calledDirections = false;
  dr.DirectionsResponse _directionsResponse;

  Future<void> addMarker(String iconName, LocationData position, String id,
      {String infoWindowTitle,
      String infoWindowSnippet,
      double rotation}) async {
    // final Uint8List markerIcon =
    //     await getBytesFromAsset('assets/images/icons/$iconName.png', 70);
    final MarkerId markerId = MarkerId(id);
    if (this.mounted)
      setState(() {
        markers[id] = Marker(
          markerId: markerId,
          flat: true,
          rotation: rotation,
          visible: true,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow.noText,
          position: LatLng(position.latitude, position.longitude),
//        anchor: Offset(0.0, -75.0),
        );
      });
  }

  Future<void> getPointDetails(LocationData location) async {
    // _choosePlace(location, '');
    calledDirections = true;
    try {
      final placesMarks = await gl.placemarkFromCoordinates(
          center.latitude, center.longitude,
          localeIdentifier: Localizations.localeOf(context).languageCode);
      final geocodedLocation = [
        placesMarks?.first?.subThoroughfare ?? "",
        placesMarks?.first?.thoroughfare ?? "",
        placesMarks?.first?.locality ?? "",
        placesMarks?.first?.administrativeArea ?? "",
        placesMarks?.first?.postalCode ?? "",
      ];
      geocodedLocation.removeWhere((element) => element.isEmpty);
      _choosePlace(
          LocationData.fromMap(
              {'latitude': center.latitude, 'longitude': center.longitude}),
          geocodedLocation.join(", "));
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString());
    } catch (error) {
      throw error;
    }
  }

  TextEditingController _textEditingController = TextEditingController();
  bool gotCurrentLocation = false;
  Map args;

//  Students _studentsReference;
  MapsProvider _locationProvider;
  @override
  void didChangeDependencies() {
//    _studentsReference = Provider.of(context, listen: false);
    _locationProvider = Provider.of<MapsProvider>(context, listen: false);
    myCurrentLocation = _locationProvider.currentLocation;
    _addressesReference = Provider.of<Addresses>(context, listen: false);

    args = ModalRoute.of(context).settings.arguments as Map;
//    _student = _studentsReference.getStudentByKey(args['studentKey']);
    super.didChangeDependencies();
  }

  Future<glocater.Position> getUserCurrentLocation() async {
    await glocater.Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await glocater.Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await glocater.Geolocator.getCurrentPosition(
        desiredAccuracy: glocater.LocationAccuracy.high);
  }

  String currentAddress = '';

  Widget _myUpperLayer() {
    return Container(
//          duration: Duration(milliseconds: 200),
        height: 800.0,
        color: Colors.white,
        width: double.infinity,
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).address),
          ),
        ));
  }

  LocationData chosenLocation;

  void _choosePlace(LocationData location, String name) {
    chosenLocation = location;
    currentAddress = name;
    _textEditingController.text = name;
    addMarker(
        'busStopPin',
        LocationData.fromMap(
            {'latitude': location.latitude, 'longitude': location.longitude}),
        'myLocation');

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(location.latitude, location.longitude), 16));
  }

  final pl.GoogleMapsPlaces places = pl.GoogleMapsPlaces(apiKey: mapsKey);
  Future<pl.PlaceDetails> getPlaceDetails(String placeId, String lang,
      [List<String> fields]) async {
    try {
      final pl.PlacesDetailsResponse response = await places
          .getDetailsByPlaceId(placeId, language: lang, fields: fields);
      if (!response.isOkay) {
        throw HttpException(response.status);
      }
      return response.result;
    } catch (error) {
      throw error;
    }
  }

  bool isLoading = false;

  Future<void> _goToPlace(String placeId) async {
    try {
      pl.PlaceDetails _placeDetails = await getPlaceDetails(
          placeId, Localizations.localeOf(context).languageCode);
      _choosePlace(
          LocationData.fromMap({
            'latitude': _placeDetails.geometry.location.lat,
            'longitude': _placeDetails.geometry.location.lng
          }),
          _placeDetails.name);
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString());
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

  RubberAnimationController _controller;

  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        upperBoundValue: AnimationControllerValue(pixel: 300.0),
        lowerBoundValue: AnimationControllerValue(pixel: 250.0),
        dismissable:
            false, // if true, when the bottomsheet reaches the lowerbound the animation stops
        // The value when expanded
        duration: Duration(milliseconds: 200));
    // TODO: implement initState
    super.initState();

    _createCustomMarkerIcon();
    
    if (mapController != null) {
      
      // _getCurrentLocation(true);
      // getUserCurrentLocation().then((value) => {
      //       // if (!calledDirections)
      //       myCurrentLocation = LocationData.fromMap(
      //       {'latitude': value.latitude, 'longitude': value.longitude}),
      //         getPointDetails(LocationData.fromMap(
      //       {'latitude': value.latitude, 'longitude': value.longitude})),
      //       mapController.animateCamera(CameraUpdate.newLatLng(
      //           LatLng(value.latitude, value.longitude))),
      //       // setState(() {
      //       // setHomeMarker(value.latitude, value.longitude),
      //       // }),
      //     });
    }

    // if (!gotCurrentLocation) _getCurrentLocation(true);
  }

  void _createCustomMarkerIcon() async {
    try {
      final ByteData bytes =
          await rootBundle.load('assets/images/blue-pin.png');
      final Uint8List pngBytes = bytes.buffer.asUint8List();

      customMarkerIcon = BitmapDescriptor.fromBytes(pngBytes);
    } catch (e) {
      print('Error loading custom marker asset: $e');
    }

    
    await getUserCurrentLocation().then((value) => {
      print("User Location Info $value"),
        mapController?.moveCamera(CameraUpdate.newLatLng(LatLng(value.latitude,value.longitude)))
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          leadingWidth: 600,
          title: Text('${AppLocalizations.of(context).changeLocation}'),
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: ScrollingText(
              ratioOfBlankToScreen: 0.30,
              text: "",
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w100),
            ),
          )),
      body: SafeArea(
        top: false,
        child: RubberBottomSheet(
          headerHeight: 30.0,
          header: Container(
            alignment: Alignment.center,
            height: 30.0,
            width: deviceSize.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0)),
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(3.0)),
              width: 35.0,
              height: 3.0,
            ),
          ),
          menuLayer: Container(
            width: deviceSize.width,
            height: 75.0,
            padding: EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0)),
            ),
            child: Center(
              child: SizedBox(
                  width: 140.0,
                  child: MyCustomFormButton(
                    height: 50.0,
                    textColor: Colors.white,
                    buttonText: AppLocalizations.of(context).confirm,
                    onPressedEvent: () async {
                      _locationProvider.changeChosenLocation(
                          dr.Location(center.latitude, center.longitude),
                          currentAddress);

                      try {
                        await _addLocation();

                        Navigator.of(context).pop(true);
                      } catch (error) {
                        print("add Location Error $error");
                      }
                    },
                  )),
            ),
          ),
          lowerLayer: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              GoogleMap(
                scrollGesturesEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                compassEnabled: true,
                padding: const EdgeInsets.only(top: 80.0, bottom: 250.0),
                indoorViewEnabled: true,
                onTap: (LatLng latLng) {
                  //  'latitude': 26.014477664379683,
                  //   'longitude': 43.369800636779075
                  getPointDetails(LocationData.fromMap({
                    'latitude': center.latitude,
                    'longitude': center.longitude
                  }));
                },
                tiltGesturesEnabled: true,
                rotateGesturesEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 14.0,
                  tilt: 45.0,
                ),
                myLocationButtonEnabled: true,
                onCameraMoveStarted: _onCameraIdle,
                onCameraMove: _onCameraMove,
                onCameraIdle: _onCameraIdle,
                onMapCreated: _onMapCreated,
                markers: _createMarkerSet(),
              ),
              if (mapController == null)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: AnimatedOpacity(
                  opacity: (locationName.isNotEmpty) ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      locationName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          animationController: _controller,
          upperLayer: _myUpperLayer(),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _addLocationFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _addLocation() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    _locationData['longitude'] = center.longitude.toString();
    _locationData['latitude'] = center.latitude.toString();
    _locationData['address'] = locationName;
    _locationData['is_home'] = '1';

    bool isMounted = mounted;

    try {
      final regResponse =
          await _addressesReference.addAddress(json.encode(_locationData));

      if (isMounted) {
        Navigator.of(context).pop(true);
        setState(() {
          _isLoading = false;
        });
      }
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString(), Duration(milliseconds: 1500));
      if (isMounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      throw error;
    }
  }

  Set<Marker> _createMarkerSet() {
    return {
      Marker(
        markerId: MarkerId('custom_marker'),
        position: center,
        icon: customMarkerIcon ?? BitmapDescriptor.defaultMarker,
      ),
    };
  }

  void _updateMarkerPosition(LatLng position) {
    setState(() {
      _marker = _marker.copyWith(
        positionParam: position,
      );
    });
  }

  void _onCameraIdle() {
    if (lastCameraPosition != null) {
      LatLng idlecenter = lastCameraPosition.target;
      setState(() {
        center =
            idlecenter; // Update the marker position to the center of the map

        // Update the marker position to the center of the map
        print('called Camer moved');
        updateCenterMarker(idlecenter);

        if (_debounceTimer != null && _debounceTimer.isActive) {
          _debounceTimer
              .cancel(); // We will Reset the timer if the camera is still moving
        }

        _debounceTimer = Timer(Duration(milliseconds: 300), () {
          // We Update the location name after a short delay (500ms)
          updateLocationName(idlecenter);
          // getPointDetails(LocationData.fromMap({
          //   'latitude': center.latitude,
          //   'longitude': center.longitude
          // }));
        });
      });
    }
  }

  void _moveToMarker() {
    // Get the visible region of the map
    mapController.getVisibleRegion().then((visibleRegion) {
      // Check if the marker position is within the visible region
      if (visibleRegion.contains(center)) {
        // Marker is within the visible region, no need to move the camera
        return;
      }

      // If the marker is outside the visible region, move the camera to center the marker
      mapController.animateCamera(CameraUpdate.newLatLng(center));
    });
  }

  Future<void> updateLocationName(LatLng latLng) async {
    try {
      // List<gl.Placemark> placemarks = await gl.placemarkFromCoordinates(
      //   latLng.latitude,
      //   latLng.longitude,
      // );

      List<gl.Placemark> placemarks = await gl.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
        localeIdentifier: Localizations.localeOf(context).languageCode,
      );

      if (placemarks.isNotEmpty) {
        gl.Placemark placemark = placemarks[0];
        String address = '';

        if (placemark.name != null && placemark.name.isNotEmpty) {
          address += placemark.name + ', ';
        }
        if (placemark.locality != null && placemark.locality.isNotEmpty) {
          address += placemark.locality + ', ';
        }
        if (placemark.administrativeArea != null &&
            placemark.administrativeArea.isNotEmpty) {
          address += placemark.administrativeArea + ', ';
        }
        if (placemark.country != null && placemark.country.isNotEmpty) {
          address += placemark.country;
        }
        setState(() {
          locationName = address;
          _textEditingController.text = locationName;
          print("locationName  $locationName ");
        });
      } else {
        setState(() {
          _textEditingController.text = ' ';
          // locationName = 'No address available';
        });
      }
    } catch (e) {
      setState(() {
        print("locationName = Error: ${e.toString()}");
      });
    }
  }

  // Future<String> getLocationName(LatLng latLng) async {
  //   try {
  //     List<gl.Placemark> placemarks = await gl.placemarkFromCoordinates(
  //       latLng.latitude,
  //       latLng.longitude,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       gl.Placemark placemark = placemarks[0];
  //       address = '';
  //       if (placemark.name != null) {
  //         address += placemark.name + ', ';
  //       }
  //       if (placemark.locality != null) {
  //         address += placemark.locality + ', ';
  //       }
  //       if (placemark.administrativeArea != null) {
  //         address += placemark.administrativeArea + ', ';
  //       }
  //       if (placemark.country != null) {
  //         address += placemark.country;
  //       }

  //       print("adrress $address");
  //       return address;
  //     } else {
  //       return 'No address available';
  //     }
  //   } catch (e) {
  //     return 'Error: ${e.toString()}';
  //   }
  // }

  void updateCenterMarker(LatLng position) {
    print("Camer moved " + position.toString());
    // setState(() {
    centerMarker = Marker(
      markerId: MarkerId('custom_marker'),
      position: position,
      icon: customMarkerIcon ?? BitmapDescriptor.defaultMarker,
    );
    // });

    // getLocationName(center);
    // print('Location Name: $locationName');
  }
}
