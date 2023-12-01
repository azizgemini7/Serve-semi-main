import 'dart:convert';

import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/order.dart';
import 'package:Serve_ios/src/models/order_for_delegate.dart';
import 'package:Serve_ios/src/models/order_status.dart';
import 'package:Serve_ios/src/models/pagination_list.dart';
import 'package:Serve_ios/src/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';

enum DelegateOrderType { New, Current, Finished }

class Orders with ChangeNotifier {
  List<Order> _myOrders = [];

  bool isMakingRequest = false;
  bool isGettingStatus = false;
  List<Order> get myOrders => _myOrders;
  PaginationList delegateNewOrders;
  PaginationList delegateCurrentOrders;
  PaginationList delegateFinishedOrders;
  final String _appLanguage;
  final User user;

  Orders(this.user, this._myOrders, this.delegateNewOrders,
      this.delegateCurrentOrders, this.delegateFinishedOrders,
      [this._appLanguage = 'ar']);

  insertTempOrder(Order order) {
    _myOrders.insert(0, order);
    notifyListeners();
  }

  int ordersPagesCount = 1;
  int currentPage = 1;
  bool isLoading = false;
  Future<int> _fetchMyOrders([int page]) async {
    page = page ?? ++currentPage;
    currentPage = page;
    isLoading = true;
    if (page == 1) _myOrders.clear();
    try {
      notifyListeners();
      final response = await http
          .get(Uri.parse('$uri/api/v1/my-orders?page=$page'), headers: {
        'Authorization': 'Bearer ${user?.token}',
        'Accept-Language': _appLanguage
      });
      print("_fetchMyOrders():: " + response.body);
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      if (page == 1) _myOrders.clear();
      parsedResponse['data'].forEach((item) {
        _myOrders.add(Order.fromJson(item));
      });
      ordersPagesCount = parsedResponse['last_page'];
      if (ordersPagesCount >= page) isLoading = false;
      notifyListeners();
      return parsedResponse['last_page'];
    } catch (error) {
      throw error;
    }
  }

