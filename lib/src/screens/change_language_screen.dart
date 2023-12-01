import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/screens/complete_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePaymentMethodScreen extends StatelessWidget {
  static const routeName = '/change-payment-method';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).paymentMethod),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Consumer<Addresses>(
          builder: (_, addresses, __) => Column(
            children: <Widget>[
              RadioListTile(
                value: PaymentType.Cash,
                onChanged: (PaymentType type) {
                  addresses.changePaymentType(type);
                },
                groupValue: addresses.paymentType,
                activeColor: Theme.of(context).primaryColor,
                title: Text(AppLocalizations.of(context).cash),
              ),
              RadioListTile(
                value: PaymentType.Online,
                onChanged: (PaymentType type) {
                  addresses.changePaymentType(type);
                },
                groupValue: addresses.paymentType,
                activeColor: Theme.of(context).primaryColor,
                title: Text(AppLocalizations.of(context).onlinePayment),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
