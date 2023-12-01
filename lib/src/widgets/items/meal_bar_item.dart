import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MealBarItem extends StatelessWidget {
  final String name;
  final BuildContext context;
  final double price;
  final int calories;
  final String deliveryTime;
  final String description;
  final String photo;
  final int id;
  MealBarItem(
      {this.name,
      this.id,
      this.context,
      this.price,
      this.calories,
      this.photo,
      this.description,
      this.deliveryTime});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Color(0xFFFCFCFC).withOpacity(0.9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'restaurant-logo-$id',
            child: CircleAvatar(
              radius: 20.0,
              backgroundImage:
                  photo == null ? null : CachedNetworkImageProvider(photo),
            ),
          ),
          SizedBox(
            width: 13.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      price == null
                          ? ''
                          : '${price.toStringAsFixed(2)} ${AppLocalizations.of(context).sar}',
                      style: TextStyle(
                        color: Color(0xFF212C3A),
                        fontSize: 14.0,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    description ?? '',
                    style: TextStyle(fontSize: 11, color: Color(0xFF7E7E7E)),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '$calories',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12.0),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      ' (${AppLocalizations.of(context).calories})',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5), fontSize: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        ' | ',
                        style: TextStyle(
                            color: Color(0xFF707070).withOpacity(0.2)),
                      ),
                    ),
                    Text(
                      '$deliveryTime ${AppLocalizations.of(context).min}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12.0),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      ' (${AppLocalizations.of(context).deliveryTime})',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5), fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
