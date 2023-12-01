import 'dart:convert';
import 'dart:math';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/cart_restaurant.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/meal.dart';
import 'package:Serve_ios/src/models/restaurant.dart';
import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/cart.dart';
import 'package:Serve_ios/src/providers/restaurants.dart';
import 'package:Serve_ios/src/screens/changed_successfully_screen.dart';
import 'package:Serve_ios/src/screens/delegate_login_screen.dart';
import 'package:Serve_ios/src/screens/delivery_address_screen.dart';
import 'package:Serve_ios/src/screens/meal_screen.dart';
import 'package:Serve_ios/src/screens/my_requests_screen.dart';
import 'package:Serve_ios/src/screens/new_screen.dart';
import 'package:Serve_ios/src/screens/payment_screen.dart';
import 'package:Serve_ios/src/screens/registration_screen.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:Serve_ios/src/widgets/items/restaurant_bar_item.dart';
import 'package:Serve_ios/src/widgets/items/restaurant_meal_item.dart';
import 'package:Serve_ios/src/widgets/items/restaurant_product_category.dart';
import 'package:Serve_ios/src/widgets/shimmers/restaurant_item_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'complete_order_screen.dart';

class RestaurantScreen extends StatefulWidget {
  static const routeName = '/restaurant';

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> with AlertsMixin {
  CarouselController _carouselController = CarouselController();
  int _activeIndex = 0;
  int _selectedCategory;
  Restaurants _restaurantsReference;
  int restaurantId;
  String backeddata;

  bool _isLoading = false;
  Auth _authReference;
  bool _gotRestaurantDetails = false;

  Future<void> _getRestaurantDetails() async {
    setState(() {
      _isLoading = true;
    });

    print("Called:: RestaurantScreen");
    try {
      final xx = await _restaurantsReference
          .getRestaurantDetails(restaurantId)
          .catchError((error) {
        // print("Error:: " + error);
      });
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

  Restaurant _restaurant;

  Cart _cartReference;
  PaymentType _paymentType = PaymentType.Cash;
  Addresses _addressesReference;
  bool freeDeliveryHidden = false;
  @override
  void didChangeDependencies() {
    _addressesReference = Provider.of<Addresses>(context, listen: false);
    if (_addressesReference.addresses.length == 0) {
      _addressesReference.fetchAddresses();
    }
    _restaurantsReference = Provider.of<Restaurants>(context);
    _cartReference = Provider.of<Cart>(context, listen: false);
    _authReference = Provider.of<Auth>(context, listen: false);
    final args = ModalRoute.of(context).settings.arguments as Map;
    final Map args2 = ModalRoute.of(context).settings.arguments ?? {};

    if (args != null) {
      restaurantId = args['restaurantId'];
      // if (backeddata == null) {
      //   _addressesReference
      //       .fetchAddresses()
      //       .then((value) => {print('refreshed after delete!')});
      //   backeddata = "no data";
      // } else {
      //   backeddata = args['moh'];
      // }
      if (!_gotRestaurantDetails) {
        _getRestaurantDetails();
        _gotRestaurantDetails = true;
      }
    }
    super.didChangeDependencies();
  }

  bool loadrat = false;
  List<ratitem> myrates = [];
  bool first = true;

  void getmyrates(String id, StateSetter setState2) async {
    if (!first) return;
    first = false;

    var response23 = await http
        .get(Uri.parse('https://lazah.net/api/v1/reviews/$id'), headers: {
      'Authorization':
          'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
      'Accept-Language': 'ar'
    });
    if (response23.statusCode == 200) {
      var x = jsonDecode(response23.body);
      for (int i = 0; i < x.length; i++) myrates.add(new ratitem(x[i]));
    }
    setState2(() {
      loadrat = false;
    });
    print(response23.body);
  }

  @override
  Widget build(BuildContext context) {
    _restaurant = _restaurantsReference.offersRestaurants.singleWhere(
        (element) => element.id == restaurantId,
        orElse: () => null);

    if (_restaurant == null) {
      _restaurant = _restaurantsReference.restaurants.singleWhere(
          (element) => element.id == restaurantId,
          orElse: () => null);
    }
    // print("Returned some data:: " + backeddata);
    if (_selectedCategory == null &&
        (_restaurant?.products?.length ?? 0) != 0) {
      _selectedCategory = _restaurant?.products?.first?.id;
    }
    final product = _restaurant?.products?.singleWhere(
        (element) => element.id == _selectedCategory,
        orElse: () => null);
    final List<Meal> meals = product?.meals ?? [];
    // if (_restaurant == null)
    //   // Navigator.of(context).pushNamed(RegistrationScreen.routeName);

    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (_) => RegistrationScreen()));
    //   });

    // print("_restaurant:: " + _restaurant.toJson().toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(_restaurant?.title ?? ''),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) => Column(
          children: <Widget>[
            child,
            if (cart.cartItems.length != 0)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 18.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color(0x0D000000),
                      offset: Offset(0, -2.0),
                      blurRadius: 2.0),
                ], color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset('assets/images/cart_2.png'),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          AppLocalizations.of(context).yourCart,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        )
                      ],
                    ),
                    MyCustomFormButton(
                      onPressedEvent: () {
                        Navigator.of(context)
                            .pushNamed(CompleteOrderScreen.routeName,
                                // (route) => route.settings.name == '/main',
                                arguments: {'restaurantId': restaurantId});
                      },
                      buttonText:
                          '${cart.getTotalPrice()} ${AppLocalizations.of(context).sar}',
                    )
                  ],
                ),
              )
          ],
        ),
        child: Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              if (_restaurant?.cover != null || _isLoading)
                SliverAppBar(
                  expandedHeight: 180.0,
                  stretch: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: CarouselSlider(
                    carouselController: _carouselController,
                    items: [
                      if (_isLoading && _restaurant?.cover == null)
                        Shimmer.fromColors(
                          child: Container(
                            color: Colors.white,
                          ),
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          direction: AppLocalizations.of(context).isArabic
                              ? ShimmerDirection.rtl
                              : ShimmerDirection.ltr,
                        )
                      else
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            fit: BoxFit.fitWidth,
                            imageUrl: _restaurant?.cover,
                            placeholder: (_, __) => Container(),
                          ),
                        )
                    ],
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      height: 180.0,
                      initialPage: 0,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                      scrollPhysics: ClampingScrollPhysics(),
                      onPageChanged: (int index, reason) {
                        setState(() {
                          _activeIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              SliverAppBar(
                expandedHeight: 140.0,
                stretch: true,
                elevation: 2.0,
                pinned: true,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                    child: Container(), preferredSize: Size.fromHeight(80.0)),
                flexibleSpace: InkWell(
                  onTap: () {
                    loadrat = true;
                    myrates = [];
                    first = true;
                    showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            getmyrates(_restaurant?.id.toString(), setState);
                            return Container(
                              height: 350.0,
                              color: Colors
                                  .transparent, //could change this to Color(0xFF737373),
                              //so you don't have to change MaterialApp canvasColor
                              child: new Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          topRight:
                                              const Radius.circular(10.0))),
                                  child: new Center(
                                    child: loadrat
                                        ? Center(
                                            child: ListView(
                                              children: List.generate(
                                                5,
                                                (index) => Shimmer.fromColors(
                                                  baseColor: Colors.grey[200],
                                                  highlightColor: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                RatingBar
                                                                    .builder(
                                                                  initialRating:
                                                                      5.0,
                                                                  minRating: 1,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  ignoreGestures:
                                                                      true,
                                                                  itemCount: 5,
                                                                  itemSize: 15,
                                                                  itemPadding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4.0),
                                                                  itemBuilder:
                                                                      (context,
                                                                              _) =>
                                                                          Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  onRatingUpdate:
                                                                      (rating) {},
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              '',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : myrates.length == 0
                                            ? Center(
                                                child: Text('لاتوجد تقييمات'),
                                              )
                                            : ListView(
                                                children: List.generate(
                                                  myrates.length,
                                                  (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: 35,
                                                                  height: 35,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      image: DecorationImage(
                                                                          image: AssetImage(double.parse(myrates[index].stars) < 3
                                                                              ? 'assets/images/unhappy.png'
                                                                              : double.parse(myrates[index].stars) == 3
                                                                                  ? 'assets/images/smile.png'
                                                                                  : 'assets/images/happy.png'),
                                                                          fit: BoxFit.fill)),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  myrates[index]
                                                                      .name,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                RatingBar
                                                                    .builder(
                                                                  initialRating:
                                                                      double.parse(
                                                                          myrates[index]
                                                                              .stars),
                                                                  minRating: 1,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  ignoreGestures:
                                                                      true,
                                                                  itemCount: 5,
                                                                  itemSize: 15,
                                                                  itemPadding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4.0),
                                                                  itemBuilder:
                                                                      (context,
                                                                              _) =>
                                                                          Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  onRatingUpdate:
                                                                      (rating) {},
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              myrates[index]
                                                                  .text,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                  )),
                            );
                          });
                        });
                  },
                  child: RestaurantBarItem(
                    name: _restaurant?.title ?? '',
                    id: restaurantId,
                    logo: _restaurant != null
                        ? _restaurant?.logo
                        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkWMEOtws_bN70VS9t0OMtXD8J57urooLUHw&usqp=CAU',
                    rate:
                        _restaurant != null ? _restaurant.restaurantRate : 0.0,
                    restaurantCategory: _restaurant != null
                        ? _restaurant.description
                        : 'No description',
                    distance: _restaurant != null ? _restaurant?.distance : 0.0,
                    price: _restaurant != null ? _restaurant?.deliveryPrice : 0,
                    delivery_time:
                        _restaurant != null ? _restaurant.deliveryTime : 0,
                    context: context,
                  ),
                ),
              ),
              if (_restaurant?.freeDelivery == 1)
                SliverList(
                  delegate: SliverChildListDelegate([
                    AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      padding: EdgeInsets.symmetric(
                          horizontal: freeDeliveryHidden ? 0.0 : 15.0,
                          vertical: freeDeliveryHidden ? 0.0 : 10.0),
                      foregroundDecoration: BoxDecoration(
                          color: !freeDeliveryHidden
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.7)),
                      constraints: BoxConstraints(
                          maxHeight:
                              freeDeliveryHidden ? 0.0 : double.infinity),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 22.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF8F8F8),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset('assets/images/gift.png'),
                                  const SizedBox(
                                    width: 14.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations.of(context)
                                              .freeDelivery,
                                          style: TextStyle(
                                              color: Color(0xFF0083E7),
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${AppLocalizations.of(context).onRequestOf} ${_restaurant.deliveryLimit} ${AppLocalizations.of(context).sar} ${AppLocalizations.of(context).orMore}',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xFF6A6A6A),
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 2.0,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                freeDeliveryHidden = true;
                              });
                            },
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 34.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF8F8F8),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context).close,
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              SliverAppBar(
                expandedHeight: 50.0,
                stretch: true,
                pinned: true,
                elevation: 1,
                forceElevated: true,
                automaticallyImplyLeading: false,
                flexibleSpace: ListView.builder(
                  itemBuilder: (ctx, int i) => RestaurantProductCategory(
                    onTap: () {
                      setState(() {
                        _selectedCategory = _restaurant.products[i].id;
                      });
                    },
                    selected: _restaurant.products[i].id == _selectedCategory,
                    title: _restaurant.products[i].name,
                  ),
                  itemCount: _restaurant?.products?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                    vertical: meals.length == 0 ? 0 : 20.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, int i) => meals.length == 0
                        ? _isLoading
                            ? RestaurantItemShimmer()
                            : !_authReference.isAuth
                                ? Container()
                                : Container(
                                    padding: EdgeInsets.all(5),
                                    color: Colors.grey[200],
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 19),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .orderdetails,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1A1A1A)
                                                    .withOpacity(0.7),
                                                letterSpacing: -0.1),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 11,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 13),
                                            child: Container(
                                              width: double.infinity,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      249, 249, 249, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller: detailsc,
                                                  maxLines: null,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                    height: 1.14285714,
                                                    fontFamily:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .subtitle1
                                                            .fontFamily,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)
                                                            .orderher,
                                                    hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.14285714,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .subtitle1
                                                              .fontFamily,
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 19),
                                          child: Text(
                                            'التوصيل إلى',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1A1A1A)
                                                    .withOpacity(0.7),
                                                letterSpacing: -0.1),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Consumer<Addresses>(
                                          builder: (_, addresses, __) {
                                            _paymentType =
                                                addresses.paymentType;

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(19),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 13),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(Icons
                                                              .location_city),
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .address,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Spacer(),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                      DeliveryAddressScreen
                                                                          .routeName);
                                                            },
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .change,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Color(
                                                                      0xFF1B242B)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: 14,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text(
                                                        //added address
                                                        addresses
                                                                .selectedAddress.address.isNotEmpty ? addresses.selectedAddress.address :
                                                               
                                                            '',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    144,
                                                                    255,
                                                                    0,
                                                                    179),
                                                            letterSpacing:
                                                                0.11),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 19),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .paymentMethod,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(0xFF1A1A1A)
                                                            .withOpacity(0.7),
                                                        letterSpacing: -0.1),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.all(19),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 13),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.payment),
                                                      Text(
                                                        '  (${addresses.paymentType == PaymentType.Cash ? AppLocalizations.of(context).cash : AppLocalizations.of(context).onlinePayment})',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _isLoading22
                                            ? Align(
                                                alignment: Alignment.topCenter,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ))
                                            : Align(
                                                alignment: Alignment.topCenter,
                                                child: MyCustomFormButton(
                                                  buttonText:
                                                      AppLocalizations.of(
                                                              context)
                                                          .completeOrder,
                                                  onPressedEvent: () {
                                                    var c =
                                                        Provider.of<Addresses>(
                                                                context,
                                                                listen: false)
                                                            .selectedAddress;
                                                    if (c == null) {
                                                      showErrorDialog(
                                                          context,
                                                          Localizations.localeOf(
                                                                          context)
                                                                      .languageCode ==
                                                                  'ar'
                                                              ? 'يرجى تحديد عنوان التوصيل'
                                                              : 'please selecte delivery address');
                                                      return;
                                                    }
                                                    // var d = calculateDistance(
                                                    //     double.parse(_restaurant
                                                    //         .latitude),
                                                    //     double.parse(_restaurant
                                                    //         .longitude),
                                                    //     double.parse(
                                                    //         c.latitude),
                                                    //     double.parse(
                                                    //         c.longitude));
                                                    // d = d * 1000;
                                                    // print(
                                                    //     "_restaurant.latitude:: " +
                                                    //         _restaurant
                                                    //             .latitude);
                                                    // print(
                                                    //     _restaurant.longitude);
                                                    // print("destiniation:: " +
                                                    //     d.toString());
                                                    // if (d >
                                                    //     int.parse(_restaurant
                                                    //         .maxdist)) {
                                                    //   showErrorDialog(
                                                    //       context,
                                                    //       Localizations.localeOf(
                                                    //                       context)
                                                    //                   .languageCode ==
                                                    //               'ar'
                                                    //           ? 'عذراً, هذا المطعم يمكنه التخديم لمسافة أقصاها ' +
                                                    //               _restaurant
                                                    //                   .maxdist +
                                                    //               'متراً'
                                                    //           : 'Sorry, this restaurant can serve a maximum distance ' +
                                                    //               _restaurant
                                                    //                   .maxdist +
                                                    //               ' m');
                                                    //   return;
                                                    // }

                                                    if (detailsc.text
                                                        .trim()
                                                        .isEmpty) return;
                                                    _addOrder(
                                                        context,
                                                        restaurantId,
                                                        _restaurant
                                                            .deliveryPrice
                                                            .toString());
                                                  },
                                                ),
                                              ),
                                      ],
                                    ),
                                  )
                        : RestaurantMealItem(
                            id: meals[i].id,
                            price: meals[i].price?.toString(),
                            title: meals[i].title,
                            photo: meals[i].photo,
                            description: meals[i].description,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(MealScreen.routeName, arguments: {
                                'mealId': meals[i].id,
                                'restaurantId': restaurantId,
                                'productId': product?.id
                              });
                            },
                            isForOrder: false,
                          ),
                    childCount:
                        meals.length == 0 ? (_isLoading ? 5 : 1) : meals.length,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Map _orderData = <String, dynamic>{
    'restaurant_id': '',
    'address_id': '',
    'payment_method': '0',
    'delivery_price': '',
    'order_price': '',
    'price_after_discount': '',
  };
  bool _isLoading22 = false;
  Future<void> _addOrder(
      BuildContext context, int restaurantId, String deliveryPrice) async {
    setState(() {
      _isLoading22 = true;
    });
    _orderData['details'] = detailsc.text;
    _orderData['restaurant_id'] = '$restaurantId';
    // print('address chosen ${Provider.of<Addresses>(context, listen: false).selectedAddress?.id}');
    _orderData['address_id'] =
        '${Provider.of<Addresses>(context, listen: false).selectedAddress?.id}';

    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('selectedaddress')) {
      final saddress = prefs.getString('selectedaddress');
      print("saddress ${saddress}");
      _orderData['s_address'] = saddress;
    }
    _orderData['payment_method'] =
        '${_paymentType == PaymentType.Cash ? 0 : 1}';
    _orderData['delivery_price'] = deliveryPrice;
    _orderData['order_price'] = '0';
    _orderData['price_after_discount'] = '0';
    _orderData['order_price'] = '0';
    _orderData['final_price'] = '0';
    try {
      final regResponse =
          await _cartReference.addOrder(json.encode(_orderData));
      {
        print('server responded with:: ${json.decode(regResponse)}');
        // await Navigator.of(context).pushNamed(
        //     ChangedSuccessfullyScreen.routeName,
        //     arguments: {'message': json.decode(regResponse)['message']});
        await Navigator.of(context).pushNamed(MyRequestsScreen.routeName, arguments: {'isFromNotifications': true});
        _cartReference.deleteCartRestaurant(restaurantId);
      }
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString(), Duration(milliseconds: 1500));
    } catch (error) {
      throw error;
    } finally {
      if (this.mounted)
        setState(() {
          _isLoading22 = false;
        });
    }
  }

  TextEditingController detailsc = new TextEditingController();
}

class ratitem {
  String stars;
  String text;
  String name;
  ratitem(dynamic x) {
    stars = x['stars'].toString();
    text = x['txt'] ?? '';
    name = x['name'] ?? '';
  }
}
