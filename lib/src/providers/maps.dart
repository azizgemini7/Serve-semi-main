import 'dart:async';

import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:google_maps_webservice/directions.dart' as dr;
import 'package:google_maps_webservice/distance.dart' as ds;
import 'package:google_maps_webservice/geocoding.dart' as gc;
import 'package:google_maps_webservice/places.dart' as pl;
import 'package:location/location.dart';

String mapsKey = 'AIzaSyAZTDszvefJJZ0YY0LE9m_loneiSrfKeC4';

class MapsProvider with ChangeNotifier {
  User _user;
  gc.Location chosenLocation;
  String address = '';
  User get user => _user;
  bool shouldShareLocation = false;

  MapsProvider(
      this._user,
      this.currentLocation,
      this.shouldShareLocation,
      this._appLanguage,
      this.locationSubscription,
      this.address,
      this.chosenLocation);

  void changeChosenLocation(gc.Location location, String address) {
    chosenLocation = location;
    this.address = address;
    notifyListeners();
  }

  Future<void> startLocationSharing() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (!(_user?.isDriver ?? false)) return;
    shouldShareLocation = true;
    startNow() {
      locationSubscription?.cancel();
      if (_user == null) return;
      // locationSubscription = gl.Geolocation.locationUpdates(
      //   accuracy: gl.LocationAccuracy.best,
      //   displacementFilter: 10.0, // in meter// s
      //   androidOptions: gl.LocationOptionsAndroid.defaultContinuous,
      //   inBackground:
      //       true, // by default, location updates will pause when app is inactive (in background). Set to `true` to continue updates in background.
      // ).listen((gl.LocationResult result) async {
      //   currentLocation = LocationData.fromMap({
      //     'latitude': result.location.latitude,
      //     'longitude': result.location.longitude
      //   });
      //   if (result.isSuccessful) {

      //   }
      //   return;
      // });
    }

    // void changeChosenLocation(Location location, String address) {
    //   chosenLocation = location;
    //   this.address = address;
    //   notifyListeners();
    // }

    // final gl.GeolocationResult result =
    //     await gl.Geolocation.isLocationOperational();
    // if (result.isSuccessful) {
    //   startNow();
    // } else {
    //   print('denied1');
    //   final gl.GeolocationResult result2 =
    //       await gl.Geolocation.requestLocationPermission(
    //           openSettingsIfDenied: true,
    //           permission: const gl.LocationPermission(
    //             android: gl.LocationPermissionAndroid.fine,
    //             ios: gl.LocationPermissionIOS.always,
    //           ));

    //   if (result2.isSuccessful) {
    //     startNow();
    //   } else {
    //     print('denied2');
    //     // location permission is not granted
    //     // user might have denied, but it's also possible that location service is not enabled, restricted, and user never saw the permission request dialog. Check the result.error.type for details.
    //   }
    // }
  }

  stopLocationSharing() {
    locationSubscription?.cancel();
    shouldShareLocation = false;
    locationSubscription = null;
    notifyListeners();
  }

  LocationData currentLocation =
      LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});
  String _appLanguage = 'ar';
  bool gotLocation = false;

  Future<void> getCurrentLocation() async => await _getCurrentLocation();

  Map<String, double> readyDistances = {};

  String get appLanguage => _appLanguage;
  StreamSubscription locationSubscription;

  Future<LocationData> _getCurrentLocation() async {
    bool _serviceEnabled;
    gc.Location location;

    getUserCurrentLocation().then(
        (value) => {location = gc.Location(value.latitude, value.longitude)});

    PermissionStatus _permissionGranted;

    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return null;
    //   }
    // }
    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return null;
    //   }
    // }
    currentLocation = LocationData.fromMap(
        {'latitude': location.lat, 'longitude': location.lng});
    // try {
    //   currentLocation = await location.getLocation();
    //   locationSubscription?.cancel();
    //   locationSubscription = location.onLocationChanged.listen((data) {
    //     currentLocation = data;
    //   });
    // } on PlatformException catch (e) {
    //   if (e.code == 'PERMISSION_DENIED') {
    //     String error = 'Permission denied';
    //   }
    // }
    return currentLocation;
  }

  bool disposed = false;

  Future<gl.Position> getUserCurrentLocation() async {
    await gl.Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await gl.Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await gl.Geolocator.getCurrentPosition(
        desiredAccuracy: gl.LocationAccuracy.high);
  }

  @override
  void dispose() {
    disposed = true;
    locationSubscription?.cancel();
    locationSubscription = null;
    directions.dispose();
    distanceMatrix.dispose();
    places.dispose();
    super.dispose();
  }

  void addDistanceToReady(String placeId, double distance) {
    readyDistances[placeId] = distance;
    notifyListeners();
  }

  final dr.GoogleMapsDirections directions =
      dr.GoogleMapsDirections(apiKey: mapsKey);

  final pl.GoogleMapsPlaces places = pl.GoogleMapsPlaces(apiKey: mapsKey);
  final ds.GoogleDistanceMatrix distanceMatrix =
      ds.GoogleDistanceMatrix(apiKey: mapsKey);

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

  final gc.GoogleMapsGeocoding _geo = gc.GoogleMapsGeocoding(apiKey: mapsKey);

  Future<gc.GeocodingResponse> getGeoDetails(
      ds.Location location, String lang) async {
    try {
      final gc.GeocodingResponse response =
          await _geo.searchByLocation(location, language: lang);

      if (!response.isOkay) {
        throw HttpException(response.status);
      }
      return response;
    } catch (error) {
      throw error;
    }
  }

  Future<dr.DirectionsResponse> getDirections(
      ds.Location destination, ds.Location myLocation, String lang,
      [List<String> fields]) async {
    try {
      final dr.DirectionsResponse response =
          await directions.directionsWithLocation(
        myLocation ?? currentLocation,
        destination,
        language: appLanguage,
        travelMode: pl.TravelMode.driving,
        units: pl.Unit.metric,
      );
      if (!response.isOkay) {
        throw HttpException(response.status);
      }
      return response;
    } catch (error) {
      throw error;
    }
  }
}
