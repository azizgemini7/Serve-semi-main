import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  static const routeName = '/payment-method';

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _radioVal = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).paymentMethod),
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).paymentMethod,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).creditCard,
                      style: TextStyle(
                          letterSpacing: -0.26,
                          color: Color(0xFF091337),
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    Radio(
                      activeColor: Color(0xFF222627),
                      value: 0,
                      groupValue: _radioVal,
                      onChanged: (val) {
                        setState(() {
                          _radioVal = val;
                        });
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context).payOnDelivery,
                      style: TextStyle(
                          letterSpacing: -0.26,
                          color: Color(0xFF091337),
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    Radio(
                      activeColor: Color(0xFF222627),
                      value: 1,
                      groupValue: _radioVal,
                      onChanged: (val) {
                        setState(() {
                          _radioVal = val;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Text(
                    AppLocalizations.of(context).cardholderName,
                    style: TextStyle(
                        color: Color(0xFF1A1A1A).withOpacity(0.7),
                        letterSpacing: -0.11,
                        fontSize: 12),
                  ),
                ),
                MyCustomInput(
                  prefixIcon: Icon(
                    MyCustomIcons.id,
                    size: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Text(
                    AppLocalizations.of(context).cardNumber,
                    style: TextStyle(
                        color: Color(0xFF1A1A1A).withOpacity(0.7),
                        letterSpacing: -0.11,
                        fontSize: 12),
                  ),
                ),
                MyCustomInput(
                  prefixIcon: Icon(
                    MyCustomIcons.id,
                    size: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Text(
                              AppLocalizations.of(context).expiryDate,
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A).withOpacity(0.7),
                                  letterSpacing: -0.11,
                                  fontSize: 12),
                            ),
                          ),
                          Container(
                            child: MyCustomInput(
                              prefixIcon: Icon(
                                MyCustomIcons.id,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Text(
                              AppLocalizations.of(context).cvv,
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A).withOpacity(0.7),
                                  letterSpacing: -0.11,
                                  fontSize: 12),
                            ),
                          ),
                          MyCustomInput(
                            prefixIcon: Icon(
                              MyCustomIcons.id,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
