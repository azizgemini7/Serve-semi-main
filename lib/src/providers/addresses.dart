import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Serve_ios/src/models/address.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/screens/complete_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'auth.dart';

class Addresses with ChangeNotifier {
  final User user;
  String _appLanguage = 'ar';
  List<Address> _addresses = [];
  Addresses(this.user, this._addresses, this._appLanguage, this.paymentType);

  getStoredPaymentType() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('paymentType')) {
      final type = prefs.getString('paymentType');
      if (type == PaymentType.Cash.toString())
        paymentType = PaymentType.Cash;
      else
        paymentType = PaymentType.Online;
    }
  }

  PaymentType paymentType = PaymentType.Cash;
  Address _selectedAddress;

  Address get selectedAddress => _selectedAddress;

  changeSelectedAddress(int addressId) async {
    _selectedAddress = _addresses
        .singleWhere((element) => element.id == addressId, orElse: () => null);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedaddress', _selectedAddress.address);
    prefs.setString('selectedaddressLng', _selectedAddress.longitude);
    prefs.setString('selectedaddressLat', _selectedAddress.latitude);
    print("selected address:: ${_selectedAddress.address}");
    print("selected address Lng:: ${_selectedAddress.longitude}");
    print("selected address Lat:: ${_selectedAddress.latitude}");
    notifyListeners();
  }

  List<Address> get addresses => _addresses;

  String get appLanguage => _appLanguage;
  Future<void> fetchAddresses() async {
    return await _fetchAddresses();
  }

  changePaymentType(PaymentType type) async {
    final prefs = await SharedPreferences.getInstance();
    print(type.toString());
    await prefs.setString('paymentType', type.toString());
    paymentType = type;
    notifyListeners();
  }

  Future<String> addAddress(String addressData) async {
    final decodedAdData = json.decode(addressData);
    try {
      final response = await http.post(Uri.parse('$uri/api/v1/add-address'),
          body: decodedAdData,
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      notifyListeners();
      return response.body;
    } catch (error) {
      throw error;
    }
  }

  Future<String> editAddress(String addressData) async {
    final decodedAdData = json.decode(addressData);
    try {
      final response = await http.post(Uri.parse('$uri/api/v1/edit-address'),
          body: decodedAdData,
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      await fetchAddresses();
      notifyListeners();
      return response.body;
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeAddress(int addressId) async {
    try {
      final response = await http.post(Uri.parse('$uri/api/v1/delete-address'),
          body: {
            'address_id': '$addressId'
          },
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      _addresses.removeWhere((element) => element.id == addressId);
      notifyListeners();
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<void> _fetchAddresses() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/v1/my-addresses'),
          headers: {
            'Accept-Language': _appLanguage,
            'Authorization': 'Bearer  ${user?.token}'
          });

      final cities = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(cities['message']);
     
      _addresses = [];
      cities.forEach((item) {
        _addresses.add(Address.fromJson(item));
      });

      final SharedPreferences prefs = await SharedPreferences.getInstance();


      print("_fetchAddresses==response" + response.body);
      // if (prefs.getString("selectedaddress").isNotEmpty && prefs.getString("selectedaddressLng").isNotEmpty & prefs.getString("selectedaddressLat").isNotEmpty){
      //    prefs.setString('selectedaddress', "");
      //    prefs.setString('selectedaddressLng', "");
      //    prefs.setString('selectedaddressLat', "");
      // }

      if (_selectedAddress == null && _addresses.isNotEmpty){
        _selectedAddress = addresses.first;
      }
     
     if(_selectedAddress != null){
        if (_selectedAddress.address.isNotEmpty) {
          prefs.setString('selectedaddress', _selectedAddress.address);
          prefs.setString('selectedaddressLng', selectedAddress.longitude);
          prefs.setString('selectedaddressLat', selectedAddress.latitude);
          print("fetched address:: ${_selectedAddress.address}");
        } else {
          final SharedPreferences prefs4 = await SharedPreferences.getInstance();
            prefs4.remove('selectedaddress');
            prefs4.remove('selectedaddressLng');
            prefs4.remove('selectedaddressLat');
          print("Warning: _selectedAddress is null");
        }
    }
      return true;
    } catch (error) {
      throw error;
    }
  }
}
