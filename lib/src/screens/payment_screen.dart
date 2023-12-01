import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/services/paytabs_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get_ip/get_ip.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment';
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with AlertsMixin {
  bool gettingPaymentLink = false;
  String paymentUrl;
  PaytabsServices _paytabsServices = PaytabsServices();
  Future<void> getPaymentLink() async {
    setState(() {
      gettingPaymentLink = true;
    });
    final orderData = ModalRoute.of(context).settings.arguments as Map;
    String ipAddress = await GetIp.ipAddress;
    Auth auth = Provider.of<Auth>(context, listen: false);
    try {
      final response =
          await _paytabsServices.getExistingTokens(auth.user.token);
      final tokens = json.decode(response) as List;
      print(tokens);
      paymentUrl = await _paytabsServices.createPaytabsPaymentPage(
          title:
              '${AppLocalizations.of(context).payForOrder} ${orderData['order_id']}',
          language: Localizations.localeOf(context).languageCode,
          amount: '${double.parse(orderData['order_price']) + double.parse(orderData['delivery_price'] ?? '0.0')}',
          ip: ipAddress,
          isTokenization: auth.appReviewed ? 'TRUE' : 'FALSE',
          customerPhoneNumber: auth.user.phone,
          ptCustomerEmail: tokens.length > 0 ? tokens.first['pt_customer_email'] : null,
          ptCustomerPassword: tokens.length > 0 ? tokens.first['pt_customer_password'] : null,
          ptToken: tokens.length > 0 ? tokens.first['pt_token'] : null,
          customerLastName: auth.user.username.split(' ').length > 1 ? auth.user.username.split(' ')[1] : auth.user.username,
          customerFirstName: auth.user.username.split(' ')[0],
          orderId: '${orderData['order_id']}',
          email: auth.user.email ?? '',
          otherCharges: orderData['delivery_price'],
          orderTitles: [
            "${AppLocalizations.of(context).orderFrom} ${orderData['restaurantName']}"
          ],
          quantities: [
            '1'
          ],
          unitPrices: [
            '${orderData['order_price']}'
          ]);
      print(paymentUrl);
    } on HttpException catch (error) {
      if (error.statusCode == 401) {
        auth.logoutDone();
      } else {
        showErrorDialog(context, error.toString());
      }
    } catch (error) {
      throw error;
    } finally {
      if (this.mounted)
        setState(() {
          gettingPaymentLink = false;
        });
    }
  }

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  bool gotPaymentLink = false;
  @override
  void didChangeDependencies() {
    if (!gotPaymentLink) {
      getPaymentLink();
      gotPaymentLink = true;
    }
    super.didChangeDependencies();
  }

  StreamSubscription xx;

  @override
  void initState() {
    xx = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains('payment_done')) Navigator.of(context).pop(true);
      // Navigator.popUntil(context, (route) => route.settings.name == '/main');
    });
    super.initState();
  }

  @override
  void dispose() {
    xx?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).payment),
      ),
      body: paymentUrl == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : WebviewScaffold(
              url: paymentUrl,
              hidden: true,
              appCacheEnabled: false,
              clearCookies: true,
              clearCache: true,
              withJavascript: true,
              withLocalStorage: true,
              withZoom: true,
              initialChild: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
//          : WebView(
//              gestureNavigationEnabled: false,
//              javascriptMode: JavascriptMode.unrestricted,
//              initialUrl: paymentUrl,
//              onPageFinished: (String url) {
//                print('pageFinished');
//                print(url);
//              },
//              onPageStarted: (String url) {
//                if (url.contains('$uri')) Navigator.of(context).pop(true);
//                print(url);
//              },
//              onWebViewCreated: (controller) {
//                print('created');
//              },
//              onWebResourceError: (error) {
//                print(error.description);
//              },
//            ),
//    );
  }
}
