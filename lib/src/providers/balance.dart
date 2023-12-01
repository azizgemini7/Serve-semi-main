import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Serve_ios/src/models/balance_transfer.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/pagination_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'auth.dart';

class Balance with ChangeNotifier {
  final User user;
  String _appLanguage = 'ar';
  var balance;
  PaginationList balanceTransfers;
  Balance(this.user, this.balanceTransfers, this.balance, this._appLanguage);
  Future<void> getMyBalance([bool refresh = false]) async {
    if (!refresh &&
        balanceTransfers?.currentPage != null &&
        balanceTransfers?.currentPage == balanceTransfers?.lastPage) return;
    try {
      final response = await http.get(
          Uri.parse(
              '$uri/api/v1/balance?page=${refresh ? 1 : ((balanceTransfers?.currentPage ?? 0) + 1)}'),
          headers: {
            'Authorization': 'Bearer ${user?.token}',
            'Accept-Language': _appLanguage
          });
      Map<String, dynamic> parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      balance = parsedResponse['balance'];
      parsedResponse['data']['data'] = parsedResponse['data']['data']
          .map<BalanceTransfer>((work) => BalanceTransfer.fromJson(work))
          .toList();
      if (balanceTransfers == null || refresh)
        balanceTransfers = PaginationList.fromJson(parsedResponse['data']);
      else {
        balanceTransfers.addItemsToList(parsedResponse);
        balanceTransfers.data.addAll(parsedResponse['data']['data']
            .map<BalanceTransfer>((work) => BalanceTransfer.fromJson(work))
            .toList());
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
