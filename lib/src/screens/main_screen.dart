import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Serve_ios/l10n/messages_ar.dart';
import 'package:Serve_ios/src/screens/chatscreen.dart';
import 'package:Serve_ios/src/screens/order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/cart_restaurant.dart';
import 'package:Serve_ios/src/models/order.dart';
import 'package:Serve_ios/src/models/user.dart';
import 'package:Serve_ios/src/providers/cart.dart';
import 'package:Serve_ios/src/providers/maps.dart';
import 'package:Serve_ios/src/providers/notifications.dart';
import 'package:Serve_ios/src/providers/orders.dart';
import 'package:Serve_ios/src/screens/delivery_requests_screen.dart';
import 'package:Serve_ios/src/screens/home_screen.dart';
import 'package:Serve_ios/src/screens/my_requests_screen.dart';
import 'package:Serve_ios/src/screens/offers_screen.dart';
import 'package:Serve_ios/src/screens/order_tracking_screen.dart';
import 'package:Serve_ios/src/screens/registration_screen.dart';
import 'package:Serve_ios/src/screens/settings_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:another_flushbar/flushbar.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import 'cart_screen.dart';
import 'delivery_address_screen.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage backgroundMessage) async {
  print("We Got a background notification");
  // await backgroundNotificationBridge(messagea: backgroundMessage, context: context);
  var message = backgroundMessage.data;
  print("Background MSG:: ${message}");
}

// void backgroundNotificationBridge(
//     {RemoteMessage messagea, BuildContext context}) async {
//   final xxx = Provider.of<Notifications>(context, listen: false);

//   await FirebaseMessaging.instance.getToken().then((token) {
//     print("_firebaseMessaging:: " + token);
//     xxx.updateDeviceToken(token);
//   });

//   await FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) {
//     print("_configureFirebasenewToken:: " + newToken);
//     xxx.updateDeviceToken(newToken);
//   });

//   var message = messagea.data;
//   if (Platform.isIOS) {
//     var xx = message['data'];
//     // print(xx);

//     message['data'] = {};
//     message['data']['data'] = xx;
//   }
//   if (message != null) {
//     print("message Data:: ${message}");
//     print("message Data body:: ${messagea.notification.body}");

//     print("message data object:: ${messagea.data['data']}");

//     xxx.addNotification(messagea.data['data'].toString());
//     xxx.increaseCount();
//     xxx.getNotificationCount();
//     if (await Vibration.hasVibrator()) {
//       if (await Vibration.hasAmplitudeControl()) {
//         Vibration.vibrate(duration: 500, amplitude: 128);
//       } else {
//         Vibration.vibrate(duration: 500);
//       }
//     }
//   }
//   FlutterRingtonePlayer.playNotification();

