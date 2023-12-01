import 'dart:convert';
import 'dart:io';
import 'package:Serve_ios/src/screens/myglobals.dart' as globals;
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/user.dart';
import 'package:async/async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String uri = 'https://lazah.net';

class Auth with ChangeNotifier {
  User _user;
  String _token;
  String _userId;
  String _appLanguage = 'ar';
  Auth(this._user, this._token, this._userId, this._appLanguage);

  bool get isAuth => (_token != null) && (_token != '');

  String get token => _token;
  String get appLanguage => _appLanguage;

  User get user => _user;

  String get userId => _userId;

  bool appReviewed = false;

  Future<bool> getAppSettings() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/v1/app-settings'));
      print("getAppSettings:: " + response.body);
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message']);
      }

      appReviewed = parsedResponse['setting1'] == 1;
      return appReviewed;
    } catch (error) {
      throw error;
    }
  }

  Future<String> updateProfile(String encodedUserData) async {
    final Map data = json.decode(encodedUserData);
    print(data.toString());

    // open a bytestream
    try {
      // string to uri
      var url = Uri.parse("$uri/api/v1/update-profile");

      // create multipart request
      var request = new http.MultipartRequest("POST", url);

      // multipart that takes file
      if (data['photo'] != null && data['photo'] != '') {
        final File imageFile = File(data['photo']);
        var stream =
            new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        // get file length
        var length = await imageFile.length();
        var multipartFile = new http.MultipartFile('photo', stream, length,
            filename: basename(imageFile.path));
        request.files.add(multipartFile);
      }
      // add file to multipart
      data.remove('photo');
      request.fields.addAll(Map<String, String>.from(data));

      // send
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode != 200) {
        print(response.statusCode);
        print(json.decode(respStr)['message']);
        throw HttpException(
            json.decode(respStr)['message'], response.statusCode);
      }
      // listen for response
      print(json.decode(respStr).toString());
//      response.stream.transform(utf8.decoder).listen((value) {
//        print(value);
//      });
      setUser(json.encode(json.decode(respStr)), true);
      notifyListeners();
      return respStr;
    } catch (error) {
      throw error;
    }
  }

  Future<String> updateUserData() async {
    try {
      // string to uri
      var url = Uri.parse("$uri/api/v1/current-user");

      // create multipart request
      var request = new http.MultipartRequest("get", url);

      // multipart that takes file
      // add file to multipart

      // send
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept-Language': _appLanguage,
      });
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode != 200) {
        print(response.statusCode);
        print(json.decode(respStr)['message']);
        throw HttpException(
            json.decode(respStr)['message'], response.statusCode);
      }
      // listen for response
      print(json.decode(respStr).toString());
//      response.stream.transform(utf8.decoder).listen((value) {
//        print(value);
//      });
      setUser(json.encode(json.decode(respStr)), true);
      notifyListeners();
      return respStr;
    } catch (error) {
      throw error;
    }
  }

  Future<String> register(String encodedUserData) async {
    final data = json.decode(encodedUserData);
    print(data.toString());

    // open a bytestream
    try {
      // string to uri
      var url = Uri.parse("$uri/api/v1/register");

      // create multipart request
      var request = new http.MultipartRequest("POST", url);

      // multipart that takes file
      if (data['photo'] != null && data['photo'] != '') {
        final File imageFile = File(data['photo']);
        var stream =
            new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        // get file length
        var length = await imageFile.length();
        var multipartFile = new http.MultipartFile('photo', stream, length,
            filename: basename(imageFile.path));
        request.files.add(multipartFile);
      }
      data.remove('photo');
      data.remove('activation_code');
      data.remove('isRegister');
      // add file to multipart
      request.fields.addAll(Map<String, String>.from(data));

      // send
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept-Language': _appLanguage,
      });
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode != 200) {
        throw HttpException(
            json.decode(respStr)['message'], response.statusCode);
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', respStr);
      notifyListeners();
      setUser(respStr);

      notifyListeners();
      return respStr;
    } catch (error) {
      throw error;
    }
  }

  Future<String> _login(String encodedLoginData) async {
    final String url = '$uri/api/v1/login';
    print('llllllllllloooooooooooggggggggggggggggggiiiiiiiiinnnnnnnnnnnnnn');

    try {
      final response = await http.post(Uri.parse(url),
          body: json.decode(encodedLoginData),
          headers: {'Accept-Language': _appLanguage});
      print('sdfsdfsdfsdfsdfdfs');
      print(jsonDecode(response.body));
      print(response.statusCode);
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(responseData['message'], response.statusCode);
      }
      throw HttpException('${responseData['activation_code']}', 4003);
    } catch (exp) {
      throw exp;
    }
  }

  Future<String> login(encodedLoginData) async {
    return await _login(encodedLoginData);
  }

  Future<String> forgotPassword(String encodedData) async {
    final data = json.decode(encodedData);
    final String url = '$uri/api/v1/forget';

    try {
      final response = await http.post(Uri.parse(url),
          body: data, headers: {'Accept-Language': _appLanguage});
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(responseData['message'], response.statusCode);
      }
      print(responseData.toString());
      return response.body;
    } catch (exp) {
      throw exp;
    }
  }

  Future<bool> tryAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final String storedUserData = prefs.getString('userData');

    Map<String, dynamic> userData =
        json.decode(storedUserData) as Map<String, dynamic>;
    _userId = '${userData['id']}';
    _token = userData['token'];
    print("_token:: " + _token);
    print("storedUserData:: " + storedUserData);
    setUser(storedUserData);
    notifyListeners();
    return true;
  }

  Future<String> _activateUser(String _encodedActivationData) async {
    final Map _activationData = json.decode(_encodedActivationData);
    try {
      print("_activationData:: " + _activationData.entries.toString());
      final response = await http.post(Uri.parse('$uri/api/v1/activate'),
          body: _activationData, headers: {'Accept-Language': _appLanguage});
      final responseData = json.decode(response.body);
      if (response.statusCode != 200)
        throw HttpException(responseData['message'], response.statusCode);
      notifyListeners();

      setUser(response.body, true);
      notifyListeners();
      return response.body;
    } catch (error) {
      throw error;
    }
  }

  Future<String> _activateForgot(
      String email, String activationCode, String deviceToken) async {
    try {
      final response =
          await http.post(Uri.parse('$uri/api/v1/activate'), body: {
        'email': email,
        'activation_code': activationCode,
        'device_token': deviceToken,
      }, headers: {
        'Accept-Language': _appLanguage
      });
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(responseData['message'], response.statusCode);
      }
      return response.body;
    } catch (error) {
      throw error;
    }
  }

