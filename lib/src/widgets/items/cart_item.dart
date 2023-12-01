import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/screens/complete_order_screen.dart';
import 'package:Serve_ios/src/screens/registration_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String name;
  final String category;
  final int restaurantId;
  final String photo;

  final String ordersCount;

  const CartItem(
      {Key key,
      this.name,
      this.category,
      this.photo,
      this.ordersCount,
      this.restaurantId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return InkWell(
      onTap: () {

       
        
        if (auth.isAuth)
          Navigator.of(context).pushNamed(CompleteOrderScreen.routeName,
              arguments: {'restaurantId': restaurantId});
        else
          Navigator.of(context).pushNamed(RegistrationScreen.routeName);
      },
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xFFFCFCFC),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      height: 15.0,
                      alignment: Alignment.center,
                      constraints: BoxConstraints(minWidth: 15.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).accentColor),
                      child: Text(
                        '${ordersCount ?? 1}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundImage: CachedNetworkImageProvider(photo),
            ),
            SizedBox(
              width: 13,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                      color: Color(0xDE000000)),
                ),
                Text(
                  category ?? '',
                  style: TextStyle(fontSize: 12, color: Color(0xFF7E7E7E)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
