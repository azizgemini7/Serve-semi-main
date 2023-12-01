import 'dart:async';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/cart_restaurant.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/restaurant.dart';
import 'package:Serve_ios/src/models/slide.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/cart.dart';
import 'package:Serve_ios/src/providers/maps.dart';
import 'package:Serve_ios/src/providers/restaurants.dart';
import 'package:Serve_ios/src/screens/registration_screen.dart';
import 'package:Serve_ios/src/screens/restaurant_screen.dart';
import 'package:Serve_ios/src/widgets/items/restaurant_category_item.dart';
import 'package:Serve_ios/src/widgets/items/restaurant_item.dart';
import 'package:Serve_ios/src/widgets/shimmers/restaurant_category_item_shimmer.dart';
import 'package:Serve_ios/src/widgets/shimmers/restaurant_item_shimmer.dart';
import 'package:badges/badges.dart' as badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'cart_screen.dart';
import 'choose_location_screen.dart';
import 'delivery_address_screen.dart';

class OffersScreen extends StatefulWidget {
  static const routeName = '/offers';

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> with AlertsMixin {
  CarouselController _carouselController = CarouselController();
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  int _pagesCount = 1;
  Map params = {'restaurant_name': ''};

  Auth _authReference;

  int activeIndex = 0;
  String _getParams(String lng, String lat) {
    String myParams = '';
    params['longitude'] =
        myCurrentLocation?.longitude?.toString() ?? lng.toString();
    params['latitude'] =
        myCurrentLocation?.latitude?.toString() ?? lat.toString();
    params.forEach((key, value) {
      myParams = '$myParams&$key=$value';
      print("_getParams:: " + myParams);
    });
    return myParams;
  }

  getSelectedLocationRes() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('selectedaddress')) {
      final saddress = prefs.getString('selectedaddress');
      final saddressLng = prefs.getString('selectedaddressLng');
      final saddressLat = prefs.getString('selectedaddressLat');

      _fetchOffers(true, saddressLng, saddressLat);

      print("getSelectedLocationRes ${saddress}");
      print(
          "getSelectedLocationCoords Lng :: ${saddressLng} Lat :: ${saddressLat}");
      // _orderData['s_address'] = saddress;
    }
  }

  LocationData myCurrentLocation;
  StreamSubscription _locationSubscription;
  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  MapsProvider _mapsReference;
  Future<void> _fetchOffers(
      [bool refresh = false, String lng = '0.0', String lat = '0.0']) async {
    if (refresh) {
      _page = 1;
      _isLoading = false;
    }
    setState(() {
      _isLoading = true;
    });
    if (_mapsReference.chosenLocation == null) {
      // await Future.delayed(Duration(microseconds: 50), () {});
      // myCurrentLocation = (await Navigator.of(context)
      //     .pushNamed(ChooseLocationScreen.routeName)) as LocationData;
    }
    try {
      final xx =
          await _restaurantsReference.fetchOffers(_getParams(lng, lat), _page);
      _pagesCount = xx;
    } on HttpException catch (error) {
      if (error.statusCode == 401) {
        _authReference.logoutDone();
      } else {
        showErrorDialog(context, error.toString());
      }
    } catch (error) {
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
    await   getSelectedLocationRes();
    await _fetchOffers(true);
    _refreshController.refreshCompleted();
  }

  Future<void> _loadMore() async {
    _page++;
    _isLoading = true;
    await _fetchOffers();
    if (_pagesCount != _page) {
      _isLoading = false;
    }
  }

  int _selectedOfferId;
  bool _firstCalled = false;
  @override
  void didChangeDependencies() {
    _mapsReference = Provider.of<MapsProvider>(context, listen: false);
    deviceSize = MediaQuery.of(context).size;
    if (!_firstCalled) {
      final args = (ModalRoute.of(context).settings.arguments as Map) ?? {};
      if (args['offerId'] != null) {
        selectedCategoryId = args['offerId'];
        params['category_id'] = '${args['offerId']}';
      }

      getSelectedLocationRes();

      final prefs = SharedPreferences.getInstance();
      var saddress;
      var saddressLng;
      var saddressLat;

      prefs.then((value) => {
            if (value.containsKey('selectedaddress'))
              {
                saddress = prefs
                    .whenComplete(() => {value.getString('selectedaddress')}),
                saddressLat = prefs.whenComplete(
                    () => {saddressLat = value.getString('selectedaddressLat')}),
                saddressLng =  prefs.whenComplete(
                    () => {saddressLng = value.getString('selectedaddressLng')}),
                myCurrentLocation = LocationData.fromMap(
                    {'latitude': saddressLat, 'longitude': saddressLng})
              }
          });

      _fetchOffers(true);
      _firstCalled = true;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authReference = Provider.of<Auth>(context, listen: false);
    _restaurantsReference = Provider.of<Restaurants>(context, listen: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100.0 &&
          !_isLoading) {
        _loadMore();
      }
    });
  }

  double _transitionXValue;
  int selectedCategoryId = 0;
  Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // IconButton(
            //   onPressed: () async {
            // if (_authReference.user != null)
            //   Navigator.of(context)
            //       .pushNamed(DeliveryAddressScreen.routeName);
            // else {
            //   final xx = (await showConfirmDialog(
            //           context,
            //           null,
            //           AppLocalizations.of(context).login,
            //           AppLocalizations.of(context).pleaseLoginFirst, [
            //         AppLocalizations.of(context).cancel,
            //         AppLocalizations.of(context).login
            //       ]) ??
            //       false);
            //   if (xx)
            //     Navigator.of(context)
            //         .pushNamed(RegistrationScreen.routeName);
            // }
            // },
            //   icon: Image.asset('assets/images/Location.png'),
            // ),
            // SizedBox(
            //   height: 30.0,
            //   child: Container(
            //     width: 1.5,
            //     color: Colors.black,
            //   ),
            // ),
            const SizedBox(
              width: 10.0,
            ),
            Text(AppLocalizations.of(context).offers),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_transitionXValue == 0.0) {
                _transitionXValue = deviceSize.width;
                if (params['restaurant_name'].isNotEmpty) {
                  params['restaurant_name'] = '';
                  _fetchOffers(true);
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
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            children: <Widget>[
              Selector<Restaurants, List<Slide>>(
                selector: (_, restaurants) => restaurants.offersSlider2,
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
                    //                 direction:
                    //                     AppLocalizations.of(context).isArabic
                    //                         ? ShimmerDirection.rtl
                    //                         : ShimmerDirection.ltr,
                    //               )
                    //             ]
                    //           : slides
                    //               .map<Widget>((e) => SizedBox.expand(
                    //                     child: CachedNetworkImage(
                    //                       imageUrl: e.photo,
                    //                       fit: BoxFit.cover,
                    //                       alignment: Alignment.center,
                    //                       placeholder: (_, __) => Container(),
                    //                     ),
                    //                   ))
                    //               .toList(),
                    //       options: CarouselOptions(
                    //         viewportFraction: 1.0,
                    //         aspectRatio: 360 / 170,
                    //         initialPage: 0,
                    //         enlargeCenterPage: false,
                    //         enableInfiniteScroll: true,
                    //         autoPlay: true,
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
                    //         padding:
                    //             const EdgeInsets.symmetric(horizontal: 11.0),
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
//                    Container(
//                      padding: const EdgeInsets.symmetric(vertical: 24),
//                      color: Color(0xFFF8F8F8),
//                      height: 69,
//                      width: MediaQuery.of(context).size.width,
//                      child: ListView.separated(
//                        scrollDirection: Axis.horizontal,
//                        itemCount: slides?.length ?? 0,
//                        itemBuilder: (_, i) => InkWell(
//                          onTap: () {
//                          },
//                          child: Row(
//                            children: <Widget>[
//                              SizedBox(
//                                width: 20,
//                              ),
//                              CachedNetworkImage(
//                                imageUrl: slides[i]?.icon,
//                                width: 22.0,
//                              ),
//                              SizedBox(
//                                width: 11,
//                              ),
//                              Text(
//                                slides[i]?.name ?? '',
//                                style: TextStyle(
//                                    fontWeight: FontWeight.w600,
//                                    fontSize: 15,
//                                    letterSpacing: 1.16),
//                              ),
//                              SizedBox(
//                                width: 20,
//                              )
//                            ],
//                          ),
//                        ),
//                        separatorBuilder: (_, idx) {
//                          return Container(
//                            height: 10,
//                            width: 1,
//                            decoration: BoxDecoration(
//                                border: Border(
//                                    right: BorderSide(
//                              color: Color(0xFF707070).withOpacity(0.2),
//                              width: 1,
//                            ))),
//                          );
//                        },
//                      ),
//                    )
                  ],
                ),
              ),
              Container(
             
                height: (MediaQuery.of(context).size.height - 500) / 2,
                child: Selector<Restaurants, List<Slide>>(
                  selector: (_, restaurants) => restaurants.offersSlider2,
                  builder: (_, categories, __) => GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 9,
        mainAxisSpacing: 5,
        childAspectRatio: 2.7, // Adjust this value to change the item aspect ratio
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
                    itemCount: categories.length == 0 && _isLoading
                        ? 4
                        : (categories.length + 1),
                    itemBuilder: (_, idx) =>
                        categories.length == 0 && _isLoading
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
                                        selectedCategoryId =
                                            categories[idx - 1].id;
                                        params['category_id'] =
                                            '${categories[idx - 1].id}';
                                      });
                                      _refresh();
                                    },
                                    selected: categories[idx - 1].id ==
                                        selectedCategoryId,
                                    name: categories[idx - 1].name,
                                  ),
                    // separatorBuilder: (_, i) => SizedBox(
                    //   width: 10,
                    // ),
                    
                  ),
                  shrinkWrap: true,
                  ),
                ),
              ),
              Expanded(
                child: Selector<Restaurants, List<Restaurant>>(
                  selector: (_, restaurants) => restaurants.offersRestaurants,
                  builder: (_, restaurants, __) => restaurants.length == 0 &&
                          !_isLoading
                      ? Center(
                          child: Text(""),
                              // child: Text(
                              // AppLocalizations.of(context).noRestaurantsFound),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: restaurants.length == 0 && _isLoading
                              ? 5
                              : restaurants.length,
                          itemBuilder: (_, i) =>
                              restaurants.length == 0 && _isLoading
                                  ? RestaurantItemShimmer()
                                  : RestaurantItem(
                                      id: restaurants[i].id,
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            RestaurantScreen.routeName,
                                            arguments: {
                                              'restaurantId': restaurants[i].id
                                            }).then((value) => {
                                              print("restaurantId:: " +
                                                  restaurants[i].id.toString())
                                            });
                                      },
                                      // distance: restaurants[i].distance,
                                      deliveryTime: restaurants[i].deliveryTime,
                                      isClosed: false,
                                      description: restaurants[i].description,
                                      photoUrl: restaurants[i].logo,
                                      rating: restaurants[i]
                                          .restaurantRate
                                          ?.toDouble(),
                                      name: restaurants[i].title,
                                      price: restaurants[i].deliveryPrice,
                                    ),
                          separatorBuilder: (_, i) => SizedBox(
                            height: 10,
                          ),
                        ),
                ),
              )
            ],
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
                  _fetchOffers(true);
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
                        _fetchOffers(true);
                      },
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
