import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/order_for_delegate.dart';
import 'package:Serve_ios/src/models/user.dart';
import 'package:Serve_ios/src/providers/maps.dart';
import 'package:Serve_ios/src/widgets/dialogs/loading_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as prefix0;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart' as ds;
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/http_exception.dart';

class DeliveryLocationScreen extends StatefulWidget {
  static const routeName = '/delivery-location';
  @override
  _DeliveryLocationScreenState createState() => _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState extends State<DeliveryLocationScreen>
    with AlertsMixin {
  int orderId;
  Location delegateLocation;
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  bool isGettingUser = false;

  OrderForDelegate order;

  ds.Element distanceDetails;
  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  int markerSize = 60;

  Future<void> addMarker(String iconName, Location position, String id,
      {String infoWindowTitle,
      String infoWindowSnippet,
      double rotation}) async {
    final Uint8List markerIcon = await getBytesFromAsset(
        'assets/images/$iconName.png', id == 'delegate' ? markerSize : 60);
    final MarkerId markerId = MarkerId(id);
    setState(() {
      markers[id] = Marker(
        markerId: markerId,
        flat: true,
        rotation: rotation,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        infoWindow: infoWindowTitle == null
            ? null
            : InfoWindow(title: infoWindowTitle, snippet: infoWindowSnippet),
        position: LatLng(position.lat, position.lng),
        anchor: id == 'delegate' ? Offset(0.5, 0.5) : null,
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);
    addMarker(
        'pin_3',
        ds.Location(_mapsProvider.currentLocation.latitude,
            _mapsProvider.currentLocation.longitude),
        'me',
        infoWindowTitle: AppLocalizations.of(context).myLocation);
    addMarker(
        'pin',
        Location(order.restaurantLatitude, order.restaurantLongitude),
        'restaurant',
        infoWindowTitle: AppLocalizations.of(context).restaurantLocation);
    addMarker('pin', Location(order.deliverLatitude, order.deliverLongitude),
        'deliveryAddress',
        infoWindowTitle: AppLocalizations.of(context).deliveryAddress);
    //  getDirections();
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
          location, _mapsProvider.appLanguage);
      return response.results.first.formattedAddress;
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString(), null);
      return null;
    } catch (error) {
      throw error;
    }
  }

  Map<String, Marker> markers = {};
  PolylinePoints _pl = PolylinePoints();

  bool calledDirections = false;
  DirectionsResponse _directionsResponse;
  List<PointLatLng> _currentDirectionsPoints;

