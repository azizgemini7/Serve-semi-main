import 'dart:convert';

import 'package:Serve_ios/src/models/cart_restaurant.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class Cart with ChangeNotifier {
  List<CartRestaurant> _cartItems = [];
  final User user;
  List<CartRestaurant> get cartItems => _cartItems;
  String _appLanguage;
  Future<void> deleteCartRestaurant(int restaurantId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartItems.removeWhere((element) => element.restaurant.id == restaurantId);
    await prefs.setStringList('cartItems',
        _cartItems.map<String>((e) => json.encode(e.toJson())).toList());
    notifyListeners();
  }

  List<CartRestaurant> getCartItemsByRestaurantId(int restaurantId) {
    final List<CartRestaurant> myCartItems = _cartItems
            .where((element) => element.restaurant.id == restaurantId)
            ?.toList() ??
        [];
    return myCartItems;
  }

  removeMeal(String cartItemId) async {
    _cartItems.removeWhere((element) => element.cartItemId == cartItemId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('cartItems',
        _cartItems.map<String>((e) => json.encode(e.toJson())).toList());
    notifyListeners();
  }

  List<CartRestaurant> getCartItemsForEachRestaurant() {
    List<CartRestaurant> cr = [];
    _cartItems.forEach((element) {
      final int xx = cr.indexWhere(
          (element1) => element1.restaurant.id == element.restaurant.id);
      if (xx != -1) {
        cr[xx].meals.add(element.meals.first);
        cr[xx].mealsCount += element.mealsCount;
        cr[xx].orderPrice += element.orderPrice;
        cr[xx].additions.addAll(element.additions);
        cr[xx].additionsCount.addAll(element.additionsCount);
      } else {
        cr.add(CartRestaurant.fromJson(element.toJson()));
      }
    });
    return cr;
  }

  double getTotalPrice() {
    double xx = 0.0;
    _cartItems.forEach((element) {
      xx += element.orderPrice;
    });
    return xx;
  }

  Future<String> addOrder(String orderData) async {
    final decodedOrderData = json.decode(orderData);
    print('fdddddddddddddddddddddddd');
    print(decodedOrderData);
    try {
      print('0');
      final response = await http.post(Uri.parse('$uri/api/v1/add-order'),
          body: decodedOrderData,
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': 'en'
          });
      print(response.body);
      print(jsonDecode(response.body));
      print('1');
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      return response.body;
    } catch (error) {
      throw error;
    }
  }

  Future<double> checkCoupon(String coupon, double finalPrice) async {
    try {
      final response =
          await http.post(Uri.parse('$uri/api/v1/check-coupon'), body: {
        'code': coupon,
        'final_price': '$finalPrice',
      }, headers: {
        'Authorization': 'Bearer ${user?.token}',
        'Accept-Language': _appLanguage
      });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      return parsedResponse['percent'] is int
          ? parsedResponse['percent'].toDouble()
          : parsedResponse['percent'];
    } catch (error) {
      throw error;
    }
  }

  Cart(this.user, this._appLanguage) {
    _getCartItems();
  }
  Future<void> _getCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('cartItems')) {
      final myCartItems = prefs.getStringList('cartItems');
      _cartItems = myCartItems
          ?.map((item) => CartRestaurant.fromJson(json.decode(item)))
          ?.toList();
    }
    notifyListeners();
  }

  Future<void> addToCart(CartRestaurant cartRestaurant) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<CartRestaurant> cartItems1 = [];
    if (prefs.containsKey('cartItems')) {
      final myCartItems = (prefs.getStringList('cartItems') ?? []);
      myCartItems.forEach((item) {
        cartItems1.add(CartRestaurant.fromJson(json.decode(item)));
      });
    }
    cartItems1.add(cartRestaurant);
    await prefs.setStringList('cartItems',
        cartItems1.map<String>((e) => json.encode(e.toJson())).toList());
    _cartItems = [...cartItems1];
    notifyListeners();
  }
}
