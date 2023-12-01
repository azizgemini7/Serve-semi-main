import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PaytabsServices {
  Map<String, String> staticPaymentParams = {
    "merchant_email": 'callories.1@gmail.com',
    "secret_key":
        'P4qKwyOtmgHVHX0FPvnV2xBihAbWuoTksk4ZSTtf9bbR8bwXGUTJrv1J6dFABzU4TZ4LSx12IcTQoqO4kINLePuk29UEIPJCPNnI',
    "site_url": uri,
    "return_url": "$uri/api/v1/return_url",
    "currency": "SAR",
    "ip_merchant": "172.67.185.203",
    "billing_address": "Riyadh",
    "city": "Riyadh",
    "state": "Riyadh",
    "postal_code": "11543",
    "country": "SAU",
    "address_shipping": "Riyadh",
    "state_shipping": "Riyadh",
    "city_shipping": "Riyadh",
    "postal_code_shipping": "11543",
    "country_shipping": "SAU",
    "cms_with_version": "Dart2.8.4/laravel"
  };
  Future<String> getExistingTokens(String token) async {
    try {
      final response =
          await http.get(Uri.parse('$uri/api/v1/get-credit-cards'), headers: {
        'Authorization': 'Bearer $token',
      });
      final parsedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(parsedResponse['message'], response.statusCode);
      }
      return response.body;
    } catch (error) {
      throw error;
    }
  }

  Future<String> createPaytabsPaymentPage({
    @required String title,
    @required String language,
    @required String amount,
    @required String ip,
    @required String customerFirstName,
    @required String customerPhoneNumber,
    @required String customerLastName,
    @required String orderId,
    @required String email,
    @required String isTokenization,
    String otherCharges,
    String discount,
    List<String> orderTitles,
    List<String> unitPrices,
    String ptCustomerEmail,
    String ptCustomerPassword,
    String ptToken,
    List<String> quantities,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("https://www.paytabs.com/apiv2/create_pay_page"),
        body: {
          ...staticPaymentParams,
          'reference_no': orderId,
          'products_per_title': orderTitles?.join(' || ') ?? 'meal',
          'unit_price': unitPrices?.join(' || ') ?? '$amount',
          'quantity': quantities?.join(' || ') ?? '1',
          'discount': discount ?? '0.0',
          'other_charges': otherCharges ?? '0.0',
          'amount': amount,
          'email': email,
          'pt_customer_email': ptCustomerEmail ?? '',
          'pt_customer_password': ptCustomerPassword ?? '',
          'pt_token': ptToken ?? '',
          'cc_first_name': customerFirstName ?? '',
          'is_existing_customer': ptToken != null ? 'TRUE' : 'FALSE',
          'cc_phone_number': customerPhoneNumber,
          'phone_number': customerPhoneNumber,
          'title': title,
          'msg_lang': language,
          'shipping_first_name': customerFirstName ?? '',
          'shipping_last_name': customerLastName,
          'ip_customer': ip,
          'cc_last_name': customerLastName
        },
      );

      final body = convert.jsonDecode(response.body);
      print(body);
      if (response.statusCode == 200) {
        print('haha nice');
        return body['payment_url'];
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