//  Future<String> activatePhone(String phone, String activationCode) async {
//    try {
//      final response = await http.post('$uri/api/v1/activate-phone', body: {
//        'phone': phone,
//        'activation_code': activationCode,
//      }, headers: {
//        'Authorization': 'Bearer $_token',
//        'Accept-Language': _appLanguage
//      });
//      final responseData = json.decode(response.body);
//      print(responseData.toString());
//      if (response.statusCode != 200) {
//        throw HttpException(responseData['message'], response.statusCode);
//      }
//      notifyListeners();
//      setUser(json.encode(responseData['data']), true);
//      print(responseData.toString());
//      return response.body;
//    } catch (error) {
//      throw error;
//    }
//  }

  Future<void> setUser(String encodedUserMap, [bool store]) async {
    Map<String, dynamic> userData = json.decode(encodedUserMap);
    print(userData.toString());
    print("called setUser:: setUser()");
    print('kkkkkkkkkkkkkkkkkkkkkkk');
    _token = userData['token'];
    _userId = '${userData['id']}';
    print('notification ${userData['notification']}');
    _user = User.fromJson(userData);

    if (store != null) {
      if (store) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userData', encodedUserMap);
      }
    }
  }

  Future<void> updateNotification(bool val) async {
    user.notification = val;
    notifyListeners();
    final String url = '$uri/api/v1/update-notification';
    try {
      final response = await http.post(Uri.parse(url), body: {
        'notification': (val ? 1 : 0).toString()
      }, headers: {
        'Authorization': 'Bearer $token',
        'Accept-Language': _appLanguage
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var xx = json.decode(prefs.getString('userData'));
      xx['notification'] = val ? 1 : 0;
      setUser(json.encode(xx), true);
    } catch (exp) {
      throw exp;
    }
  }

  Future<String> activateUser(String _encodedActivationData) async {
    return _activateUser(_encodedActivationData);
  }

  Future<String> activateForgot(String email, String activationCode,
      [String deviceToken]) async {
    return _activateForgot(email, activationCode, deviceToken);
  }

  Future<void> logoutDone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var key in prefs.getKeys()) {
      if (key != 'landed' && key != 'lang') {
        prefs.remove(key);
      }
    }
    _token = null;
    _userId = null;
    _user = null;
    globals.myid = '';
    notifyListeners();
  }

  Future<String> deleteacc([bool notify]) async {
    FirebaseMessaging myFirebaseMessaging = FirebaseMessaging.instance;
    final token = await myFirebaseMessaging.getToken();
    notify = notify ?? false;

    try {
      final response = await http.get(Uri.parse('$uri/api/v1/delete-account'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept-Language': _appLanguage
          });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          logoutDone();
        }
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      await myFirebaseMessaging.deleteToken();
      print(parsedResponse.toString());
      if (notify) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        for (var key in prefs.getKeys()) {
          if (key != 'landed' && key != 'lang') {
            prefs.remove(key);
          }
        }
        _token = null;
        _userId = null;
        _user = null;
        notifyListeners();
      }
      return response.body;
    } catch (error) {
      throw error;
    }
  }

  Future<String> logout([bool notify]) async {
    FirebaseMessaging myFirebaseMessaging = FirebaseMessaging.instance;
    final token = await myFirebaseMessaging.getToken();
    notify = notify ?? false;

    try {
      final response = await http.post(Uri.parse('$uri/api/v1/logout'), body: {
        'device_token': token
      }, headers: {
        'Authorization': 'Bearer $_token',
        'Accept-Language': _appLanguage
      });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          logoutDone();
        }
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      await myFirebaseMessaging.deleteToken();
      print(parsedResponse.toString());
      if (notify) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        for (var key in prefs.getKeys()) {
          if (key != 'landed' && key != 'lang') {
            prefs.remove(key);
          }
        }
        _token = null;
        _userId = null;
        _user = null;
        notifyListeners();
      }
      return response.body;
    } catch (error) {
      throw error;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