  Future<void> getDelegateNewOrders([bool refresh = false]) async {
    if (!refresh &&
        delegateNewOrders?.currentPage != null &&
        delegateNewOrders?.currentPage == delegateNewOrders?.lastPage) return;
    try {
      final response = await http.get(
          Uri.parse(
              '$uri/api/v1/my-new-orders?page=${refresh ? 1 : ((delegateNewOrders?.currentPage ?? 0) + 1)}'),
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });

      Map<String, dynamic> parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      print("getDelegateNewOrders:: " + response.body);
      parsedResponse['data'] = parsedResponse['data']
          .map<OrderForDelegate>((work) => OrderForDelegate.fromJson(work))
          .toList();
      if (delegateNewOrders == null || refresh)
        delegateNewOrders = PaginationList.fromJson(parsedResponse);
      else {
        delegateNewOrders.addItemsToList(parsedResponse);
        delegateNewOrders.data.addAll(parsedResponse['data']
            .map<OrderForDelegate>((work) => OrderForDelegate.fromJson(work))
            .toList());
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> getDelegateCurrentOrders([bool refresh = false]) async {
    if (!refresh &&
        delegateCurrentOrders?.currentPage != null &&
        delegateCurrentOrders?.currentPage == delegateCurrentOrders?.lastPage)
      return false;
    try {
      final response = await http.get(
          Uri.parse(
              '$uri/api/v1/my-current-orders?page=${refresh ? 1 : ((delegateCurrentOrders?.currentPage ?? 0) + 1)}'),
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      print("getDelegateCurrentOrders :: " + response.body);
      Map<String, dynamic> parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      parsedResponse['data'] = parsedResponse['data']
          .map<OrderForDelegate>((work) => OrderForDelegate.fromJson(work))
          .toList();
      if (delegateCurrentOrders == null || refresh)
        delegateCurrentOrders = PaginationList.fromJson(parsedResponse);
      else {
        delegateCurrentOrders.addItemsToList(parsedResponse);
        delegateCurrentOrders.data.addAll(parsedResponse['data']
            .map<OrderForDelegate>((work) => OrderForDelegate.fromJson(work))
            .toList());
      }
      notifyListeners();
      return delegateCurrentOrders.data.indexWhere(
              (element) => (element as OrderForDelegate).orderStatus == 3) !=
          -1;
    } catch (error) {
      throw error;
    }
  }

  Future<void> getDelegateFinishedOrders([bool refresh = false]) async {
    if (!refresh &&
        delegateFinishedOrders?.currentPage != null &&
        delegateFinishedOrders?.currentPage == delegateFinishedOrders?.lastPage)
      return;
    try {
      final response = await http.get(
          Uri.parse(
              '$uri/api/v1/my-finished-orders?page=${refresh ? 1 : ((delegateFinishedOrders?.currentPage ?? 0) + 1)}'),
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      Map<String, dynamic> parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      parsedResponse['data'] = parsedResponse['data']
          .map<OrderForDelegate>((work) => OrderForDelegate.fromJson(work))
          .toList();
      if (delegateFinishedOrders == null || refresh)
        delegateFinishedOrders = PaginationList.fromJson(parsedResponse);
      else {
        delegateFinishedOrders.addItemsToList(parsedResponse);
        delegateFinishedOrders.data.addAll(parsedResponse['data']
            .map<OrderForDelegate>((work) => OrderForDelegate.fromJson(work))
            .toList());
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getOrderStatus(int orderId) async {
    isGettingStatus = true;
    try {
      // notifyListeners();
      final response = await http
          .get(Uri.parse('$uri/api/v1/order-status/$orderId'), headers: {
        'Authorization': 'Bearer ${user?.token}',
        'Accept-Language': _appLanguage
      });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      final myOrder = _myOrders.singleWhere((element) => element.id == orderId,
          orElse: () => null);
      myOrder?.statusesDetailed = parsedResponse['status']
          ?.map<OrderStatus>((status) => OrderStatus.fromJson(status))
          ?.toList();
      myOrder?.maxTime = parsedResponse['max_time'];
      notifyListeners();
      return;
    } catch (error) {
      notifyListeners();
      throw error;
    } finally {
      isGettingStatus = false;
    }
  }

  Future<User> getDriverDetails(int orderId) async {
    try {
      final response = await http
          .get(Uri.parse('$uri/api/v1/get-driver/$orderId'), headers: {
        'Authorization': 'Bearer ${user?.token}',
        'Accept-Language': _appLanguage
      });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      return User.fromJson(parsedResponse['data']);
    } catch (error) {
      throw error;
    } finally {
      isMakingRequest = false;
      notifyListeners();
    }
  }

  Future<void> deliverOrder(
      int orderId, DelegateOrderType delegateOrderType, String price) async {
    isMakingRequest = true;
    try {
      var body = {
        'order_id': '$orderId',
      };
      if (price != '-1') {
        body = {
          'order_id': '$orderId',
          'price': price,
        };
      }
      notifyListeners();
      final response = await http.post(Uri.parse('$uri/api/v1/deliver-order'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      print(response.body);
      final parsedResponse = json.decode(response.body);

      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      if (delegateOrderType == DelegateOrderType.New)
        await getDelegateNewOrders(true);
      else if (delegateOrderType == DelegateOrderType.Current)
        await getDelegateCurrentOrders(true);
      else if (delegateOrderType == DelegateOrderType.Finished)
        await getDelegateFinishedOrders(true);
      return;
    } catch (error) {
      throw error;
    } finally {
      isMakingRequest = false;
      notifyListeners();
    }
  }

  Future<void> takeOrder(
      int orderId, DelegateOrderType delegateOrderType) async {
    isMakingRequest = true;
    try {
      notifyListeners();
      final response = await http.post(Uri.parse('$uri/api/v1/take-order'),
          body: {
            'order_id': '$orderId'
          },
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      if (delegateOrderType == DelegateOrderType.New)
        await getDelegateNewOrders(true);
      else if (delegateOrderType == DelegateOrderType.Current)
        await getDelegateCurrentOrders(true);
      else if (delegateOrderType == DelegateOrderType.Finished)
        await getDelegateFinishedOrders(true);
      return;
    } catch (error) {
      throw error;
    } finally {
      isMakingRequest = false;
      notifyListeners();
    }
  }

  Future<void> receiveRequest(
      int orderId, DelegateOrderType delegateOrderType) async {
    isMakingRequest = true;
    try {
      notifyListeners();
      final response = await http.post(Uri.parse('$uri/api/v1/accept-order'),
          body: {
            'order_id': '$orderId',
            'longitude': '0',
            'latitude': '0'
          },
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      final parsedResponse = json.decode(response.body);
      print(parsedResponse);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      if (delegateOrderType == DelegateOrderType.New)
        await getDelegateNewOrders(true);
      else if (delegateOrderType == DelegateOrderType.Current)
        await getDelegateCurrentOrders(true);
      else if (delegateOrderType == DelegateOrderType.Finished)
        await getDelegateFinishedOrders(true);
      return;
    } catch (error) {
      throw error;
    } finally {
      isMakingRequest = false;
      notifyListeners();
    }
  }

  Future<void> pushToDrivers(
      int orderId, DelegateOrderType delegateOrderType) async {
    try {
      notifyListeners();
      final response = await http.post(Uri.parse('$uri/api/v1/push-order'),
          body: {
            'order_id': '$orderId',
            'longitude': '0',
            'latitude': '0'
          },
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      final parsedResponse = json.decode(response.body);
      print("pushToDrivers:: ${parsedResponse}");
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }

      return;
    } catch (error) {
      throw error;
    } finally {
      isMakingRequest = false;
      notifyListeners();
    }
  }

  Future<int> fetchMyOrders([int page]) async => await _fetchMyOrders(page);
}
