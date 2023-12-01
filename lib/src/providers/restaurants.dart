import 'dart:convert';

import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/meal.dart';
import 'package:Serve_ios/src/models/restaurant.dart';
import 'package:Serve_ios/src/models/restaurant_category.dart';
import 'package:Serve_ios/src/models/slide.dart';
import 'package:Serve_ios/src/models/user.dart';
import 'package:Serve_ios/src/screens/complete_order_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class Restaurants with ChangeNotifier {
  List<Restaurant> _restaurants = [];
  List<Restaurant> _offersRestaurants = [];

  List<Restaurant> get offersRestaurants => _offersRestaurants;
  List<RestaurantCategory> _restaurantCategories = [];
  List<Slide> _offersSlider = [];
  List<Slide> _offersSlider2 = [];

  List<Slide> get offersSlider2 => _offersSlider2;

  List<RestaurantCategory> get restaurantCategories => _restaurantCategories;

  List<Restaurant> get restaurants => _restaurants;
  final String _appLanguage;
  final User user;

  Restaurants(this.user, this._restaurants, this._offersSlider,
      this._restaurantCategories,
      [this._appLanguage = 'ar']);

  Future<int> _fetchRestaurants(String params, [int page]) async {
    page = page ?? 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (!prefs.containsKey('userData'))
    final String storedUserData = prefs.getString('userData');

    if (storedUserData != null) {
      Map<String, dynamic> userData =
          json.decode(storedUserData) as Map<String, dynamic>;
      String _userId = '${userData['id']}';
      String _token = userData['token'];

      print("_user _token:: " + _token);
      print("storedUserData:: " + storedUserData);
    }
    print("called");
    if (page == 1) {
      _restaurants = [];
    }

    try {
      Auth auth;
      // print("WE got Tooken:: " + auth.token);
      final response = await http
          .get(Uri.parse('$uri/api/v1/main-page?page=$page$params'), headers: {
        // 'Authorization': 'Bearer ${_token}',
        'Accept-Language': _appLanguage
      });
      print("Url " + '$uri/api/v1/main-page?page=$page$params');
      print("_restaurantCategories:: " + response.body);
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      if (!_restaurantCategories.isEmpty) {
        _restaurantCategories.clear();
      }
      if (!_offersSlider.isEmpty) {
        _offersSlider.clear();
      }

      // if (page == 1) {
      //   _restaurants.clear();
      // }
      parsedResponse['restaurants']['data'].forEach((item) {
        print("item::" + Restaurant.fromJson(item).toJson().toString());
        if(_restaurants.isNotEmpty){
          _restaurants.clear();
        }else{
          print("_restaurants data $_restaurants");
          _restaurants.add(Restaurant.fromJson(item));
        }
        
      });
      //  final prefs = await SharedPreferences.getInstance();

    // if (prefs.containsKey('selectedaddress')) {
      
    //   // _orderData['s_address'] = saddress;
    // }
      parsedResponse['restaurant_categories'].forEach((item) {
        _restaurantCategories.add(RestaurantCategory.fromJson(item));
        // print("_restaurantCategories[0].id ${_restaurantCategories[0].id}");
        // print("_restaurantCategories[0].name ${_restaurantCategories[0].name}");
      });
      parsedResponse['offers_slider'].forEach((item) {
        _offersSlider.add(Slide.fromJson(item));
        print("_offersSlider " + _offersSlider.take(0).first.name);
      });

       if(_restaurants.isNotEmpty){
          prefs.setBool('in_range', true);
      }else{
          prefs.setBool('in_range', false);
      }

      notifyListeners();
      return parsedResponse['restaurants']['last_page'];
    } catch (error) {
      throw error;
    } finally {
      print("_fetchRestaurants:: Done!");
    }
  }

  Future<int> _fetchOffers(String params, [int page]) async {
    page = page ?? 1;
    if (page == 1) {
      _offersRestaurants = [];
    }
    try {
      if (user != null) {
        print("Called==_fetchOffers" + user.token);
      } else {
        print("No Auth Data , probably user not logged in yet!");
      }

      final response = await http
          .get(Uri.parse('$uri/api/v1/offers?page=$page$params'), headers: {
        //  'Authorization': 'Bearer ${user?.token}',
        'Accept-Language': _appLanguage
      });
      print("mohamd:: ");
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      _offersSlider2 = [];

      parsedResponse['restaurants']['data'].forEach((item) async {
        // print("Restaurant.fromJson(item).distance ${Restaurant.fromJson(item).maxdist}");

        if (Restaurant.fromJson(item).distance <=
            double.parse(Restaurant.fromJson(item).maxdist) / 1000.toDouble()) {
          print("Restaurants==data:: " +
              Restaurant.fromJson(item).deliveryPrice.toString());
          print("Restaurants===_fetchOffers:: " +
              Restaurant.fromJson(item).description);

          _offersRestaurants.add(Restaurant.fromJson(item));
        }
      });
      parsedResponse['offers_slider'].forEach((item) async {
        _offersSlider2.add(Slide.fromJson(item));
      });

      notifyListeners();
      return parsedResponse['restaurants']['last_page'];
    } catch (error) {
      throw error;
    }
  }

  Future<void> getRestaurantDetails(int restaurantId) async {
    try {
      if (user != null) {
        print("user?.token:: " + user?.token);
      }

      final response = await http
          .get(Uri.parse('$uri/api/v1/restaurant/$restaurantId'), headers: {
        'Authorization': 'Bearer ${user?.token}',
        'Accept-Language': _appLanguage
      });
      final parsedResponse = json.decode(response.body);
      if (response == null) {
        print("Very Null");
      }
      print("getRestaurantDetails:: " + response.body);

      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      final int xx =
          _restaurants.indexWhere((element) => element.id == restaurantId);
      final double distance = _restaurants[xx].distance;
      parsedResponse['distance'] = distance;

      // final data = Restaurant.fromJson(parsedResponse);

      // for (var restaurantData in parsedResponse) {
      //   _restaurants.add(Restaurant.fromJson(restaurantData));
      // }
      // if (xx != -1) {
      //   _restaurants
      //       .replaceRange(xx, xx + 1, [Restaurant.fromJson(parsedResponse)]);
      // }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<Meal> getMealDetails(int mealId) async {
    try {
      final response = await http.get(Uri.parse('$uri/api/v1/product/$mealId'),
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      return Meal.fromJson(parsedResponse);
    } catch (error) {
      throw error;
    }
  }

  Future<int> fetchRestaurants(String encodedData, [int page]) async =>
      await _fetchRestaurants(encodedData, page);
  Future<int> fetchOffers(String encodedData, [int page]) async =>
      await _fetchOffers(encodedData, page);

  List<Slide> get offersSlider => _offersSlider;
}
