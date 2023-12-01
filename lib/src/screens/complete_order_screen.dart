import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/cart_restaurant.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/providers/cart.dart';
import 'package:Serve_ios/src/screens/changed_successfully_screen.dart';
import 'package:Serve_ios/src/screens/delivery_address_screen.dart';
import 'package:Serve_ios/src/screens/payment_screen.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:Serve_ios/src/widgets/dialogs/loading_dialog.dart';
import 'package:Serve_ios/src/widgets/items/order_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

enum PaymentType { Online, Cash }

class CompleteOrderScreen extends StatefulWidget {
  static const routeName = '/complete-order';

  @override
  _CompleteOrderScreenState createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen>
    with AlertsMixin {
  Cart _cartReference;
  int _radioVal = 0;
  Map _orderData = <String, dynamic>{
    'restaurant_id': '',
    'address_id': '',
    'payment_method': '0',
    'delivery_price': '',
    'order_price': '',
    'price_after_discount': '',
  };

  double percentage;

  bool checkingCoupon = false;

  TextEditingController _textEditingController = TextEditingController();
  getExtrasPrice(CartRestaurant e) {
    int price = 0;
    e.additions.forEach((element) {
      price += (element.price * (e.additionsCount[element.id] ?? 1));
    });
    return price;
  }

  Future<void> addCoupon([String code, int restaurantId]) async {
    setState(() {
      checkingCoupon = true;
    });
    print('aaaaaaaaaddddddddddeeeeeedd');
    print(code);
    final List<CartRestaurant> crs =
        _cartReference.getCartItemsForEachRestaurant();
    final CartRestaurant cr = crs.singleWhere(
        (element) => element.restaurant.id == restaurantId,
        orElse: () => null);
    try {
      final discount = await _cartReference.checkCoupon(
          code ?? _textEditingController.text, cr.orderPrice);
      percentage = discount;
      _orderData['coupon'] = code;
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString(), Duration(milliseconds: 1500));
    } catch (error) {
      throw error;
    } finally {
      if (this.mounted)
        setState(() {
          checkingCoupon = false;
        });
    }
  }