  void getDirections() async {
    final bool isFirstTime = !calledDirections;
    calledDirections = true;
    try {
      _directionsResponse = await _mapsProvider.getDirections(
          ds.Location(_mapsProvider.currentLocation.latitude,
              _mapsProvider.currentLocation.longitude),
          Location(order.deliverLatitude, order.deliverLongitude),
          _mapsProvider.appLanguage);
//      if (isFirstTime) {
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
      _currentDirectionsPoints = _pl.decodePolyline(
          _directionsResponse.routes.first.overviewPolyline.points);
//      }
      setState(() {
        _myPolyLines = [
          prefix0.Polyline(
              polylineId: PolylineId('pl-$orderId'),
              visible: true,
              color: Color(0xFF0083E7),
              width: 4,
              points: _currentDirectionsPoints
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

  User driver;

//  Future<void> getDriverDetails() async {
//    setState(() {
//      isGettingUser = true;
//    });
//    driver = await Provider.of<Orders>(context, listen: false)
//        .getDriverDetails(orderId);
//    startTracking();
//  }

  @override
  void didChangeDependencies() {
    _mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    args = ModalRoute.of(context).settings.arguments as Map;
    order = args['order'] as OrderForDelegate;
    if (!calledDirections) {
//      getDriverDetails();
    }
    super.didChangeDependencies();
  }

  int currentCallCount = 0;

  // FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription _streamSubscription;
  Timer timer;
  bool markerIsIncremental = true;

//  startTracking() async {
//    _streamSubscription?.cancel();
//    timer?.cancel();
////    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
////      if (markerSize <= 95 && markerSize >= 80) {
////        if (markerIsIncremental)
////          markerSize++;
////        else
////          markerSize -= 3;
////      } else if (markerSize > 95) {
////        markerIsIncremental = false;
////        markerSize--;
////      } else if (markerSize < 80) {
////        markerIsIncremental = true;
////        markerSize += 3;
////      }
////      addMarker('location_circle', delegateLocation, 'delegate');
////    });
//    _streamSubscription = _firestore
//        .document('users_locations/${driver.id}')
//        .snapshots()
//        .listen((event) async {
//      if (event.exists) {
//        delegateLocation = Location(
//            (event.data['location'] as GeoPoint).latitude,
//            (event.data['location'] as GeoPoint).longitude);
//        currentCallCount++;
//        if (!calledDirections) {
//          isGettingUser = false;
//          await addMarker(
//            'location_circle',
//            Location(delegateLocation.lat, delegateLocation.lng), 'delegate',
////          rotation: oldBearing,
////              infoWindowTitle: AppLocalizations.of(context).delegate,
//          );
//          final ds.DistanceResponse _distanceResponse =
//          await _mapsProvider.distanceMatrix.distanceWithLocation(
//              [_mapsProvider.currentLocation], [delegateLocation],
//              unit: Unit.metric,
//              languageCode: Localizations.localeOf(context).languageCode);
//          distanceDetails = _distanceResponse.results.first.elements.first;
//          //    Future.delayed(Duration(milliseconds: 300), () {
//          LatLng latLng1 = LatLng(_mapsProvider.currentLocation.lat,
//              _mapsProvider.currentLocation.lng);
//          LatLng latLng2 = LatLng(delegateLocation.lat, delegateLocation.lng);
//          LatLngBounds bounds = boundsFromLatLngList([latLng1, latLng2]);
//          CameraUpdate cu = CameraUpdate.newLatLngBounds(bounds, 80.0);
//
//          SchedulerBinding.instance.addPostFrameCallback((_) {
//            mapController.animateCamera(cu).then((v) {
//              check(cu, this.mapController);
//            });
//          });
//        }
//        await _movePoint(
//            delegateLocation.lat, delegateLocation.lng, currentCallCount);
//        if (_currentDirectionsPoints == null)
//          getDirections();
//        else {
//          if (!gd.Geodesy().isGeoPointInPolygon(
//              gd.LatLng(delegateLocation.lat, delegateLocation.lng),
//              _currentDirectionsPoints
//                  .map((e) => gd.LatLng(e.latitude, e.longitude))
//                  .toList())) {
//            getDirections();
//          }
//        }
//      }
//    });
//  }

//  Future<void> _movePoint(double newLat, double newLng, int callCount,
//      [double newBearing = 0]) async {
//    final LatLngBounds bounds = await mapController.getVisibleRegion();
//    if (!bounds.contains(markers['delegate'].position)) {
//      CameraUpdate cu = CameraUpdate.newLatLngZoom(LatLng(newLat, newLng), 17);
//      mapController.animateCamera(cu).then((v) {
//        check(cu, this.mapController);
//      });
//    }
//    double deltaLat = (newLat - markers['delegate'].position.latitude) / 200;
//    double deltaLng = (newLng - markers['delegate'].position.longitude) / 200;
////    double deltaBearing =
////        (newBearing - (markers['delegate'].rotation ?? 0)) / 100;
//    final oldPosition = markers['delegate'].position;
////    final oldBearing = markers['delegate'].rotation;
//    for (int i = 0; i < 200; i++) {
//      if (currentCallCount != callCount) break;
//      await Future.delayed(Duration(milliseconds: 10));
//      addMarker(
//          'location_circle',
//          Location(oldPosition.latitude + deltaLat * i,
//              oldPosition.longitude + deltaLng * i),
//          'delegate',
////          rotation: oldBearing,
//          infoWindowTitle: AppLocalizations.of(context).delegate);
//    }
////    print('new $newBearing');
////    print('old $oldBearing');
////    if ((oldBearing - newBearing) > 5.0 || (oldBearing - newBearing) < -5.0)
////      for (int i = 0; i < 100; i++) {
////        await Future.delayed(Duration(milliseconds: 10));
////        addMarker(
////            'location_circle',
////            Location(oldPosition.latitude + deltaLat * 200,
////                oldPosition.longitude + deltaLng * 200),
////            'delegate',
//////            rotation: oldBearing + deltaBearing * i,
////            infoWindowTitle: AppLocalizations.of(context).delegate);
////      }
//  }

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
  void dispose() {
    _streamSubscription?.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).deliveryAddress),
      ),
      body: ModalProgressHUD(
        progressIndicator:
            LoadingDialog(AppLocalizations.of(context).pleaseWait),
        inAsyncCall: isGettingUser,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GoogleMap(
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              compassEnabled: true,
              indoorViewEnabled: true,
              polylines: _myPolyLines,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    order.deliverLatitude,
                    order.deliverLongitude,
                  ),
                  zoom: 15.0),
              myLocationButtonEnabled: true,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
            ),
            if (driver != null)
              Positioned(
                bottom: 12.0,
                right: 12.0,
                left: 12.0,
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 25.0,
                            offset: Offset(0.0, 7.0))
                      ]),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20.0,
                        backgroundImage:
                            CachedNetworkImageProvider(driver.photo),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              driver?.username ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15.0),
                            ),
                            if (distanceDetails != null)
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.directions_car,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '${distanceDetails.duration.text}  (${distanceDetails.distance.text})',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                          onTap: () {
                            launch('tel:${driver?.phone}');
                          },
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: Image.asset('assets/images/call.png'))
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
