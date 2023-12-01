import 'dart:convert';

import 'package:Serve_ios/src/models/notification.dart' as note;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/user.dart';
import 'auth.dart';

class Notifications with ChangeNotifier {
  List<note.Notification> _items = [];
  User user;
  int count = 0;
  List<note.Notification> get items => _items;

  void increaseCount() {
    count++;
    notifyListeners();
  }

  String _token;

  void addNotification(String notification) {
    if (user != null) {
      var xx = json.decode(notification);
      if (xx != null) {
        _items.insert(
          0,
          note.Notification.fromPush(xx),
        );
        notifyListeners();
      }
    }
  }

  Future<void> updateDeviceToken(String newToken) async {
    print('tokenrefresh called $newToken');
    if (user != null) {
      try {
        final response = await http
            .post(Uri.parse('$uri/api/v1/update-device-token'), body: {
          'device_token': newToken,
          'device_type': '',
        }, headers: {
          'Authorization': 'Bearer $_token',
        });
      } catch (error) {
        throw error;
      }
    }
  }

  Notifications(this.user, this._items) {
    _token = user == null ? null : user.token;
  }

  Future<int> getNotifications(int page, String appLanguage) async {
    print('page $page');
    page = page ?? 1;
    try {
      final response = await http
          .get(Uri.parse('$uri/api/v1/notifications?page=$page'), headers: {
        'Authorization': 'Bearer $_token',
      });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message']);
      }
      if (page == 1) _items = [];
      parsedResponse['data'].forEach((item) {
        print('itemmmmmmmmmmmmmmmmmmm $item');
        _items.add(note.Notification.map(item));
      });
      print(_items.length);
      getNotificationCount();
      notifyListeners();
      return parsedResponse['last_page'];
    } catch (error) {
      throw error;
    }
  }
//
  Future<void> getNotificationCount() async {
    if (user != null) {
      try {
        final response = await http.get(
            Uri.parse('$uri/api/v1/get-notifications-count'),
            headers: {'Authorization': 'Bearer $_token'});
        final parsedResponse = json.decode(response.body);
        if (response.statusCode != 200) {
          throw HttpException(parsedResponse['message']);
        }
        count = parsedResponse['notification_count'];
        print(count);
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> deleteNotification(int id, String appLanguage) async {
    _items.removeWhere((test) => test.id == id);
    notifyListeners();
    try {
      final response = await http
          .post(Uri.parse('$uri/api/v1/delete-notification'), headers: {
        'Authorization': 'Bearer $_token',
        'Accept-Language': appLanguage
      }, body: {
        'notification_id': id.toString(),
      });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message']);
      }
      notifyListeners();
      return parsedResponse['message'];
    } catch (error) {
      throw error;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
