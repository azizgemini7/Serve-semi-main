import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Serve_ios/src/models/order.dart';
import 'package:Serve_ios/src/models/order_for_delegate.dart';
import 'package:Serve_ios/src/models/pagination_list.dart';
import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/providers/notifications.dart';
import 'package:Serve_ios/src/providers/orders.dart';
import 'package:Serve_ios/src/screens/chatscreen.dart';
import 'package:Serve_ios/src/widgets/ScrollingText.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:http/http.dart' as http;
import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/cart_restaurant.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/restaurant.dart';
import 'package:Serve_ios/src/models/restaurant_category.dart';
import 'package:Serve_ios/src/models/slide.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/cart.dart';
import 'package:Serve_ios/src/providers/maps.dart';
import 'package:Serve_ios/src/providers/restaurants.dart';
import 'package:Serve_ios/src/screens/cart_screen.dart';
import 'package:Serve_ios/src/screens/choose_location_screen.dart';
import 'package:Serve_ios/src/screens/delivery_address_screen.dart';
import 'package:Serve_ios/src/screens/offers_screen.dart';
import 'package:Serve_ios/src/screens/registration_screen.dart';
import 'package:Serve_ios/src/screens/restaurant_screen.dart';
import 'package:Serve_ios/src/widgets/items/restaurant_category_item.dart';
import 'package:Serve_ios/src/widgets/items/restaurant_item.dart';
import 'package:Serve_ios/src/widgets/shimmers/restaurant_category_item_shimmer.dart';
import 'package:Serve_ios/src/widgets/shimmers/restaurant_item_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'myglobals.dart' as globals;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AlertsMixin {
  CarouselController _carouselController = CarouselController();
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  int orderidClosedAt = 0;
  bool shouldRefresh = false;
  int _pagesCount = 1;
  Map params = {'restaurant_name': ''};
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Auth _authReference;
  Addresses  _addressesReference;
  Orders _ordersReference;

  static SharedPreferences prefs;

  int activeIndex = 0;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String _getParams() {
    String myParams = '';
    var _addressesReference = Provider.of<Addresses>(context, listen: false);

    params['longitude'] =
        myCurrentLocation != null ? myCurrentLocation.longitude.toString() : "";
    params['latitude'] =
        myCurrentLocation != null ? myCurrentLocation.latitude.toString() : "";
    params.forEach((key, value) {
      myParams = '$myParams&$key=$value';
    });
    return myParams;
  }

  String _getCustomParams(String lng, String lat) {
    String myParams = '';
    var _addressesReference = Provider.of<Addresses>(context, listen: false);

    params['longitude'] = lng.toString();
    params['latitude'] = lat.toString();

    params.forEach((key, value) {
      myParams = '$myParams&$key=$value';
    });
    return myParams;
  }

  bool loadloc = true;
  Future<void> _fetchRestaurants(
      [bool refresh = false,
      bool customLoc = false,
      String lng = '0.0',
      String lat = '0.0']) async {
    // Navigator.of(context)
    //                 .pushNamed(DeliveryAddressScreen.routeName);

    if (refresh) {
      _page = 1;
      _isLoading = false;
    }
    if (loadloc) {
      if (_mapsReference.chosenLocation == null) {
        // await Future.delayed(Duration(microseconds: 50), () {});
        // myCurrentLocation = (await Navigator.of(context)
        //     .pushNamed(ChooseLocationScreen.routeName)) as LocationData;
      }
    }
    loadloc = false;
    setState(() {
      _isLoading = true;
    });
    try {
      if (this.mounted) {
      var xx;

      if (customLoc) {
        xx = await _restaurantsReference.fetchRestaurants(
            _getCustomParams(lng, lat), _page);
            
      } else {
        xx = await _restaurantsReference.fetchRestaurants(_getParams(), _page);
       
      }
      // print("Resturant Count:: " + xx.toString());
        if (xx != null) {

              _pagesCount = xx;
        }
      }
    } on HttpException catch (error) {
      if (error.statusCode == 401) {
        _authReference.logoutDone();
      } else {
        showErrorDialog(context, error.toString());
      }
    } catch (error) {
      setState(() {
          _isLoading = false;
        });
      throw error;
    } finally {
      if (this.mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  TextEditingController _searchTextController = TextEditingController();
  Restaurants _restaurantsReference;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future<void> _refresh() async {
  try {
    await getSelectedLocationRes();
    // await _fetchRestaurants(true);
     _refreshController.refreshCompleted();
  
    
  } catch (e) {
    print('Error in _refresh: $e');
    // Handle the error appropriately, e.g., show an error message to the user.
  }
}


  

  String driverid = '';
  String drivertok = '';
  String usertok = '';
  String ginaldevToken = '';
  String user_phone = '';
  String driver_phone = '';

  getDeviceToken() async {
    print("Called getDeviceToken()");
    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission();
    }

    final xxx = Provider.of<Notifications>(context, listen: false);
    String localtoken;
    _firebaseMessaging.getToken().then((token) {
      print("_firebaseMessaging==token==for=orders:: " + token);
      // ginaldevToken = token;
      saveNotificationToken(token);

      xxx.updateDeviceToken(token);
      getSavedToken();
    });
  }

  saveNotificationToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    print(token.toString());
    await prefs.setString('firebase_token', token.toString()).then((value) => {
          ginaldevToken = token,
          print("ginaldevToken::" + ginaldevToken),
          print("Saved User NotificationToken:: ${token}")
        });
  }

  Future<void> _loadMore() async {
    _page++;
    _isLoading = true;
    print('LoadingData . . . ');
    // await _fetchRestaurants();
    await getSelectedLocationRes();
    if (_pagesCount != _page) {
      _isLoading = false;
    }
  }

  bool _firstCalled = false;
  LocationData myCurrentLocation;

  MapsProvider _mapsReference;

   Future<Map<String, String>> getSelectedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if (prefs.containsKey('selectedaddress')) {
      String saddress = prefs.getString('selectedaddress');
      String saddressLng = prefs.getString('selectedaddressLng');
      String saddressLat = prefs.getString('selectedaddressLat');
      
      return {
        'selectedaddress': saddress,
        'selectedaddressLng': saddressLng,
        'selectedaddressLat': saddressLat,
      };
    }
    
    return null;
  }

  Future<void> _fetchRestaurantsWithAddress() async {
    Map<String, String> selectedAddress = await getSelectedAddress();
    if (selectedAddress != null) {
      String saddress = selectedAddress['selectedaddress'];
      String saddressLng = selectedAddress['selectedaddressLng'];
      String saddressLat = selectedAddress['selectedaddressLat'];
      
       _fetchRestaurants(true,false,saddressLng,saddressLat);
    }
    
    print("Refreshed Restaurants");
  }

  @override
  void didChangeDependencies() async{
    _mapsReference = Provider.of<MapsProvider>(context, listen: false);
    _addressesReference = Provider.of<Addresses>(context, listen: false);

    getDeviceToken();

    shouldRefresh = true;
    deviceSize = MediaQuery.of(context).size;

    // await Future.delayed(Duration(milliseconds: 300), () {
    //   print("called after some sec");
    // });
    
    Future<bool> addressFuture = checkSelectedAddress();
    addressFuture.then((hasaddress){
     
      setState(() {
        if(hasaddress){
        getSelectedLocationRes();
        }else{
          _fetchRestaurantsWithAddress();
        }
    });
    });
  
    
     
    


    SharedPreferences prefs = await SharedPreferences.getInstance();
    var saddress;
    var saddressLng;
    var saddressLat;

    if (!_firstCalled) {
      
      // prefs.then((value) => {
      //       if (value.containsKey('selectedaddress'))
      //         {
      //           saddress = prefs
      //               .whenComplete(() => {value.getString('selectedaddress')}),
      //           saddressLat = prefs.whenComplete(
      //               () => {value.getString('selectedaddressLat')}),
      //           saddressLng = saddressLat = prefs.whenComplete(
      //               () => {value.getString('selectedaddressLng')}),
      //           myCurrentLocation = LocationData.fromMap(
      //               {'latitude': double.parse(saddressLat), 'longitude': double.parse(saddressLng)})
      //         }
      //     });
      if (prefs.containsKey('selectedaddress')) {
          String saddress = prefs.getString('selectedaddress');
          String saddressLat = prefs.getString('selectedaddressLat');
          String saddressLng = prefs.getString('selectedaddressLng');

          myCurrentLocation = LocationData.fromMap({
            'latitude': double.parse(saddressLat),
            'longitude': double.parse(saddressLng),
          });
      }
    }
      _fetchRestaurants(true);
      _firstCalled = true;
    
    
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  CrossFadeState _crossFadeState = CrossFadeState.showFirst;
  Location location = new Location();
  String myid = '';
  String mytoken = '';
  bool isdriver = false;
  bool isSame = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authReference = Provider.of<Auth>(context, listen: false);
    _ordersReference = Provider.of<Orders>(context, listen: false);
    _restaurantsReference = Provider.of<Restaurants>(context, listen: false);
    myid = Provider.of<Auth>(context, listen: false).userId.toString();
    globals.myid = myid;
    mytoken = Provider.of<Auth>(context, listen: false).token.toString();

   
    if (Provider.of<Auth>(context, listen: false).user != null)
      isdriver =
          Provider.of<Auth>(context, listen: false).user.isDriver ?? false;

    Timer(Duration(seconds: 10), () async {
      // print("getDeviceToken():: ${usertok}");
      location.onLocationChanged.listen((result) async {
        globals.longitude = result.longitude;
        globals.latitude = result.latitude;

        if (isdriver) {
          if (!isSame) {
            // _ordersReference.getDelegateNewOrders(true).then((value) => {
            //       if (_ordersReference?.delegateNewOrders?.data?.length != 0)
            //         {
            //           print("New order notified!"),
            //           notifyTarget(
            //               _ordersReference.delegateNewOrders, ginaldevToken),
            //           // sendPushMessage("لديك طلب جديد", "1", [ginaldevToken])
            //         }
            //     });
          }
        }

        if (isdriver && myid == globals.myid) {
          if (mounted) {
            var response23 = await http
                .post(Uri.parse('https://lazah.net/api/v1/editTrack'), body: {
              'user_id': myid,
              'longtuide': result.longitude.toString(),
              'latitude': result.latitude.toString(),
            }, headers: {
              'Authorization': 'Bearer $mytoken',
              'Accept-Language': 'ar'
            });
            print(
                'llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll');

            if (response23.body.contains("<!DOCTYPE html>") ||
                response23.body.contains("<html lang")) {
              print(
                  "onLocationChanged[||ERROR||]:: Chat malformed Server Response!");
            }

            print("OnLocationChange:: " + response23.body);
          }
        }
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100.0 &&
          !_isLoading) {
        _loadMore();
      }
    });
  }

  notifyTarget(PaginationList newOrders, String token) async {
    shouldRefresh = false;
    final ordersCount = newOrders.data.length;
    print("New Orders==Count:: ${ordersCount}");
    final noteString = "مندوبنا الغالي حولك طلب جديد";
    final customerAddress = "للعنوان التالي" + ' ';
    if (newOrders != null || newOrders.data.isNotEmpty) {
      // for (var i = ordersCount - 1; i >= 0; i--) {
      //   // if ((newOrders.data[i] as OrderForDelegate).orderStatus == 0) {
      if (orderidClosedAt == 0 ||
          orderidClosedAt != (newOrders.data[0] as OrderForDelegate).orderId &&
              orderidClosedAt != 0) {
        //(noteString +
        // '"' +
        // (newOrders.data[0] as OrderForDelegate).restaurantName +
        // '"' +
        // ' ' +
        // customerAddress +
        // ' ' +
        // (newOrders.data[0] as OrderForDelegate).deliverAddress)
        print(
            "Order Item:: ${(newOrders.data[0] as OrderForDelegate).restaurantName}");
        await sendPushMessage((noteString).toString(), "1", [token]);
        orderidClosedAt = (newOrders.data[0] as OrderForDelegate).orderId;
        print("Order Id Closed At:: ${orderidClosedAt}");
        print("Sent Successfuly ${ordersCount} Notification to the Driver!");
      }
      //   } else if ((newOrders.data[i] as OrderForDelegate).orderId !=
      //       orderidClosedAt) {
      //     print(
      //         "Order Item:: ${(newOrders.data[i] as OrderForDelegate).restaurantName}");
      //     await sendPushMessage(
      //         noteString +
      //             (newOrders.data[i] as OrderForDelegate).restaurantName +
      //             customerAddress +
      //             (newOrders.data[i] as OrderForDelegate).deliverAddress,
      //         "1",
      //         [token]);
      //     orderidClosedAt = (newOrders.data[i] as OrderForDelegate).orderId;
      //     print("Order Id Closed At:: ${orderidClosedAt}");
      //     print("Sent Successfuly ${ordersCount} Notification to the Driver!");
      //   } else {
      //     print("Already Sent That! , wont' do anything!");
      //   }
      //   // }
      // }
    }
  }
  

  getSelectedLocationRes() async {
    final prefs = await SharedPreferences.getInstance();

if(_addressesReference.selectedAddress != null){
    if (prefs.containsKey('selectedaddress') && _addressesReference.selectedAddress.address.isNotEmpty) {
      final saddress = prefs.getString('selectedaddress');
      final saddressLng = prefs.getString('selectedaddressLng');
      final saddressLat = prefs.getString('selectedaddressLat');

      _fetchRestaurants(true, true, saddressLng, saddressLat);

      print("getSelectedLocationRes ${saddress}");
      print(
          "getSelectedLocationCoords Lng :: ${saddressLng} Lat :: ${saddressLat}");
      // _orderData['s_address'] = saddress;
    }
  }
  }

  getSavedToken() async {
    print("Called:: getSavedToken()");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (!prefs.containsKey('userData'))
    ginaldevToken = prefs.getString('firebase_token');

    print("ginaldevToken:: ${ginaldevToken}");
  }

  String constructFCMPayload(String mes, String type, List<String> tokens) {
    final newOrder = '🚗 لديك طلب جديد';

    return jsonEncode({
      'registration_ids': tokens,
      'data': {
        'ismessage': '0',
        // 'orderid': orderid,
        'senderid': '0',
        'msg': mes,
        'type': type,
        'time': DateTime.now()
            .toUtc()
            .toString()
            .replaceAll("T", " ")
            .substring(0, 16),
      },
      'notification': {'title': newOrder, 'body': mes}
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

  double _transitionXValue;
  int selectedCategoryId = 0;
  Size deviceSize;

  @override
  Widget build(BuildContext context) {
    var _address = Provider.of<Addresses>(context, listen: false);
    _address.fetchAddresses().then((value) => print("done Fetching address"));
    // print("_address:: ${_address.addresses.first.address}");


    if (_address.selectedAddress == null) {
      print("called not null");
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 500,
        centerTitle: true,
        leading: PreferredSize(
          child: Container(
              height: 200.0,
              width: 200.0,
              child: Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 37, 15),
                      child: ScrollingText(
                        ratioOfBlankToScreen: 0.30,
                        text: 'التوصـيل إلى',
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold),
                        disableAnimation: true,
                      )),
                  Container(
                    width: 300.0,
                    height: 200.0,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(left: 10, top: 30, right: 15),
                    child: _address.selectedAddress == null
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(2, 2, 20, 10),
                            child: ScrollingText(
                              ratioOfBlankToScreen: 0.30,
                              text: 'أختر موقعك',
                              textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold),
                              disableAnimation: true,
                            ))
                        : ScrollingText(
                            ratioOfBlankToScreen: 0.30,
                            text: _address.selectedAddress != null
                                ? _address.selectedAddress.address.isNotEmpty
                                    ? _address.selectedAddress.address
                                    : ''
                                : '',
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w100),
                            disableAnimation: true,
                          ),
                  ),
                  IconButton(
                    onPressed: () async {
                      loadloc = true;
                      // _fetchRestaurants();
                      if (_authReference.user != null)
                        // Navigator.of(context)
                        //     .pushNamed(ChooseLocationScreen.routeName);

                        Navigator.of(context)
                            .pushNamed(DeliveryAddressScreen.routeName)
                            .then((value) => {getSelectedLocationRes()});
                      else {
                        final xx = (await showConfirmDialog(
                                context,
                                null,
                                AppLocalizations.of(context).login,
                                AppLocalizations.of(context).pleaseLoginFirst, [
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
                ],
              )),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: 14.0),
          child: Text(
            _authReference.user != null
                ? 'أهلاً بك  ${_authReference.user.username}'
                : AppLocalizations.of(context).home,
            style: TextStyle(
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_transitionXValue == 0.0) {
                _transitionXValue = deviceSize.width;
                if (params['restaurant_name'].isNotEmpty) {
                  params['restaurant_name'] = '';
                  _fetchRestaurants(true);
                }
                _crossFadeState = CrossFadeState.showFirst;
              } else {
                _transitionXValue = 0.0;
                _crossFadeState = CrossFadeState.showSecond;
              }
              setState(() {});
            },
            icon: AnimatedCrossFade(
              duration: Duration(milliseconds: 500),
              crossFadeState: _crossFadeState,
              firstChild: Image.asset('assets/images/search.png'),
              alignment: Alignment.center,
              reverseDuration: Duration(milliseconds: 500),
              secondChild: Icon(Icons.close),
            ),
          ),
          Selector<Cart, List<CartRestaurant>>(
            selector: (_, cart) => cart.getCartItemsForEachRestaurant(),
            builder: (_, cartItems, __) => badge.Badge(
              showBadge: cartItems.length > 0,
              position: badge.BadgePosition(top: 0.0, end: 0.0),
              padding: const EdgeInsets.all(6.0),
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
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SmartRefresher(
            primary: false,
            controller: _refreshController,
            onRefresh: _refresh,
            scrollController: _scrollController,
            header: WaterDropHeader(
              waterDropColor: Theme.of(context).accentColor,
              complete: Icon(Icons.check, color: Theme.of(context).accentColor),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Selector<Restaurants, List<Slide>>(
                    selector: (_, restaurants) => restaurants.offersSlider,
                    builder: (_, slides, __) => Column(
                      children: <Widget>[
                        // Stack(
                        //   alignment: Alignment.bottomCenter,
                        //   fit: StackFit.loose,
                        //   children: <Widget>[
                        //     CarouselSlider(
                        //       carouselController: _carouselController,
                        //       items: slides.length == 0 && _isLoading
                        //           ? [
                        //               Shimmer.fromColors(
                        //                 child: Container(
                        //                   color: Colors.white,
                        //                 ),
                        //                 baseColor: Colors.grey[300],
                        //                 highlightColor: Colors.grey[100],
                        //                 enabled: true,
                        //                 direction: AppLocalizations.of(context)
                        //                         .isArabic
                        //                     ? ShimmerDirection.rtl
                        //                     : ShimmerDirection.ltr,
                        //               )
                        //             ]
                        //           : slides
                        //               .map<Widget>((e) => SizedBox.expand(
                        //                     child: CachedNetworkImage(
                        //                       imageUrl: e.photo,
                        //                       fit: BoxFit.cover,
                        //                       alignment: Alignment.center,
                        //                       placeholder: (_, __) =>
                        //                           Container(),
                        //                     ),
                        //                   ))
                        //               .toList(),
                        //       options: CarouselOptions(
                        //         viewportFraction: 1.0,
                        //         aspectRatio: 360 / 170,
                        //         initialPage: 0,
                        //         enlargeCenterPage: false,
                        //         enableInfiniteScroll: false,
                        //         autoPlay: false,
                        //         scrollPhysics: ClampingScrollPhysics(),
                        //         onPageChanged: (int index, reason) {
                        //           setState(() {
                        //             activeIndex = index;
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     Positioned(
                        //       bottom: 0.0,
                        //       child: Container(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 11.0),
                        //         height: 17.0,
                        //         alignment: Alignment.center,
                        //         decoration: BoxDecoration(
                        //             color: Colors.white,
                        //             borderRadius: BorderRadius.circular(9.0)),
                        //         child: Text(
                        //           '${activeIndex + 1}/${slides.length}',
                        //           style: TextStyle(fontSize: 9.0),
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(vertical: 24),
                        //   color: Color(0xFFF8F8F8),
                        //   height: 69,
                        //   width: MediaQuery.of(context).size.width,
                        //   child: ListView.separated(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: slides?.length ?? 0,
                        //     itemBuilder: (_, i) => InkWell(
                        //       onTap: () {
                        //         Navigator.of(context).pushNamed(
                        //             OffersScreen.routeName,
                        //             arguments: {'offerId': slides[i].id});
                        //       },
                        //       child: Row(
                        //         // children: <Widget>[
                        //           // SizedBox(
                        //           //   width: 20,
                        //           // ),
                        //           // CachedNetworkImage(
                        //           //   imageUrl: slides[i]?.icon,
                        //           //   width: 22.0,
                        //           // ),
                        //           // SizedBox(
                        //           //   width: 11,
                        //           // ),
                        //           // Text(
                        //           //   slides[i]?.name ?? '',
                        //           //   style: TextStyle(
                        //           //       fontWeight: FontWeight.w600,
                        //           //       fontSize: 15,
                        //           //       letterSpacing: 1.16),
                        //           // ),
                        //           // SizedBox(
                        //           //   width: 20,
                        //           // )
                        //         // ],
                        //       ),
                        //     ),
                        //     separatorBuilder: (_, idx) {
                        //       return Container(
                        //         // height: 10,
                        //         // width: 1,
                        //         // decoration: BoxDecoration(
                        //         //     border: Border(
                        //         //         right: BorderSide(
                        //         //   color: Color(0xFF707070).withOpacity(0.2),
                        //         //   width: 1,
                        //         // ))),
                        //       );
                        //     },
                        //   ),
                        // )
                      ],
                    ),
                  ),
                 Container(
                  height: (MediaQuery.of(context).size.height - 220) / 2,
  child: Selector<Restaurants, List<RestaurantCategory>>(
    selector: (_, restaurants) => restaurants.restaurantCategories,
    builder: (_, categories, __) => GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
        childAspectRatio: 2.7, // Adjust this value to change the item aspect ratio
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: categories.length == 0 && _isLoading ? 4 : (categories.length + 1),
      itemBuilder: (_, idx) => categories.length == 0 && _isLoading
          ? RestaurantCategoryItemShimmer()
          : idx == 0
              ? RestaurantCategoryItem(
                  onTap: () {
                    setState(() {
                      selectedCategoryId = 0;
                      params['category_id'] = '';
                      
                    });
                    _refresh();
                  },
                  selected: selectedCategoryId == 0,
                  name: AppLocalizations.of(context).all,
                )
              : Container(
                  width: 50, 
                  height: 50, 
                  child: RestaurantCategoryItem(
                    onTap: () {
                      setState(() {
                        selectedCategoryId = categories[idx - 1].id;
                        params['category_id'] = '${categories[idx - 1].id}';

                         
                      });
                     _refresh();
                    },
                    selected: categories[idx - 1].id == selectedCategoryId,
                    name: categories[idx - 1].name,
                  ),
                ),
      shrinkWrap: true,
    ),
  ),
),

                  SizedBox(
                    height: 10,
                  ),
                  Selector<Restaurants, List<Restaurant>>(
                    selector: (_, restaurants) => restaurants.restaurants,
                    builder: (_, restaurants, __) => restaurants.length == 0 &&
                            !_isLoading
                        ? Center(
                            child: Text(''),
                                // child: Text(AppLocalizations.of(context)
                                // .noRestaurantsFound),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: restaurants.length == 0 && _isLoading
                                ? 5
                                : restaurants.length,
                            itemBuilder: (_, i) => restaurants.length == 0 &&
                                    _isLoading
                                ? RestaurantItemShimmer()
                                : RestaurantItem(
                                    id: restaurants[i].id,
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          RestaurantScreen.routeName,
                                          arguments: {
                                            'restaurantId': restaurants[i].id
                                          });
                                    },
                                    distance: restaurants[i].distance,
                                    isClosed: false,
                                    description: restaurants[i].description,
                                    photoUrl: restaurants[i].logo,
                                    rating: restaurants[i]
                                        .restaurantRate
                                        ?.toDouble(),
                                    name: restaurants[i].title.isEmpty ? "\n \n" : restaurants[i].title,
                                    price: restaurants[i].deliveryPrice,
                                    deliveryTime: restaurants[i].deliveryTime,
                                  ),
                            separatorBuilder: (_, i) => SizedBox(
                              height: 10,
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: AnimatedContainer(
              curve: Curves.easeOutCirc,
              height: 70.0,
              transform: Matrix4.translationValues(
                  _transitionXValue ?? deviceSize.width, 0.0, 0.0),
              duration: Duration(milliseconds: 400),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color(0x29000000),
                    offset: Offset(0.0, 3.0),
                    blurRadius: 6.0)
              ], color: Colors.white),
              child: TextField(
                controller: _searchTextController,
                maxLines: 1,
                style: TextStyle(
                  height: 1.33,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (String val) {
                  params['restaurant_name'] = val;
                  _fetchRestaurants(true);
                },
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context).searchByRestaurantName,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(
                      color: Color(0xFFDFDFE4),
                      fontSize: 15.0,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 25.0),
                    suffixIcon: TextButton(
                      // shape: CircleBorder(),
                      child: Image.asset('assets/images/search.png'),
                      onPressed: () {
                        params['restaurant_name'] = _searchTextController.text;
                        _fetchRestaurants(true);
                      },
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

      Future<bool> doesSelectedAddressExist() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('selectedaddress');
    }


    Future<bool> checkSelectedAddress() async {
      return await doesSelectedAddressExist();
    }
}
