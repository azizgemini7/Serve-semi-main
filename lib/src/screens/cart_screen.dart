import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/models/cart_restaurant.dart';
import 'package:Serve_ios/src/providers/cart.dart';
import 'package:Serve_ios/src/widgets/items/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).yourCart,
          style: TextStyle(
              color: Color(0xDE000000),
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.26),
        ),
        elevation: 1,
      ),
      body: Selector<Cart, List<CartRestaurant>>(
        selector: (_, cart) => cart.getCartItemsForEachRestaurant(),
        builder: (_, cartItems, __) => cartItems.length == 0
            ? Center(
                child: Text(AppLocalizations.of(context).yourCartIsEmpty),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: cartItems.length,
                itemBuilder: (_, i) => CartItem(
                  name: cartItems[i].restaurant.title,
                  ordersCount: cartItems[i].mealsCount?.toString(),
                  category: cartItems[i].restaurant.description,
                  restaurantId: cartItems[i].restaurant.id,
                  photo: cartItems[i].restaurant.logo,
                ),
                separatorBuilder: (_, i) => SizedBox(
                  height: 10,
                ),
              ),
      ),
    );
  }
}