//   final notificationDetails = json.decode(messagea.data['data']);
//   final int type = notificationDetails['notification_type'];
//   if (type == 11) {
//     // _authReference.updateUserData();
//   }
//   Flushbar(
//     margin: EdgeInsets.all(8),
//     borderRadius: BorderRadius.circular(8),
//     title: Platform.isIOS
//         ? message['aps']['alert']['title']
//         : notificationDetails['notification_title'],
//     message: Platform.isIOS
//         ? message['aps']['alert']['body']
//         : notificationDetails['notification_message'],
//     dismissDirection: FlushbarDismissDirection.VERTICAL,
//     isDismissible: true,
//     reverseAnimationCurve: Curves.easeIn,
//     flushbarPosition: FlushbarPosition.TOP,
//     forwardAnimationCurve: Curves.linear,
//     animationDuration: Duration(seconds: 2),
//     duration: Duration(seconds: 7),
//     onTap: (Flushbar ff) {
//       print("Clicked backgorund notifications!");
//       //  notificationClicked(notificationDetails);
//     },
//   )..show(context);
// }

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with AlertsMixin {
  int _activePageIndex = 0;

  Auth _authReference;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool firebaseConfigured = false;

  Future<void> firebaseMessagingForgroundHandler(RemoteMessage messagea) async {
    final xxx = Provider.of<Notifications>(context, listen: false);
    var message = messagea.data;
    print("Called:: firebaseMessagingForgroundHandler");
    if (Platform.isIOS) {
      var xx = message['data'];
      // print(xx);

      message['data'] = {};
      message['data']['data'] = xx;
    }
    if (message != null) {
      print("message Data:: ${message}");
      print("message Data body:: ${messagea.notification.body}");

      print("message data object:: ${messagea.data['data']}");

      xxx.addNotification(messagea.data['data'].toString());
      xxx.increaseCount();
      xxx.getNotificationCount();
      if (await Vibration.hasVibrator()) {
        if (await Vibration.hasAmplitudeControl()) {
          Vibration.vibrate(duration: 500, amplitude: 128);
        } else {
          Vibration.vibrate(duration: 500);
        }
      }
    }

    String notificationDetails = '';
    int type = 0;

    FlutterRingtonePlayer.playNotification();

    if (messagea.data['data'] == null) {
      notificationDetails = messagea.notification.body;
      type = 1;

      Flushbar(
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        title: Platform.isIOS
            ? message['aps']['alert']['title']
            : messagea.notification.title,
        message: Platform.isIOS
            ? message['aps']['alert']['body']
            : notificationDetails,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
        isDismissible: true,
        reverseAnimationCurve: Curves.easeIn,
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.linear,
        animationDuration: Duration(seconds: 2),
        duration: Duration(seconds: 7),
        onTap: (Flushbar ff) {
          notificationClicked(notificationDetails);
        },
      )..show(context);
    } else {
      final notificationDetails = json.decode(messagea.data['data']);
      final int type = notificationDetails['notification_type'];
      if (type == 11) {
        _authReference.updateUserData();
      }
      Flushbar(
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        title: Platform.isIOS
            ? message['aps']['alert']['title']
            : notificationDetails['notification_title'],
        message: Platform.isIOS
            ? message['aps']['alert']['body']
            : notificationDetails['notification_message'],
        dismissDirection: FlushbarDismissDirection.VERTICAL,
        isDismissible: true,
        reverseAnimationCurve: Curves.easeIn,
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.linear,
        animationDuration: Duration(seconds: 2),
        duration: Duration(seconds: 7),
        onTap: (Flushbar ff) {
          notificationClicked(notificationDetails);
        },
      )..show(context);
    }
  }

  void notificationClicked(notificationDetails) {
    final int type = notificationDetails['notification_type'];
    if (type == 2 || type == 4 || type == 5 || type == 6) {
      final ordersReference = Provider.of<Orders>(context, listen: false);
      if (ordersReference.myOrders.indexWhere((element) =>
              element.id == notificationDetails['notification_data']['id']) ==
          -1)
        ordersReference.insertTempOrder(
            Order.fromJson(notificationDetails['notification_data']));
      Navigator.of(context).pushNamed(OrderTrackingScreen.routeName,
          arguments: notificationDetails['notification_data']['id']);
    } else if (type == 3) {
      Navigator.of(context).pushNamed(DeliveryRequestsScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(MainScreen.routeName);
    }
  }

  StreamSubscription tokenSubscription;
  _configureFirebase() {
    print("called:: _configureFirebase");

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission();
    }

    final xxx = Provider.of<Notifications>(context, listen: false);

    _firebaseMessaging.getToken().then((token) {
      print("_firebaseMessaging:: " + token);
      xxx.updateDeviceToken(token);
    });

    tokenSubscription?.cancel();
    tokenSubscription =
        _firebaseMessaging.onTokenRefresh.listen((String newToken) {
      print("_configureFirebasenewToken:: " + newToken);
      xxx.updateDeviceToken(newToken);
    });
    // print("_configureFirebase:: " + tokenSubscription.toString());

    // Future.delayed(Duration(milliseconds: 100), () {
    // FirebaseMessaging.onMessage.listen((RemoteMessage messagea) async {
    //   var message = messagea.data;
    //   if (Platform.isIOS) {
    //     var xx = message['data'];
    //     // print(xx);

    //     message['data'] = {};
    //     message['data']['data'] = xx;
    //   }
    //   if (message != null) {
    //     print("message Data:: ${message}");
    //     print("message Data body:: ${messagea.notification.body}");

    //     print("message data object:: ${messagea.data['data']}");

    //     xxx.addNotification(message['data'].toString());
    //     xxx.increaseCount();
    //     xxx.getNotificationCount();
    //     if (await Vibration.hasVibrator()) {
    //       if (await Vibration.hasAmplitudeControl()) {
    //         Vibration.vibrate(duration: 500, amplitude: 128);
    //       } else {
    //         Vibration.vibrate(duration: 500);
    //       }
    //     }
    //   }
    //   String notificationDetails = '';
    //   int type = 0;
    //   FlutterRingtonePlayer.playNotification();

    //   if (messagea.data['data'] == null) {
    //     notificationDetails = messagea.notification.body;
    //     type = 1;

    //     Flushbar(
    //       margin: EdgeInsets.all(8),
    //       borderRadius: BorderRadius.circular(8),
    //       title: Platform.isIOS
    //           ? message['aps']['alert']['title']
    //           : notificationDetails,
    //       message: Platform.isIOS
    //           ? message['aps']['alert']['body']
    //           : notificationDetails,
    //       dismissDirection: FlushbarDismissDirection.VERTICAL,
    //       isDismissible: true,
    //       reverseAnimationCurve: Curves.easeIn,
    //       flushbarPosition: FlushbarPosition.TOP,
    //       forwardAnimationCurve: Curves.linear,
    //       animationDuration: Duration(seconds: 2),
    //       duration: Duration(seconds: 7),
    //       onTap: (Flushbar ff) {
    //         notificationClicked(notificationDetails);
    //       },
    //     )..show(context);
    //   } else {
    //     final notificationDetails = json.decode(messagea.data['data']);
    //     type = notificationDetails['notification_type'];

    //     if (type == 11) {
    //       _authReference.updateUserData();
    //     }
    //     Flushbar(
    //       margin: EdgeInsets.all(8),
    //       borderRadius: BorderRadius.circular(8),
    //       title: Platform.isIOS
    //           ? message['aps']['alert']['title']
    //           : notificationDetails['notification_title'],
    //       message: Platform.isIOS
    //           ? message['aps']['alert']['body']
    //           : notificationDetails['notification_message'],
    //       dismissDirection: FlushbarDismissDirection.VERTICAL,
    //       isDismissible: true,
    //       reverseAnimationCurve: Curves.easeIn,
    //       flushbarPosition: FlushbarPosition.TOP,
    //       forwardAnimationCurve: Curves.linear,
    //       animationDuration: Duration(seconds: 2),
    //       duration: Duration(seconds: 7),
    //       onTap: (Flushbar ff) {
    //         notificationClicked(notificationDetails);
    //       },
    //     )..show(context);
    //   }
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage messagea) {
      var message = messagea.data;
      if (Platform.isIOS) {
        var xx = message['data'];
        print(xx);

        message['data'] = {};
        message['data']['data'] = xx;
      }
      xxx.increaseCount();
      xxx.getNotificationCount();

      if (message != null) {
        final notificationDetails = json.decode(message['data']['data']);
        final int type = notificationDetails['notification_type'];
        if (type == 11) {
          _authReference.updateUserData();
        }
        notificationClicked(notificationDetails);
      }
    });

    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {

    //   },
    //   onLaunch: (Map<String, dynamic> message) async {

    //   },
    //   onResume: (Map<String, dynamic> message) async {

    //   },
    // );
    // });
    if (mounted) {
      if(isInRange() == true){
      FirebaseMessaging.onMessage.listen(firebaseMessagingForgroundHandler);
      }
    }
    
    if(isInRange() == true){
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage message) {
    //   if (message == null) return;
    //   print("getInitialMessage():: " + message.data.toString());
    //   backgroundNotificationBridge(messagea: message);
    // });
  }

  @override
  void didChangeDependencies() {
    _authReference = Provider.of<Auth>(context, listen: false);
    if (!firebaseConfigured) {
      _configureFirebase();
      Provider.of<MapsProvider>(context, listen: false).startLocationSharing();
      //  firebaseConfigured = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tokenSubscription?.cancel();
    super.dispose();
  }


  Future<bool> isInRange() async {

     final prefs =  await SharedPreferences.getInstance();

     bool inRange;
     
    if (prefs.containsKey('in_range')) 
       inRange = prefs.getBool('in_range');

      print("Is user In Range ${inRange}");
     
          return Future<bool>.value(inRange);
 
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _pages = [
      {
        'title': AppLocalizations.of(context).home,
        'pageTitle': AppLocalizations.of(context).home,
        'screen': HomeScreen(),
        'icon': Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Image.asset('assets/images/Restaurant.png'),
        )
      },
      {
        'title': AppLocalizations.of(context).offers,
        'pageTitle': AppLocalizations.of(context).offers,
        'screen': OffersScreen(),
        'icon': Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Image.asset('assets/images/Offers.png'),
        )
      },
      {
        'title': AppLocalizations.of(context).myRequests,
        'pageTitle': AppLocalizations.of(context).myRequests,
        'screen': MyRequestsScreen(),
        'icon': Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Image.asset('assets/images/My_Requests.png'),
        )
      },
      {
        'title': AppLocalizations.of(context).more,
        'pageTitle': AppLocalizations.of(context).more,
        'screen': SettingsScreen(),
        'icon': Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Image.asset('assets/images/menu.png'),
        )
      },
    ];

    return Scaffold(
      appBar: _activePageIndex == 3 || _activePageIndex == 2
          ? AppBar(
              elevation: 0,
              leading: Row(
                children: <Widget>[
                  Selector<Auth, User>(
                    selector: (_, auth) => auth.user,
                    builder: (_, user, __) => IconButton(
                      onPressed: () async {
                        if (user != null)
                          Navigator.of(context)
                              .pushNamed(DeliveryAddressScreen.routeName);
                        else {
                          final xx = (await showConfirmDialog(
                                  context,
                                  null,
                                  AppLocalizations.of(context).login,
                                  AppLocalizations.of(context).pleaseLoginFirst,
                                  [
                                    AppLocalizations.of(context).cancel,
                                    AppLocalizations.of(context).login
                                  ]) ??
                              false);
                          if (xx)
                            Navigator.of(context)
                                .pushNamed(RegistrationScreen.routeName);
                        }
                      },
                      icon: Image.asset('assets/images/Location.png'),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: 0.4,
                    alignment: Alignment.center,
                    child: Container(
                      width: 1.5,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              title: Text(_pages[_activePageIndex]['title']),
              actions: <Widget>[
                Selector<Cart, List<CartRestaurant>>(
                  selector: (_, cart) => cart.getCartItemsForEachRestaurant(),
                  builder: (_, cartItems, __) => badge.Badge(
                    position: badge.BadgePosition(top: 0.0, end: 0.0),
                    padding: const EdgeInsets.all(6.0),
                    showBadge: cartItems.length > 0,
                    animationType: badge.BadgeAnimationType.scale,
                    animationDuration: Duration(milliseconds: 200),
                    alignment: AppLocalizations.of(context).isArabic
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    badgeContent: Text(
                      '${cartItems.length ?? ' '}',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      icon: Image.asset('assets/images/cart.png'),
                    ),
                  ),
                )
              ],
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _pages[0]['icon'],
            label: _pages[0]['title'],
          ),
          BottomNavigationBarItem(
            icon: _pages[1]['icon'],
            label: _pages[1]['title'],
          ),
          BottomNavigationBarItem(
            icon: _pages[2]['icon'],
            label: _pages[2]['title'],
          ),
          BottomNavigationBarItem(
            icon: _pages[3]['icon'],
            label: _pages[3]['title'],
          ),
        ],
        unselectedItemColor: Colors.black.withOpacity(0.5),
        onTap: (val) {
          setState(() {
            _activePageIndex = val;
          });
        },
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        selectedItemColor: Colors.black,
        currentIndex: _activePageIndex,
        type: BottomNavigationBarType.fixed,
//        fixedColor: Colors.white,
      ),
      body: _pages[_activePageIndex]['screen'],
    );
  }
}
