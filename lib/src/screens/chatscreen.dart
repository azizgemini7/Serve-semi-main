import 'dart:async';
import 'dart:convert';
import 'package:Serve_ios/src/helpers/app_translations.dart';

import 'package:flutter/services.dart';

import 'dart:io';
import 'dart:math';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'fullscreenedired.dart';
import 'myglobals.dart' as globals;
import 'dart:math' as math;
import 'package:loadmore/loadmore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/global_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as dh;
import 'package:shimmer/shimmer.dart';

class Chatscreen extends StatefulWidget {
  String orderid;
  String userid;
  double deliverlat;
  Record soundRecord;
  double deliverlong;
  // Record recordInst;

  Chatscreen({this.orderid, this.userid, this.deliverlat, this.deliverlong});
  @override
  State<StatefulWidget> createState() {
    return Chatscreenstate(
        orderid: this.orderid,
        userid: this.userid,
        deliverlat: this.deliverlat,
        deliverlong: this.deliverlong);
  }
}

class Chatscreenstate extends State<Chatscreen> {
  final picker = ImagePicker();
  File _image;

  final soundRecord = new Record();

  Future getGalleryImage() async {
    var image = await picker.getImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 50);

    setState(() {
      _image = File(image.path);
      Navigator.pop(this.context);
    });
    if (_image != null) {
      senmes(2, 'd', mychats.length);
    }
  }

  Future getCameraImage() async {
    var image = await picker.getImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 50);

    setState(() {
      _image = File(image.path);
      Navigator.pop(this.context);
    });
    if (_image != null) {
      senmes(2, 'd', mychats.length);
    }
  }

  File _video;
  Future getGalleryVideo() async {
    var video = await picker.getVideo(
      source: ImageSource.gallery,
    );

    setState(() {
      _video = File(video.path);
      Navigator.pop(this.context);
    });

    if (_video != null) {
      senmes(3, 'd', mychats.length);
    }
  }

  Future getCameraVideo() async {
    var video = await picker.getVideo(
      source: ImageSource.camera,
    );

    setState(() {
      _video = File(video.path);
      Navigator.pop(this.context);
    });
    if (_video != null) {
      senmes(3, 'd', mychats.length);
    }
  }

  bool canplayaudio = true;
  int currentaudio = 0;

  String orderid;
  String userid;
  double deliverlat;
  double deliverlong;
  Chatscreenstate(
      {this.orderid, this.userid, this.deliverlat, this.deliverlong});
  Future<int> senmes(int x, String h, int index) async {
    if (x == 4) {
      chat p = new chat();
      p.date = DateTime.now().toString().substring(0, 16);
      p.message =
          globals.longitude.toString() + "*" + globals.latitude.toString();
      p.sender_id = userid;
      p.type = 'link';
      p.nowsen = true;
      mychats.insert(0, p);
      setState(() {});
      Timer(Duration(milliseconds: 50), jumm);
      var response23 =
          await http.post(Uri.parse('https://lazah.net/api/v1/addMsg'), body: {
        'order_id': orderid,
        'sender_id': userid,
        'msg': globals.longitude.toString() + "*" + globals.latitude.toString(),
        'type': 'link',
      }, headers: {
        'Authorization':
            'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
        'Accept-Language': 'ar'
      });

      mesc.clear();
      setState(() {});
      print('ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt');
      print(response23.body);
      if (response23.statusCode == 200) {
        sendpushup(
            globals.longitude.toString() + "*" + globals.latitude.toString(),
            'link',
            driverid == userid ? [usertok] : [drivertok]);
      } else {}
      setState(() {});
    } else if (x == 0) {
      String message = mesc.text;
      chat p = new chat();
      p.date = DateTime.now().toString().substring(0, 16);
      p.message = mesc.text;
      p.sender_id = userid;
      p.nowsen = true;
      mychats.insert(0, p);
      setState(() {});
      Timer(Duration(milliseconds: 50), jumm);
      var response23 =
          await http.post(Uri.parse('https://lazah.net/api/v1/addMsg'), body: {
        'order_id': orderid,
        'sender_id': userid,
        'msg': mesc.text,
        'type': 'text',
      }, headers: {
        'Authorization':
            'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
        'Accept-Language': 'ar'
      });

      mesc.clear();
      setState(() {});

      if (response23.statusCode == 200) {
        sendpushup(
            message, 'text', driverid == userid ? [usertok] : [drivertok]);
      } else {}
      setState(() {});
    } else if (x == 1) {
      Map<String, String> header = {
        "Accept": "application/json",
        //   'Authorization': 'Bearer $token',
      };
      http.MultipartRequest request = new http.MultipartRequest(
        'POST',
        Uri.parse('https://lazah.net/api/v1/addMsg'),
      );

      request.headers.addAll({
        'Authorization':
            'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
        'Accept-Language': 'ar'
      });
      request.fields.addAll(
        {
          'order_id': orderid,
          'sender_id': userid,
          'type': 'audio',
        },
      );
      File file = File(h);
      request.files.add(
        new http.MultipartFile.fromBytes(
          'msg',
          file.readAsBytesSync(),
          filename: file.path, // optional
          // contentType: new MediaType('image', 'jpeg'),
        ),
      );
      http.StreamedResponse r = await request.send();
      print(r.statusCode);
      var responseData = await r.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (r.statusCode == 200) {
        sendpushup(jsonDecode(responseString)['msg']['msg'], 'audio',
            driverid == userid ? [usertok] : [drivertok]);
        mychats[index].sente = true;
      }
    } else if (x == 2) {
      chat p = new chat();
      p.date = DateTime.now().toString().substring(0, 16);
      p.message = mesc.text;
      p.sender_id = userid;
      p.type = 'img';
      p.path = '';
      p.file = _image;
      p.nowsen = true;
      mychats.insert(0, p);
      setState(() {});
      Timer(Duration(milliseconds: 50), jumm);
      Map<String, String> header = {
        "Accept": "application/json",
        'Authorization':
            'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
      };
      http.MultipartRequest request = new http.MultipartRequest(
        'POST',
        Uri.parse('https://lazah.net/api/v1/addMsg'),
      );

      request.headers.addAll({
        'Authorization':
            'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
        'Accept-Language': 'ar'
      });
      request.fields.addAll(
        {
          'order_id': orderid,
          'sender_id': userid,
          'type': 'img',
        },
      );

      request.files.add(
        new http.MultipartFile.fromBytes(
          'msg',
          _image.readAsBytesSync(),
          filename: _image.path, // optional
          // contentType: new MediaType('image', 'jpeg'),
        ),
      );
      http.StreamedResponse r = await request.send();
      print(r.statusCode);
      _image = null;
      var responseData = await r.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      if (r.statusCode == 200)
        sendpushup(jsonDecode(responseString)['msg']['msg'], 'img',
            driverid == userid ? [usertok] : [drivertok]);
      print('gggggggggggggggggggggggggggggggggggggggggg');
    } else if (x == 3) {}
    controller.jumpTo(controller.position.minScrollExtent);
  }

  Function jumm() {
    controller.jumpTo(controller.position.minScrollExtent);
  }

  Function refresh() {
    getmessage();
  }

  bool havenext = false;
  String url = '';
  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  Future<int> getmessage() async {
    print("Called::  getmessage()");

    // if (mychats.isNotEmpty) {
    //   mychats.
    // }

    var response = await http
        .get(Uri.parse('https://lazah.net/api/v1/allMsg/' + orderid), headers: {
      'Authorization':
          'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
      'Accept-Language': 'ar'
    });

    if (response.statusCode == 200) {
      var x = jsonDecode(response.body)['data'];
      currentpage = jsonDecode(response.body)['current_page'];
      havenext = jsonDecode(response.body)['last_page'] > currentpage;
      nextpageurl = havenext ? jsonDecode(response.body)['next_page_url'] : '';

      // List<chat> chats = [];

      for (int i = 0; i < x.length; i++) {
        chat p = new chat();
        p.add(x[i]);

        mychats.add(p);
      }
    } else {}
    if (orderid.isEmpty) {
      print("orderid:: EMpty:: " + orderid);
    } else {
      print("orderid:: " + orderid);
      var response2 = await http.get(
          Uri.parse('https://lazah.net/api/v1/deivces/' + orderid),
          headers: {
            'Authorization':
                'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
            'Accept-Language': 'ar'
          });

      if (response2.statusCode != 200) {
        setState(() {
          return;
        });
      }
      setState(() {});

      globals.currentorder = orderid;

      if (response2.statusCode != 200 ||
          response2.body.contains("DOCTYPE html") ||
          response2.body.contains("html lang")) {
        var x = "ERROR Data malfomed ";
        print(
            "Chatscreen link 360 [||ERROR||]:: Chat malformed Server Response!");
      } else {
        var x = jsonDecode(response2.body);
        print("response2.body:: " + x['driver_id'].toString());
        driverid = x['driver_id'].toString();
        drivertok = x['driver'].toString();
        usertok = x['user_token'].toString();
        user_phone = x['user_phone'].toString();
        driver_phone = x['driver_phone'].toString();
        getlocation();
      }
    }
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (mounted) {
        getlocation();
      } else
        timer.cancel();
    });

    setState(() {
      loaddata = false;
    });
    Timer(Duration(milliseconds: 50), jumm);

    // return mychats;
  }

  String driverid = '';
  String drivertok = '';
  String usertok = '';
  String user_phone = '';
  String driver_phone = '';
  @override
  void dispose() {
    globals.currentorder = '';

    soundRecord.stop();

    for (int i = 0; i < mychats.length; i++) {
      if (mychats[i].type == 'audio' && mychats[i]._player != null)
        mychats[i]._player.dispose();
    }

    super.dispose();
    //...
  }

  Future<bool> loadmore() async {
    var response = await http.get(Uri.parse(nextpageurl), headers: {
      'Authorization':
          'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
      'Accept-Language': 'ar'
    });

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      var x = jsonDecode(response.body)['data'];
      currentpage = jsonDecode(response.body)['current_page'];
      havenext = jsonDecode(response.body)['last_page'] > currentpage;

      nextpageurl = havenext ? jsonDecode(response.body)['next_page_url'] : '';
      print(jsonDecode(response.body));
      for (int i = 0; i < x.length; i++) {
        chat p = new chat();
        p.add(x[i]);
        mychats.add(p);
      }
    } else {}

    setState(() {});
    return true;
  }

  String nextpageurl = '';
  int currentpage = 1;
  Future<void> getlocation() async {
    if (!mounted) return;

    var response2ww = await http.get(
        Uri.parse('https://lazah.net/api/v1/getTrack/' + driverid),
        headers: {
          'Authorization':
              'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
          'Accept-Language': 'ar'
        });

    if (response2ww.statusCode == 200) {
      print("getlocation():: " + response2ww.body);
    }
    if (homemarker == null) {
      BitmapDescriptor markerIcon;
      final mar = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(12, 12)), 'assets/images/addressc.png');

      markerIcon = mar;

      homemarker = Marker(
        markerId: MarkerId("homec"),
        position: LatLng(deliverlat, deliverlong),
        rotation: 0,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: markerIcon,
      );

      markers[MarkerId("homec")] = homemarker;
    }
    // Timer(Duration(milliseconds: 200), refresh);
    // refresh();
    if (response2ww.statusCode == 200 &&
        !response2ww.body.toString().contains('You can not track')) {
      print(jsonDecode(response2ww.body));

      // getmessage();
      // double lng =
      //     double.parse(jsonDecode(response2ww.body)['longitude'].toString());
      // double lat =
      //     double.parse(jsonDecode(response2ww.body)['latitude'].toString());
      longitude =
          double.parse(jsonDecode(response2ww.body)['longtuide'].toString());
      latitude =
          double.parse(jsonDecode(response2ww.body)['latitude'].toString());

      print("Location Data:: " + longitude.toString() + latitude.toString());
      // longitude = lng.sign;
      // latitude = lat.sign;
      if (mounted) {
        updateMarkerAndCircle(new LatLng(latitude, longitude), 0);
      }
      if (tracktype == 0)
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
          ),
        );

      if (tracktype == 1)
        await updateCameraLocation(LatLng(latitude, longitude),
            LatLng(deliverlat, deliverlong), mapController);
    }
  }

  String constructFCMPayload(String mes, String type, List<String> tokens) {
    return jsonEncode({
      'registration_ids': tokens,
      'data': {
        'ismessage': '1',
        'orderid': orderid,
        'senderid': userid,
        'msg': mes,
        'type': type,
        'time': DateTime.now()
            .toUtc()
            .toString()
            .replaceAll("T", " ")
            .substring(0, 16),
      },
      'notification': {
        'title': 'رسالة جديدة طلب رقم' + orderid,
        'body': type == 'text' ? mes : 'ملف وسائط'
      }
    });
  }

  Future<void> sendPushMessage(
      String mes, String type, List<String> tokens) async {
    try {
      var re = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAQjEGBHI:APA91bHm34WZI9iAhoFGbg6z35pctHpvIsBluu8c_ToMTvp8B2yh8FFEKUHCirO9X0gH1Ag1mnoDTSiFm9rBF32DsvX2n8Gj2srAQ58_qMBSxu3jnaolK0SSihK6MNU9hKs07TPdTLtU'
        },
        body: constructFCMPayload(mes, type, tokens),
      );
      print("sendPushMessage:: " + re.body);
    } catch (e) {
      print(e);
    }
  }

  void sendpushup(String mes, String type, List<String> tokens) {
    // Timer(Duration(seconds: 1), () {
    sendPushMessage(mes, type, tokens);
    // });
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 130);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Marker myloc;
  BitmapDescriptor markerIcon;

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    if (mounted) {
      LatLngBounds l1 = await mapController.getVisibleRegion();
      LatLngBounds l2 = await mapController.getVisibleRegion();

      if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
        return checkCameraLocation(cameraUpdate, mapController);
      }
    }
  }

  void updateMarkerAndCircle(LatLng newLocalData, double heading) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    BitmapDescriptor mr;
    final markericon = BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(12, 12)), 'assets/images/addressc.png');

    mr = markerIcon;
    if (mounted) {
      this.setState(() {
        if (homemarker == null) {
          homemarker = Marker(
            markerId: MarkerId("homec"),
            position: LatLng(deliverlat, deliverlong),
            rotation: heading,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: mr,
          );

          markers[MarkerId("homec")] = homemarker;
        }
        if (marker == null) {
          BitmapDescriptor markerIcon;
          final marker2 = BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(12, 12)),
              'assets/images/driving_pin.png');
          // markerIcon = marker2;
          marker = Marker(
            markerId: MarkerId("home"),
            position: latlng,
            rotation: heading,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.defaultMarker,
          );

          markers[MarkerId("home")] = marker;
        } else {
          // BitmapDescriptor markerIcon2;
          // markerIcon = BitmapDescriptor.fromAssetImage(
          //     ImageConfiguration(size: Size(12, 12)),
          //     'assets/driving_pin.png') as BitmapDescriptor;

          // markerIcon2 = markerIcon;
          marker = Marker(
            markerId: MarkerId("home"),
            position: latlng,
            rotation: heading,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.defaultMarker,
          );

          markers[MarkerId("home")] = marker;
        }
      });
    }
  }

  int tracktype = 0;
  Marker marker;
  Marker homemarker;
  double size2 = 12;
  bool loaddata = true;
  ScrollController controller = new ScrollController();
  double longitude = 0;
  double latitude = 0;
  GoogleMapController mapController;
  LocationData myCurrentLocation;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (Theme.of(context).brightness == Brightness.dark) if (mapController !=
        null) {
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
    }
  }

  Map<MarkerId, Marker> markers = {};
  @override
  void initState() {
    // getmessage().then((value) {
    //   setState(() {
    //     print("Chat Value:: $value");
    //     // chat().add(value);
    //   });
    // });
    getmessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var ismessage = message.data['ismessage'].toString();
      var orderid = message.data['orderid'].toString();
      var senderid = message.data['senderid'].toString();
      var msg = message.data['msg'].toString();
      var type = message.data['type'].toString();

      if (mounted) {
        // Timer(Duration(milliseconds: 10000), () {
        //   getmessage();
        // });
        // Timer.periodic(const Duration(seconds: 6), (timer) async {
        //   if (mounted) {
        //     getmessage();
        //   } else
        //     timer.cancel();
        // });
        if (ModalRoute.of(context).isCurrent) if (ismessage == '1') {
          chat p = new chat();
          p.message = msg;
          p.type = type;
          p.url = msg;
          p._player = new AudioPlayer();
          print(msg);
          p._player.setSourceUrl('https://lazah.net/' + msg);
          mychats.insert(0, p);
          if (p.type == 'audio') setState(() {});
          Timer(Duration(milliseconds: 100), () {
            controller..jumpTo(controller.position.minScrollExtent);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _about = Provider.of<GlobalData>(context, listen: false).about;
    return Scaffold(
      appBar: AppBar(
        //  title: Text('${AppLocalizations.of(context).meswithdriver}'),
        title: loaddata
            ? Text('')
            : Text(userid == driverid
                ? (Localizations.localeOf(context).languageCode == 'ar'
                    ? ('التواصل مع العميل')
                    : ('Communication with the customer'))
                : (Localizations.localeOf(context).languageCode == 'ar'
                    ? ('التواصل مع المندوب')
                    : ('Communicate with the driver'))),

        actions: [
          InkWell(
            onTap: () {
              print(
                  'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
              print(user_phone);
              print(driver_phone);
              launch(userid == driverid
                  ? "tel://$user_phone"
                  : 'tel://$driver_phone');
            },
            child: Icon(
              Icons.phone,
              color: Colors.green,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              {
                setState(() {
                  showmap = !showmap;
                });
              }
            },
            child: Container(
                child: Container(
                    width: 40,
                    height: 40,
                    child: Icon(
                        showmap ? Icons.message : Icons.location_on_outlined))),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            compassEnabled: false,
            indoorViewEnabled: true,
            onTap: (LatLng latLng) {
              setState(() {
                showmap = true;
              });
            },
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            myLocationEnabled: false,
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  deliverlat,
                  deliverlong,
                ),
                zoom: 13.0),
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      if (tracktype == 0)
                        tracktype = -1;
                      else
                        tracktype = 0;
                      setState(() {});
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: tracktype == 0
                              ? Colors.black
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/driving_pin.png',
                          height: 35,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (tracktype == 1)
                        tracktype = -1;
                      else
                        tracktype = 1;
                      setState(() {});
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: tracktype == 1
                              ? Colors.black
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/driving_pin.png',
                            height: 35,
                          ),
                          Image.asset(
                            'assets/images/addressc.png',
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 50),
            top: showmap ? MediaQuery.of(context).size.height : 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/food.png'),
                      fit: BoxFit.cover)),
              child: Container(
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 16, right: 5, left: 5),
                  child: loaddata
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey,
                          child: ListView(
                            controller: controller,
                            children: List.generate(
                                5,
                                (index) => Align(
                                      alignment: index % 2 == 0
                                          ? Alignment.topRight
                                          : Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment: index % 2 == 0
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 200,
                                            decoration: BoxDecoration(
                                                color: index % 2 == 0
                                                    ? Colors.grey
                                                    : Colors.grey[300],
                                                borderRadius: BorderRadius.only(
                                                    topLeft: index % 2 == 0
                                                        ? Radius.circular(20)
                                                        : Radius.zero,
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight: index % 2 != 0
                                                        ? Radius.circular(20)
                                                        : Radius.zero)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                    fontSize: size2,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '',
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                                fontSize: size2,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    )),
                          ),
                        )
                      : GestureDetector(
                          onHorizontalDragEnd: (d) {
                            setState(() {
                              record = false;
                            });
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: LoadMore(
                                  isFinish: !havenext,
                                  onLoadMore: loadmore,
                                  textBuilder: ggg,
                                  child: ListView(
                                      reverse: true,
                                      addAutomaticKeepAlives: true,
                                      controller: controller,
                                      children: List.generate(
                                        mychats.length,
                                        (index) {
                                          return Align(
                                            alignment:
                                                mychats[index].sender_id ==
                                                        userid
                                                    ? Alignment.topRight
                                                    : Alignment.topLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  mychats[index].sender_id ==
                                                          userid
                                                      ? CrossAxisAlignment.start
                                                      : CrossAxisAlignment.end,
                                              children: [
                                                mychats[index].type == 'link'
                                                    ? InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (mychats[index]
                                                                    .message
                                                                    .length <
                                                                7) return;
                                                            showmap = true;
                                                            int indewx =
                                                                mychats[index]
                                                                    .message
                                                                    .indexOf(
                                                                        '*');

                                                            double lang = double
                                                                .parse(mychats[
                                                                        index]
                                                                    .message
                                                                    .substring(
                                                                        0,
                                                                        indewx));
                                                            double lat = double
                                                                .parse(mychats[
                                                                        index]
                                                                    .message
                                                                    .substring(
                                                                        indewx +
                                                                            1));
                                                            tracktype = -1;
                                                            if (myloc == null) {
                                                              // BitmapDescriptor
                                                              //     markerIcon;
                                                              // final miniMark = BitmapDescriptor.fromAssetImage(
                                                              //     ImageConfiguration(
                                                              //         size: Size(
                                                              //             12,
                                                              //             12)),
                                                              // 'assets/images/location4.png');

                                                              // markerIcon =
                                                              //     miniMark;

                                                              myloc = Marker(
                                                                markerId:
                                                                    MarkerId(
                                                                        "myloc"),
                                                                position:
                                                                    LatLng(lat,
                                                                        lang),
                                                                rotation: 0,
                                                                draggable:
                                                                    false,
                                                                zIndex: 2,
                                                                flat: true,
                                                                anchor: Offset(
                                                                    0.5, 0.5),
                                                                icon: BitmapDescriptor
                                                                    .defaultMarker,
                                                              );

                                                              markers[MarkerId(
                                                                      "myloc")] =
                                                                  myloc;
                                                            }
                                                            mapController
                                                                .animateCamera(
                                                              CameraUpdate
                                                                  .newCameraPosition(
                                                                CameraPosition(
                                                                    target:
                                                                        LatLng(
                                                                            lat,
                                                                            lang),
                                                                    zoom: 15),
                                                              ),
                                                            );
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 120,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .red),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors
                                                                  .grey[200]),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.location_on,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : mychats[index].type ==
                                                            'img'
                                                        ? FullScreenWidget(
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[200],
                                                            images: mychats[index]
                                                                        .file !=
                                                                    null
                                                                ? null
                                                                : ('https://lazah.net/' +
                                                                    (mychats[
                                                                            index]
                                                                        .url)),
                                                            imagesf:
                                                                mychats[index]
                                                                    .file,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: mychats[index]
                                                                          .file !=
                                                                      null
                                                                  ? Image.file(
                                                                      mychats[index]
                                                                          .file,
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          250,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      'https://lazah.net/' +
                                                                          (mychats[index]
                                                                              .url),
                                                                      width:
                                                                          200,
                                                                      height:
                                                                          250,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                            ),
                                                          )
                                                        : mychats[index].type ==
                                                                'audio'
                                                            ? Container(
                                                                width: 120,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Colors
                                                                            .grey[
                                                                        200]),
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: audiow(
                                                                        index)

                                                                    // Audiofile(c: mychats[index],index: index,),
                                                                    ),
                                                              )
                                                            : mychats[index]
                                                                        .type ==
                                                                    'video'
                                                                ? Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Container(),

                                                                    // Videofile(c: mychats[index],index: index,),
                                                                  )
                                                                : Container(
                                                                    decoration: BoxDecoration(
                                                                        color: mychats[index].sender_id ==
                                                                                userid
                                                                            ? Colors.blue[
                                                                                300]
                                                                            : Colors.grey[
                                                                                300],
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft: mychats[index].sender_id == userid
                                                                                ? Radius.circular(20)
                                                                                : Radius.zero,
                                                                            topRight: Radius.circular(20),
                                                                            bottomLeft: Radius.circular(20),
                                                                            bottomRight: mychats[index].sender_id != userid ? Radius.circular(20) : Radius.zero)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20,
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        mychats[index]
                                                                            .message,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                size2,
                                                                            fontWeight:
                                                                                FontWeight.w800),
                                                                      ),
                                                                    ),
                                                                  ),
                                                index == 0 ||
                                                        mychats[index - 1]
                                                                .sender_id !=
                                                            mychats[index]
                                                                .sender_id
                                                    ? Text(
                                                        dh.DateFormat('hh:mm a')
                                                            .format(DateTime
                                                                .parse(mychats[
                                                                            index]
                                                                        .date ??
                                                                    DateTime.now()
                                                                        .toString()))
                                                            .replaceAll(
                                                                'PM', 'م')
                                                            .replaceAll(
                                                                'AM', 'ص'),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        style: TextStyle(
                                                            fontSize: size2 - 2,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.grey),
                                                      )
                                                    : Container(),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )),
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: record ? 120 : 0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    color: Colors.white),
                                child: Visibility(
                                  visible: record,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Record recordInstance;
                                            await soundRecord.stop();
                                            setState(() {
                                              record = false;
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  shape: BoxShape.circle),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              )),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          'assets/images/rec-record.gif',
                                          height: 40,
                                        ),
                                        Spacer(),
                                        InkWell(
                                            onTap: () async {
                                              await soundRecord.stop();

                                              Directory tempDir =
                                                  await getTemporaryDirectory();

                                              String tempPath = tempDir.path;

                                              chat o = new chat();
                                              o.sender_id = userid;
                                              o.path = tempPath +
                                                  mychats.length.toString() +
                                                  'myFile2.m4a';
                                              o.type = 'audio';
                                              o.date = DateTime.now()
                                                  .toString()
                                                  .substring(0, 16);
                                              o._player = new AudioPlayer();
                                              o.nowsen = true;
                                              o.duration = o._player
                                                  .setSourceUrl(o.path);
                                              setState(() {
                                                o.loading = false;
                                              });
                                              senmes(
                                                  1,
                                                  tempPath +
                                                      mychats.length
                                                          .toString() +
                                                      'myFile2.m4a',
                                                  mychats.length);
                                              mychats.insert(0, o);
                                              setState(() {});
                                              Timer(Duration(milliseconds: 50),
                                                  jumm);
                                              setState(() {
                                                record = false;
                                              });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.send,
                                                  color: Colors.blue,
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: !record ? 50 : 0,
                                child: Visibility(
                                  visible: !record,
                                  child: GestureDetector(
                                    onHorizontalDragEnd: (d) {
                                      setState(() {
                                        record = false;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: Colors.grey[100],
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              transitionBuilder: (Widget child,
                                                  Animation<double> animation) {
                                                return ScaleTransition(
                                                    scale: animation,
                                                    child: child);
                                              },
                                              child: record
                                                  ? Shimmer.fromColors(
                                                      child: Container(
                                                        height: 55,
                                                        child: Center(
                                                            child: Text(
                                                                'إسحب لإلغاء التسجيل')),
                                                      ),
                                                      baseColor: Colors.grey,
                                                      highlightColor:
                                                          Colors.white)
                                                  : Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Expanded(
                                                            child:
                                                                TextFormField(
                                                          controller: mesc,
                                                          maxLines: null,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'أدخل رسالتك'),
                                                        )),
                                                        InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          onTap: () async {
                                                            if (mesc.text
                                                                    .trim()
                                                                    .length ==
                                                                0) return;

                                                            senmes(0, 'd',
                                                                mychats.length);
                                                          },
                                                          child: Container(
                                                              width: 35,
                                                              height: 35,
                                                              child: Icon(
                                                                Icons.send,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (globals.latitude == -1) return;
                                            senmes(4, '', mychats.length);
                                          },
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              child: Icon(Icons.location_on)),
                                        ),
                                        GestureDetector(
                                          onTapUp: (d) async {
                                            await soundRecord.stop();

                                            Directory tempDir =
                                                await getTemporaryDirectory();

                                            String tempPath = tempDir.path;

                                            chat o = new chat();
                                            o.sender_id = userid;
                                            o.path = tempPath +
                                                mychats.length.toString() +
                                                'myFile2.m4a';

                                            print("tempPath:: " + tempPath);
                                            print("path:: " + o.path);
                                            o.type = 'audio';
                                            o.date = DateTime.now()
                                                .toString()
                                                .substring(0, 16);
                                            o._player = new AudioPlayer();
                                            o.nowsen = true;
                                            o.duration = o.duration;

                                            // audioUrl = UrlSource(o.path);

                                            await o._player
                                                .setSourceUrl(o.path);

                                            setState(() {
                                              o.loading = false;
                                            });
                                            senmes(
                                                1,
                                                tempPath +
                                                    mychats.length.toString() +
                                                    'myFile2.m4a',
                                                mychats.length);
                                            mychats.insert(0, o);
                                            setState(() {});
                                            Timer(Duration(milliseconds: 500),
                                                jumm);
                                            setState(() {
                                              record = false;
                                            });
                                          },
                                          onLongPressDown: (d) async {
                                            setState(() {
                                              record = true;
                                            });

                                            // bool result = await recordInst
                                            //     .hasPermission();
                                            if (await soundRecord
                                                .hasPermission()) {
                                              Directory tempDir =
                                                  await getTemporaryDirectory();
                                              //
                                              String tempPath = tempDir.path;
                                              final isSupported =
                                                  await soundRecord
                                                      .isEncoderSupported(
                                                AudioEncoder.aacLc,
                                              );
                                              if (isSupported) {
                                                print(
                                                    '${AudioEncoder.aacLc.name} supported: $isSupported');
                                              } else {
                                                print(
                                                    '${AudioEncoder.aacLc.name} not supported: $isSupported');
                                              }
                                              await soundRecord.start(
                                                path: tempPath +
                                                    mychats.length.toString() +
                                                    'myFile2.m4a', // required
                                                encoder: AudioEncoder
                                                    .aacLc, // by default
                                                bitRate: 128000, // by default
                                                samplingRate: 44100,
                                              );

                                              bool isRecording =
                                                  await soundRecord
                                                      .isRecording();
                                              print('dount');
                                            } else {
                                              print(
                                                  "Sound Record permissions == not granted!");
                                            }
                                          },
                                          child: Container(
                                              width: 50,
                                              height: 50,
                                              child: Center(
                                                  child: AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      width: record ? 50 : 45,
                                                      height: record ? 50 : 45,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: record
                                                              ? Colors.blue[300]
                                                              : Colors
                                                                  .grey[300]),
                                                      child: Icon(
                                                        Icons.mic,
                                                        color: Colors.blue,
                                                      )))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String ggg(g) {
    return " ";
  }

  Widget audiow(int index) {
    return InkWell(
      onTap: () async {
        if (mychats[index]._player.state == PlayerState.playing)
          mychats[index]._player.pause();
        else {
          mychats.forEach((element) {
            element._player == null ? print('') : element._player.pause();
          });
          mychats[index]._player.resume();
        }
      },
      child: mychats[index]._player == null
          ? Container(
              width: 40,
              height: 40,
              color: Colors.blue,
            )
          : Row(
              children: [
                StreamBuilder<PlayerState>(
                    stream: mychats[index]._player.onPlayerStateChanged,
                    builder: (context, snapshot3) {
                      return Row(
                        children: [
                          StreamBuilder<Duration>(
                              stream: mychats[index]._player.onDurationChanged,
                              builder: (context, snapshot) {
                                return Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blueGrey[100]),
                                        child: Icon(snapshot3.data ==
                                                PlayerState.playing
                                            ? Icons.pause
                                            : Icons.play_arrow),
                                      ),
                                      StreamBuilder<Duration>(
                                          stream: mychats[index]
                                              ._player
                                              .onDurationChanged,
                                          builder: (context, snapshot1) {
                                            return snapshot1.hasData
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        height: 2,
                                                        child: snapshot.hasData
                                                            ? LinearProgressIndicator(
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        900],
                                                                value: snapshot
                                                                            .data
                                                                            .inMilliseconds ==
                                                                        0
                                                                    ? 0
                                                                    : (snapshot1.data.inMilliseconds *
                                                                            100 /
                                                                            snapshot.data.inMilliseconds) /
                                                                        100,
                                                              )
                                                            : Container(),
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Visibility(
                                                        visible: snapshot1
                                                                .hasData &&
                                                            snapshot1.data
                                                                    .inMicroseconds >
                                                                1,
                                                        child: Container(
                                                          child: Center(
                                                            child: Text(
                                                              snapshot1.hasData
                                                                  ? gettim(snapshot1
                                                                      .data
                                                                      .inSeconds)
                                                                  : '00:00',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .black45),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: !snapshot1
                                                                .hasData ||
                                                            snapshot1.data
                                                                    .inMicroseconds <
                                                                100,
                                                        child: Container(
                                                          child: Text(
                                                            snapshot.hasData
                                                                ? gettim(snapshot
                                                                    .data
                                                                    .inSeconds)
                                                                : '00:00',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .black45),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        height: 2,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Visibility(
                                                        visible: !snapshot1
                                                                .hasData ||
                                                            snapshot1.data
                                                                    .inMicroseconds <
                                                                100,
                                                        child: Container(
                                                          child: FutureBuilder<
                                                                  int>(
                                                              future: null,
                                                              builder: (context,
                                                                  snapshot4) {
                                                                return Text(
                                                                    snapshot
                                                                            .hasData
                                                                        ? gettim(snapshot
                                                                            .data
                                                                            .inSeconds)
                                                                        : snapshot4
                                                                                .hasData
                                                                            ? gettim((snapshot4.data / 1000)
                                                                                .toInt())
                                                                            : '00:00',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .black45));
                                                              }),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                          }),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      );
                    }),
              ],
            ),
    );
  }

  String gettim(int duration) {
    String s = '';

    if (duration < 60) {
      String ss = duration < 10 ? '00:0$duration' : '00:$duration';
      if (ss.length > 5) ss = '00:00';
      return ss;
    } else {
      int minute = (duration / 60).toInt();
      int sec = duration - (minute * 60);

      if (minute < 10) {
        String ss = sec < 10 ? '0$minute:0$duration' : '0$minute:$sec';
        if (ss.length > 5) ss = '00:00';
        return ss;
      } else {
        String ss = sec < 10 ? '$minute:0$duration' : '$minute:$sec';
        if (ss.length > 5) ss = '00:00';
        return ss;
      }
    }
  }

  bool video = false;
  bool record = false;
  String hh(g) {
    return '';
  }

  TextEditingController mesc = new TextEditingController();
  List<chat> mychats = [];

  bool showmap = false;
}

class chat {
  bool sente = false;
  bool nowsen = false;
  bool playing = false;
  int time = 0;
  bool completload = false;
  Timer periodicTimer;
  bool loading = true;
  var duration;
  AudioPlayer _player;

  String sender_id;
  File file;
  String message;
  String date;
  String path;
  String url;
  String type = '';
  void initialiseaudio() async {
    var file2 =
        await DefaultCacheManager().getSingleFile('https://lazah.net/' + url);

    try {
      await _player.setSourceUrl(file2.path);
      duration = await _player.getDuration();
    } catch (e) {
      throw e;
    }
  }

  void add(var x) {
    sender_id = x['sender_id'].toString();
    type = x['type'].toString();
    _player = new AudioPlayer();
    _player.setPlayerMode(PlayerMode.mediaPlayer);
    _player.setVolume(1);
    _player.setReleaseMode(ReleaseMode.stop);
    if (type == 'audio') {
      url = x['msg'].toString();
      initialiseaudio();
    }

    if (type == 'img') url = x['msg'].toString();
    if (type == 'video') url = x['msg'].toString();
    message = x['msg'].toString();
    date = DateTime.parse(
            x['created_at'].toString().replaceAll("T", " ").substring(0, 16))
        .add(DateTime.now().timeZoneOffset)
        .toString()
        .substring(0, 16);
  }
}
