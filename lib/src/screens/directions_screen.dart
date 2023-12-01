import 'dart:io' as prefix1;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as prefix0;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/http_exception.dart';

class DirectionsScreen extends StatefulWidget {
  static const routeName = '/directions';
  @override
  _DirectionsScreenState createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> with AlertsMixin {
  String placeId;
  Location placeLocation;
  Location myLocation;
  GoogleMapController mapController;
  Auth _authReference;
//  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
//    _controller.complete(controller);

//    Future.delayed(Duration(milliseconds: 300), () {
//      LatLng latLng1 = LatLng(
//          _mapsProvider.currentLocation.lat, _mapsProvider.currentLocation.lng);
//      LatLng latLng2 = LatLng(placeLocation.lat, placeLocation.lng);
//      LatLngBounds bounds = boundsFromLatLngList([latLng1, latLng2]);
//      CameraUpdate cu = CameraUpdate.newLatLngBounds(bounds, 80.0);
//
//      SchedulerBinding.instance.addPostFrameCallback((_) {
//        mapController.animateCamera(cu).then((v) {
//          check(cu, this.mapController);
//        });
//      });
//    });
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  MapsProvider _mapsProvider;

  Future<String> getPointAddress(Location location) async {
    calledDirections = true;
    try {
      GeocodingResponse response = await _mapsProvider.getGeoDetails(
          location, _authReference.appLanguage);
      return response.results.first.formattedAddress;
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString(), null);
      return null;
    } catch (error) {
      throw error;
    }
  }

  Set<Marker> markers;

  Future<void> setMarkers() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/storelocation.png', 120);
    final Uint8List markerIcon2 =
        await getBytesFromAsset('assets/images/yourlocation.png', 120);
    final Uint8List markerIcon3 =
        await getBytesFromAsset('assets/images/clientlocation.png', 120);
    markers = <Marker>[
      Marker(
        markerId: MarkerId('storelocation'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: LatLng(placeLocation.lat, placeLocation.lng),
//        anchor: Offset(0.0, -75.0),
      ),
      Marker(
        markerId:
            fromChat ? MarkerId('clientlocation') : MarkerId('yourlocation'),
        icon: BitmapDescriptor.fromBytes(fromChat ? markerIcon3 : markerIcon2),
        position: LatLng(
            myLocation == null
                ? _mapsProvider.currentLocation.latitude
                : myLocation.lat,
            myLocation != null
                ? myLocation.lng
                : _mapsProvider.currentLocation.longitude),
//        anchor: Offset(0.0, -75.0),
      ),
      if (fromChat)
        Marker(
          markerId: MarkerId('yourlocation0'),
          icon: BitmapDescriptor.fromBytes(markerIcon2),
          position: LatLng(_mapsProvider.currentLocation.latitude,
              _mapsProvider.currentLocation.longitude),
//        anchor: Offset(0.0, -75.0),
        ),
    ].toSet();
    setState(() {});
  }

  bool calledDirections = false;
  DirectionsResponse _directionsResponse;

  void getDirections() async {
    calledDirections = true;
    try {
      _directionsResponse = await _mapsProvider.getDirections(
          placeLocation,
          Location(_mapsProvider.currentLocation.latitude,
              _mapsProvider.currentLocation.longitude),
          _authReference.appLanguage);
      CameraUpdate cu = CameraUpdate.newLatLngBounds(
          LatLngBounds(
              northeast: LatLng(
                  _directionsResponse.routes.first.bounds.northeast.lat,
                  _directionsResponse.routes.first.bounds.northeast.lng),
              southwest: LatLng(
                  _directionsResponse.routes.first.bounds.southwest.lat,
                  _directionsResponse.routes.first.bounds.southwest.lng)),
          80.0);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        mapController.animateCamera(cu).then((v) {
          check(cu, this.mapController);
        });
      });
      var _pl = PolylinePoints();
      setState(() {
        _myPolyLines = [
          prefix0.Polyline(
              polylineId: PolylineId('pl-$placeId'),
              visible: true,
              color: Color(0xFF454E9E),
              width: 3,
              points: _pl
                  .decodePolyline(
                      _directionsResponse.routes.first.overviewPolyline.points)
                  .map((pl) => LatLng(pl.latitude, pl.longitude))
                  .toList())
        ].toSet();
      });
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString(), null);
    } catch (error) {
      throw error;
    }
  }

  var args;

  bool fromChat = false;

  void _setAddresses() async {
    storeAddress = await getPointAddress(placeLocation);
    clientAddress = await getPointAddress(myLocation);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    setMarkers();
    _mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    _authReference = Provider.of<Auth>(context, listen: false);
    args = ModalRoute.of(context).settings.arguments as Map;
    placeId = args['placeId'];
    placeLocation = args['location'];
    myLocation = args['locationTo'];
    fromChat = args['fromChat'] ?? false;
    if (fromChat) {
      _setAddresses();
    }
    if (!calledDirections) getDirections();
//    if (!modalSheeted)
//      showModalBottomSheet(
//        context: context,
//        builder: (ctx) => SizedBox(
//          height: 110.0,
//        ),
//        shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.only(
//                topRight: Radius.circular(36.0),
//                topLeft: Radius.circular(36.0))),
//        elevation: 0,
//        backgroundColor: Colors.white,
//        isScrollControlled: true,
//      );
    super.didChangeDependencies();
  }

  String storeAddress = '';
  String clientAddress = '';

  Set<prefix0.Polyline> _myPolyLines;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomSheet: fromChat
          ? Container(
              width: deviceSize.width,
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        launch(prefix1.Platform.isIOS
                            ? "http://maps.apple.com/maps?saddr=&daddr=(${placeLocation.lat}),(${placeLocation.lng})"
                            : 'https://www.google.com/maps?daddr=${placeLocation.lat},${placeLocation.lng}');
                      },
                      title:
                          Text(AppLocalizations.of(context).restaurantLocation),
                      subtitle: Text(storeAddress ?? ''),
                      trailing: Column(
                        children: <Widget>[
                          Icon(Icons.directions),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(AppLocalizations.of(context).onMaps),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        launch(prefix1.Platform.isIOS
                            ? "http://maps.apple.com/maps?saddr=&daddr=(${myLocation.lat}),(${myLocation.lng})"
                            : 'https://www.google.com/maps?daddr=${myLocation.lat},${myLocation.lng}');
                      },
                      title: Text(AppLocalizations.of(context).clientLocation),
                      subtitle: Text(clientAddress ?? ''),
                      trailing: Column(
                        children: <Widget>[
                          Icon(Icons.directions),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(AppLocalizations.of(context).onMaps),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).deliveryAddress),
        centerTitle: true,
      ),
      body: GoogleMap(
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        compassEnabled: true,
        indoorViewEnabled: true,
        polylines: _myPolyLines,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(
              _mapsProvider.currentLocation.latitude,
              _mapsProvider.currentLocation.longitude,
            ),
            zoom: 15.0),
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        markers: markers,
      ),
    );
  }
}
