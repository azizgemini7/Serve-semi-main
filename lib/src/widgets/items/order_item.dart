import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/providers/cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderItem extends StatelessWidget {
  final String name;
  final String cost;
  final int restaurantId;
  final int mealId;
  final String photo;

  final bool isLast;

  final String cartItemId;

  const OrderItem(
      {Key key,
      this.name,
      this.cost,
      this.photo,
      this.restaurantId,
      this.mealId,
      this.isLast,
      this.cartItemId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 13,
            backgroundColor: Colors.white,
            backgroundImage: CachedNetworkImageProvider(photo),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0x80000000)),
          ),
          Spacer(),
          Text(
            '$cost ${AppLocalizations.of(context).sar}',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF242C37)),
          ),
          SizedBox(
            width: 28,
          ),
          GestureDetector(
            child: Icon(
              MyCustomIcons.delete,
              size: 16,
              color: Colors.red,
            ),
            onTap: () {
              Provider.of<Cart>(context, listen: false).removeMeal(cartItemId);
              if (isLast) Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
