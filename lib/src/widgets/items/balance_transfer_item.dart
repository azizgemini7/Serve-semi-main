import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:flutter/material.dart';

class BalanceTransferItem extends StatelessWidget {
  final bool isIncome;

  final price;

  final String notes;

  final String createdAt;

  const BalanceTransferItem(
      {Key key, this.isIncome = false, this.price, this.notes, this.createdAt})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(isIncome
          ? AppLocalizations.of(context).incomeOrderDelivery
          : AppLocalizations.of(context).withdrawABalance),
      leading: Image.asset(
          'assets/images/${isIncome ? 'Withdraw' : 'Withdraw-1'}.png'),
      trailing: Text(
        '${(price ?? 0.0) > 0.0 ? '+ ${(price ?? 0.0)}' : (price ?? 0.0)}',
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            color: isIncome ? Color(0xFF00BC13) : Color(0xFFFF4267)),
      ),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(isIncome
              ? AppLocalizations.of(context).successful
              : (notes ?? '')),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            createdAt,
            style: TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
