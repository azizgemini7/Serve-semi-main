import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RestaurantBarItem extends StatelessWidget {
  final String name;
  final BuildContext context;
  final int price;
  final double distance;
  final int delivery_time;
  final String restaurantCategory;
  final String logo;
  final int id;
  final double rate;
  RestaurantBarItem(
      {this.name,
      this.id,
      this.rate,
      this.context,
      this.price,
      this.distance,
      this.delivery_time,
      this.logo,
      this.restaurantCategory});

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
                  logo == null ? null : CachedNetworkImageProvider(logo),
            ),
          ),
          SizedBox(
            width: 13.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                ),
                Text(
                  restaurantCategory ?? '',
                  style: TextStyle(
                      fontSize: 14, color: Color(0xFF7E7E7E), height: 1.83),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '${distance?.toStringAsFixed(2)} ${AppLocalizations.of(context).km}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          height: 1.50),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        ' | ',
                        style: TextStyle(
                            color: Color(0xFF707070).withOpacity(0.2),
                            height: 1.50),
                      ),
                    ),
                    Text(
                      '$price ${AppLocalizations.of(context).sar}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          height: 1.50),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      ' (${AppLocalizations.of(context).deliveryCost})',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 10,
                          height: 1.50),
                    ),
                    delivery_time != null && delivery_time != 0
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 4),
                            child: Text(
                              ' | ',
                              style: TextStyle(
                                  color: Color(0xFF707070).withOpacity(0.2),
                                  height: 1.50),
                            ),
                          )
                        : Text(''),
                    Text(
                      delivery_time != null && delivery_time != 0
                          ? delivery_time > 59
                              ? '$delivery_time  ساعة'
                              : '$delivery_time دقيقة'
                          : '',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          height: 1.50),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    delivery_time != null && delivery_time != 0
                        ? Text(
                            ' (${AppLocalizations.of(context).deliveryTime})',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 10,
                                height: 1.50),
                          )
                        : Text(''),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 57, 186, 186),
                    size: 20,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    rate.toString(),
                    style: TextStyle(
                        color: Color(0xFF212C3A),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'ProximaNova-Black'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