  bool _isLoading = false;
  Future<void> _addOrder(BuildContext context, int restaurantId) async {
    setState(() {
      _isLoading = true;
    });
    final List<CartRestaurant> crs =
        _cartReference.getCartItemsForEachRestaurant();
    final CartRestaurant cr = crs.singleWhere(
        (element) => element.restaurant.id == restaurantId,
        orElse: () => null);
    final List<CartRestaurant> crs2 =
        _cartReference.getCartItemsByRestaurantId(restaurantId);
    _orderData['details'] = detailsc.text;
    _orderData['price_after_discount'] =
        '${cr.orderPrice * (percentage != null ? (1 - (percentage / 100)) : 1)}';
    _orderData['order_price'] = '${cr.orderPrice}';
    _orderData['final_price'] = '${cr.orderPrice}';
    _orderData['restaurant_id'] = '$restaurantId';
    _orderData['payment_method'] =
        '${_paymentType == PaymentType.Cash ? 0 : 1}';
    _orderData['from_restaurant'] = '$_radioVal';
    _orderData['address_id'] =
        '${Provider.of<Addresses>(context, listen: false).selectedAddress?.id}';
    _orderData['delivery_price'] =
        '${cr.restaurant.freeDelivery == 1 && cr.orderPrice >= (cr.restaurant.deliveryLimit?.toDouble() ?? 0.0) ? 0.0 : cr.deliveryPrice}';
    _orderData['products'] = json.encode(crs2
        .map<Map<String, dynamic>>((e) => {
              'product_id': '${e.meals.first.id}',
              'price': '${e.meals.first.price}',
              'quantity': '${e.mealsCount}',
              'final_price':
                  '${(e.meals.first.price * e.mealsCount) + getExtrasPrice(e)}',
              'extras': e.additions
                  .map<Map<String, dynamic>>((e2) => {
                        'extra_id': '${e2.id}',
                        'quantity': '${e.additionsCount[e2.id] ?? 1}',
                        'price': '${e2.price}'
                      })
                  .toList(),
            })
        .toList());
    try {
      final regResponse =
          await _cartReference.addOrder(json.encode(_orderData));
      if (_paymentType == PaymentType.Online) {
        final xx = (await Navigator.of(context)
                .pushNamed(PaymentScreen.routeName, arguments: {
              ..._orderData,
              'restaurantName': cr.restaurant.title,
              'order_id': json.decode(regResponse)['order_id']
            })) ??
            false;
            // _pushToDrivers()
        if (xx) {
          await Navigator.of(context).pushNamed(
              ChangedSuccessfullyScreen.routeName,
              arguments: {'message': json.decode(regResponse)['message']});
          _cartReference.deleteCartRestaurant(restaurantId);
        }
      } else {
        await Navigator.of(context).pushNamed(
            ChangedSuccessfullyScreen.routeName,
            arguments: {'message': json.decode(regResponse)['message']});
        _cartReference.deleteCartRestaurant(restaurantId);
      }
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString(), Duration(milliseconds: 1500));
    } catch (error) {
      throw error;
    } finally {
      if (this.mounted)
        setState(() {
          
          _isLoading = false;
        });
    }
  }

  _removeCoupon() async {
    final xx = (await showConfirmDialog(
            context,
            null,
            AppLocalizations.of(context).removeCoupon,
            AppLocalizations.of(context).areYouSureYouWantToRemoveThisCoupon,
            [
              AppLocalizations.of(context).cancel,
              AppLocalizations.of(context).remove
            ],
            true)) ??
        false;
    if (!xx) return;
    setState(() {
      _orderData['coupon'] = '';
      percentage = null;
      _textEditingController.text = '';
    });
  }

  PaymentType _paymentType = PaymentType.Cash;
  TextEditingController detailsc = new TextEditingController();
  Addresses _addressesReference;
  @override
  void didChangeDependencies() {
    _cartReference = Provider.of<Cart>(context, listen: false);
    _addressesReference = Provider.of<Addresses>(context, listen: false);
    if (_addressesReference.addresses.length == 0) {
      _addressesReference.fetchAddresses();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    final int restaurantId = args['restaurantId'];
    return Scaffold(
        appBar: AppBar(
          elevation: 1.5,
          title: Text(
            AppLocalizations.of(context).completeOrder,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xDE000000),
                letterSpacing: 0.26),
          ),
        ),
        body: ModalProgressHUD(
          progressIndicator:
              LoadingDialog(AppLocalizations.of(context).pleaseWait),
          inAsyncCall: checkingCoupon,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          top: 24, left: 21, right: 21, bottom: 7),
                      color: Color(0xFFFBFBFB),
                      child: Selector<Cart, List<CartRestaurant>>(
                        selector: (_, cart) =>
                            cart.getCartItemsByRestaurantId(restaurantId),
                        builder: (_, cartItems, __) => ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartItems.length,
                          itemBuilder: (_, int i) => OrderItem(
                              name: cartItems[i].meals.first.title,
                              cartItemId: cartItems[i].cartItemId,
                              photo: cartItems[i].meals.first.photo,
                              isLast: i == cartItems.length - 1,
                              restaurantId: cartItems[i].restaurant.id,
                              mealId: cartItems[i].meals.first.id,
                              cost: '${cartItems[i].orderPrice}'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 19),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 13.5),
                          //   child: Text(
                          //     AppLocalizations.of(context).deliveryMethod,
                          //     style: TextStyle(
                          //         fontSize: 15, fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          // Row(
                          //   children: <Widget>[
                          //     // Radio(
                          //     //   activeColor: Colors.black,
                          //     //   value: 0,
                          //     //   groupValue: _radioVal,
                          //     //   onChanged: (val) {
                          //     //     setState(() {
                          //     //       _radioVal = val;
                          //     //     });
                          //     //   },
                          //     // ),
                          //     // Text(
                          //     //   AppLocalizations.of(context).delivery,
                          //     //   style: TextStyle(
                          //     //       fontWeight: FontWeight.w600,
                          //     //       fontSize: 13,
                          //     //       color: Color(0xDE000000)),
                          //     // ),
                          //     // Consumer<Cart>(
                          //     //   builder: (_, cart, __) => Text(
                          //     //     ' (+${cart.getCartItemsByRestaurantId(restaurantId)?.first?.deliveryPrice} ${AppLocalizations.of(context).sar})',
                          //     //     style: TextStyle(fontSize: 10),
                          //     //   ),
                          //     // ),
                          //     // SizedBox(
                          //     //   width: 30,
                          //     // ),
                          //
                          //
                          //   ],
                          // ),
                          if (_cartReference
                                      .getCartItemsByRestaurantId(restaurantId)
                                      ?.first
                                      ?.restaurant
                                      ?.deliveryLimit !=
                                  null &&
                              _cartReference
                                      .getCartItemsByRestaurantId(restaurantId)
                                      ?.first
                                      ?.restaurant
                                      ?.freeDelivery ==
                                  1)
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15.0, left: 15.0, bottom: 20.0),
                              child: Text(
                                '${AppLocalizations.of(context).freeDeliveryIfOrderPriceExceeds} ${_cartReference.getCartItemsByRestaurantId(restaurantId)?.first?.restaurant?.deliveryLimit}${AppLocalizations.of(context).sar}',
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                          SizedBox(
                            height: 8,
                          ),
                          Consumer<Addresses>(
                            builder: (_, addresses, __) {
                              _paymentType = addresses.paymentType;

                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(19),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 13),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(255, 57, 186, 186), width: 1.5),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .address,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    DeliveryAddressScreen
                                                        .routeName);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .change,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF1B242B)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          addresses.selectedAddress?.address ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF1C252C),
                                              letterSpacing: 0.11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(19),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 13),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(255, 57, 186, 186), width: 1.5),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Text(
                                      '${AppLocalizations.of(context).paymentMethod} (${addresses.paymentType == PaymentType.Cash ? AppLocalizations.of(context).cash : AppLocalizations.of(context).onlinePayment})',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 19),
                            child: Text(
                              AppLocalizations.of(context).orderdetails,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF1A1A1A).withOpacity(0.7),
                                  letterSpacing: -0.1),
                            ),
                          ),
                          SizedBox(
                            height: 11,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(249, 249, 249, 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: detailsc,
                                    keyboardType: TextInputType.multiline,
                                    style: TextStyle(
                                      height: 1.14285714,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .fontFamily,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          AppLocalizations.of(context).orderher,
                                      hintStyle: TextStyle(
                                        height: 1.14285714,
                                        fontFamily: Theme.of(context)
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
                            padding: const EdgeInsets.symmetric(horizontal: 19),
                            child: Text(
                              AppLocalizations.of(context).haveACoupon,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF1A1A1A).withOpacity(0.7),
                                  letterSpacing: -0.1),
                            ),
                          ),
                          SizedBox(
                            height: 11,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: MyCustomInput(
                              textEditingController: _textEditingController,
                              prefixIcon: Icon(Icons.redeem),
                              onFieldSubmitted: (val) {
                                //     addCoupon(val, restaurantId);
                              },
                              readOnly: percentage != null,
                              textInputAction: TextInputAction.go,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  print('fsdffffffffffff');
                                  if (percentage == null)
                                    addCoupon(_textEditingController.text,
                                        restaurantId);
                                  else
                                    _removeCoupon();
                                },
                                icon: percentage != null
                                    ? Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        MyCustomIcons.ok,
                                        size: 10,
                                        color: Colors.amber,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 150.0,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: Consumer<Cart>(
                  builder: (_, cart, __) {
                    final List<CartRestaurant> crs =
                        cart.getCartItemsForEachRestaurant();
                    final CartRestaurant cr = crs.singleWhere(
                        (element) => element.restaurant.id == restaurantId,
                        orElse: () => null);
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 19),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, -2),
                            blurRadius: 2),
                      ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).subTotal,
                                  style: TextStyle(
                                      fontSize: 13,
                                      letterSpacing: -0.26,
                                      color: Color(0xFF6C738A)),
                                ),
                                Spacer(),
                                Text(
                                  '${cr?.orderPrice} ${AppLocalizations.of(context).sar}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      letterSpacing: -0.26,
                                      color: Color(0xFF1A1A1A)),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).delivery,
                                  style: TextStyle(
                                      fontSize: 13,
                                      letterSpacing: -0.26,
                                      color: Color(0xFF6C738A)),
                                ),
                                Spacer(),
                                Text(
                                  '${cr.restaurant.freeDelivery == 1 && (cr.restaurant.deliveryLimit?.toDouble() ?? 0.0) < cr.orderPrice ? 0.0 : cr.deliveryPrice} ${AppLocalizations.of(context).sar}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      letterSpacing: -0.26,
                                      color: Color(0xFF1A1A1A)),
                                )
                              ],
                            ),
                          ),
                          if (percentage != null)
                            SizedBox(
                              height: 3,
                            ),
                          if (percentage != null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context).discount,
                                    style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: -0.26,
                                        color: Color(0xFF6C738A)),
                                  ),
                                  Spacer(),
                                  Text(
                                    '-$percentage% (-${((cr.orderPrice + (_radioVal == 0 ? (cr.restaurant.freeDelivery == 1 && cr.orderPrice >= cr.restaurant.deliveryLimit?.toDouble() ? 0.0 : cr.deliveryPrice) : 0.0)) * (percentage / 100))} ${AppLocalizations.of(context).sar})',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 13,
                                        letterSpacing: -0.26,
                                        color: Color(0xFF1A1A1A)),
                                  )
                                ],
                              ),
                            ),
                          Divider(
                            color: Color(0x1F000000),
                            thickness: 0.5,
                            height: 25.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: <Widget>[
                                if (cr != null)
                                  Text(
                                    '${(cr.orderPrice + (_radioVal == 0 ? (cr.restaurant.freeDelivery == 1 && cr.orderPrice >= (cr.restaurant.deliveryLimit?.toDouble() ?? 0.0) ? 0.0 : cr.deliveryPrice) : 0.0)) - ((cr.orderPrice + (_radioVal == 0 ? (cr.restaurant.freeDelivery == 1 && cr.orderPrice >= (cr.restaurant.deliveryLimit?.toDouble() ?? 0.0) ? 0.0 : cr.deliveryPrice) : 0.0)) * cr.discount) - (percentage == null ? 0.0 : ((cr.orderPrice + (_radioVal == 0 ? (cr.restaurant.freeDelivery == 1 && cr.orderPrice >= (cr.restaurant.deliveryLimit?.toDouble() ?? 0.0) ? 0.0 : cr.deliveryPrice) : 0.0)) * (percentage / 100)))} ${AppLocalizations.of(context).sar}',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Color(0xFF222627),
                                        fontWeight: FontWeight.w500),
                                  ),
                                Spacer(),
                                _isLoading
                                    ? SizedBox(
                                        height: 50.0,
                                        child: Center(
                                          child: Platform.isIOS
                                              ? CupertinoActivityIndicator()
                                              : CircularProgressIndicator(),
                                        ),
                                      )
                                    : MyCustomFormButton(
                                        buttonText: AppLocalizations.of(context)
                                            .completeOrder,
                                        onPressedEvent: () {
                                          var _restaurant = _cartReference
                                              .getCartItemsByRestaurantId(
                                                  restaurantId)
                                              ?.first
                                              ?.restaurant;
                                          print(_restaurant.maxdist);
                                          print(_restaurant.longitude);
                                          print(_restaurant.latitude);
                                          var c = Provider.of<Addresses>(
                                                  context,
                                                  listen: false)
                                              .selectedAddress;
                                          if (c == null) {
                                            showErrorDialog(
                                                context,
                                                Localizations.localeOf(context)
                                                            .languageCode ==
                                                        'ar'
                                                    ? 'يرجى تحديد عنوان التوصيل'
                                                    : 'please selecte delivery address');
                                            return;
                                          }
                                          var d = calculateDistance(
                                              double.parse(
                                                  _restaurant.latitude),
                                              double.parse(
                                                  _restaurant.longitude),
                                              double.parse(c.latitude),
                                              double.parse(c.longitude));
                                          d = d * 1000;
                                          print(d);
                                          if (d >
                                              int.parse(_restaurant.maxdist)) {
                                            showErrorDialog(
                                                context,
                                                Localizations.localeOf(context)
                                                            .languageCode ==
                                                        'ar'
                                                    ? 'عذراً, هذا المطعم يمكنه التخديم لمسافة أقصاها ' +
                                                        _restaurant.maxdist +
                                                        'متراً'
                                                    : 'Sorry, this restaurant can serve a maximum distance ' +
                                                        _restaurant.maxdist +
                                                        ' m');
                                            return;
                                          }

                                          _addOrder(context, restaurantId);
                                        },
                                      ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
