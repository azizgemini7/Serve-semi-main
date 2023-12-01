import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Serve_ios/src/models/city.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'auth.dart';

class GlobalData with ChangeNotifier {
  final User user;
  String _appLanguage;

  String _terms;
  String _policies;

  String get policies => _policies;
  List<City> _cities = [];
  String _about;
  Map _contactData;

  GlobalData(
      this.user, this._about, this._terms, this._cities, this._appLanguage);
  List<City> get cities => [..._cities];
  Future<void> fetchCities() async {
    return await _fetchCities();
  }

  Future<void> _fetchCities() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/v1/cities'),
          headers: {'Accept-Language': _appLanguage});
      final cities = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(cities['message']);

      _cities = [];

      cities.forEach((item) {
        print("Adding == city :: " + City.fromJson(item).name);
        _cities.add(City.fromJson(item));
      });
      print("cities name:: " + _cities.first.name);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  bool get isAuth => user != null;
//  List<Category> get storesCategories => [..._storesCategories];
  String get appLanguage => _appLanguage;
  String get terms => _terms;
  String get about => _about;
  Map get contactData => _contactData;
//  String get policies => _policies;
//  List<BankAccount> _bankAccounts = [];
//  List<BankAccount> get bankAccounts => _bankAccounts;

//  List<Store> _categoryStores = [];
//  List<Company> _categoryCompanies = [];
//  List<Store> get categoryStores => _categoryStores;
//  List<Company> get categoryCompanies => _categoryCompanies;

//  Future<int> _getCategoryStores(int page, int categoryId) async {
//    page = page ?? 1;
//    try {
//      final response = await http.get(
//          '$uri/api/v1/shops-by-category/$categoryId?page=$page',
//          headers: {
//            'Authorization': 'Bearer ${user?.token}',
//          });
//      final parsedResponse = json.decode(response.body);
//      if (response.statusCode != 200) {
//        throw HttpException(parsedResponse['message']);
//      }
//      if (page == 1) _categoryStores = [];
//      parsedResponse['data']?.forEach((item) {
//        _categoryStores.add(Store.map(item));
//      });
////      getNotificationCount();
//      notifyListeners();
//      return parsedResponse['last_page'];
//    } catch (error) {
//      throw error;
//    }
//  }

//  Future<int> _getCategoryCompanies(int page, int categoryId) async {
//    page = page ?? 1;
//    try {
//      final response = await http.get(
//          '$uri/api/v1/companies-by-category/$categoryId?page=$page',
//          headers: {
//            'Authorization': 'Bearer ${user?.token}',
//          });
//      final parsedResponse = json.decode(response.body);
//      if (response.statusCode != 200) {
//        throw HttpException(parsedResponse['message']);
//      }
//      if (page == 1) _categoryCompanies = [];
//      parsedResponse['data']?.forEach((item) {
//        _categoryCompanies.add(Company.map(item));
//      });
////      getNotificationCount();
//      notifyListeners();
//      return parsedResponse['last_page'];
//    } catch (error) {
//      throw error;
//    }
//  }

//  Future<int> getCategoryStores(int page, int categoryId) async {
//    return await _getCategoryStores(page, categoryId);
//  }

//  Future<int> getCategoryCompanies(int page, int categoryId) async {
//    return await _getCategoryCompanies(page, categoryId);
//  }

//  Future<void> _fetchBankAccounts() async {
//    try {
//      final response = await http.get('$uri/api/v1/bank-accounts',
//          headers: {'Accept-Language': _appLanguage});
//      final theBanks = json.decode(response.body);
//      if (response.statusCode != 200) throw HttpException(theBanks['message']);
//
//      _bankAccounts = [];
//      theBanks.forEach((item) {
//        _bankAccounts.add(BankAccount.map(item));
//      });
//      notifyListeners();
//    } catch (error) {
//      throw error;
//    }
//  }

//  Future<void> _fetchStoresCategories() async {
//    try {
//      final response = await http.get('$uri/api/v1/shop-categories');
//      final parsedResponse = json.decode(response.body);
//      if (response.statusCode != 200)
//        throw HttpException(parsedResponse['message']);
//
//      _storesCategories = [];
//      parsedResponse.forEach((item) {
//        _storesCategories.add(Category.map(item));
//      });
//      notifyListeners();
//    } catch (error) {
//      throw error;
//    }
//  }

  Future<void> _fetchTerms() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/v1/terms'),
          headers: {'Accept-Language': _appLanguage});
      final terms = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(terms['message']);

      _terms = terms['data'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _fetchPolicies() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/v1/privacy'),
          headers: {'Accept-Language': _appLanguage});
      final policies = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(policies['message']);
      _policies = policies['data'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> _fetchAbout() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/v1/about'),
          headers: {'Accept-Language': _appLanguage});
      final about = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(about['message']);

      _about = about['data'];
      _contactData = about;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

//  List<DropdownMenuItem> getStoresCategoriesAsDropdownItems() {
//    List<DropdownMenuItem> myList = [];
//    myList.add(
//      DropdownMenuItem(
//        child: Text(
//          _appLanguage == 'ar' ? 'القسم...' : 'Category...',
//          style: TextStyle(
//              fontSize: 16.0,
//              color: const Color(0x8025364F),
//              fontWeight: FontWeight.normal),
//        ),
//        value: 0,
//      ),
//    );
//    if (_storesCategories.length > 0) {
//      _storesCategories.forEach((category) {
//        myList.add(DropdownMenuItem(
//          child: Text(
//            category.name,
//            style: TextStyle(
//                fontSize: 16.0,
//                color: const Color(0x8025364F),
//                fontWeight: FontWeight.normal),
//          ),
//          value: category.id,
//        ));
//      });
//    }
//    return myList;
//  }

//  List<DropdownMenuItem> getBanksAsDropdownItems() {
//    List<DropdownMenuItem> myList = [];
//    myList.add(
//      DropdownMenuItem(
//        child: Text(
//          _appLanguage == 'ar' ? 'اختر البنك' : 'Choose bank',
//          style: TextStyle(fontSize: 13.0),
//        ),
//        value: 0,
//      ),
//    );
//    if (_bankAccounts.length > 0) {
//      _bankAccounts.forEach((theBank) {
//        myList.add(DropdownMenuItem(
//          child: Text(
//            theBank.accountName,
//            style: TextStyle(fontSize: 13.0),
//          ),
//          value: theBank.id,
//        ));
//      });
//    }
//    return myList;
//  }

//  Future<void> getAboutApp() async {
//    try {
//      final response = await http.get('$uri/api/v1/about');
//      final parsedResponse = json.decode(response.body);
//      if (response.statusCode != 200) {
//        throw HttpException(parsedResponse['message']);
//      }
//
//      aboutApp = parsedResponse['content'];
//      notifyListeners();
//    } catch (error) {
//      throw error;
//    }
//  }

  Future<void> fetchTerms() async {
    return await _fetchTerms();
  }

  Future<void> fetchPolicies() async {
    return await _fetchPolicies();
  }

  Future<void> fetchAbout() async {
    return await _fetchAbout();
  }

//  Future<void> fetchBankAccounts() async {
//    return await _fetchBankAccounts();
//  }
//  void resetCategoryItems() {
//    _categoryCompanies = [];
//    _categoryStores = [];
//  }
}
