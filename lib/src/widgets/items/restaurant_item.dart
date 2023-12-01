import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RestaurantItem extends StatelessWidget {
  final String name;
  final bool isClosed;
  final String description;
  final int price;
  final double distance;
  final int deliveryTime;
  final int id;
  final String photoUrl;
  final double rating;

  final onTap;

  RestaurantItem(
      {this.name,
      this.isClosed,
      this.description,
      this.price,
      this.deliveryTime,
      this.distance,
      this.rating,
      this.photoUrl,
      this.onTap,
      this.id});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xFFFCFCFC).withOpacity(0.95),
        ),
        child: Row(
          children: <Widget>[
            Hero(
              tag: 'restaurant-logo-$id',
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: photoUrl == null
                    ? null
                    : CachedNetworkImageProvider(photoUrl),
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
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        height: 1.21052632),
                  ),
                  Text(
                    description ?? '',
                    style: TextStyle(
                        fontSize: 12, color: Color.fromARGB(255, 110, 110, 110), height: 1.83),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        deliveryTime != null && deliveryTime != 0
                            ? deliveryTime > 59
                                ? '$deliveryTime  ساعة'
                                : '$deliveryTime دقيقة'
                            : '',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            // color: Color.fromARGB(255, 57, 186, 186),
                            fontSize: 12.0,
                            height: 1.83),
                      ),
                      const SizedBox(
                        width: 4.0,
                        height: 7,
                      ),
                      // Text(
                      //   ' (${AppLocalizations.of(context).deliveryTime})',
                      //   style: TextStyle(
                      //       color: Colors.black.withOpacity(0.5),
                      //       fontSize: 10,
                      //       height: 1.83),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Text(
                      //     ' | ',
                      //     style: TextStyle(
                      //         color: Color(0xFF707070).withOpacity(0.2),
                      //         height: 1.83),
                      //   ),
                      // ),
                      Text(
                        '$price ${AppLocalizations.of(context).sar}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 57, 186, 186),
                            fontSize: 12.0,
                            height: 1.83),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        ' (${AppLocalizations.of(context).deliveryCost})',
                        style: TextStyle(
                            color: Color.fromARGB(255, 57, 186, 186),
                            fontSize: 10,
                            height: 1.83),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      '$rating' ?? '0.0',
                      style: TextStyle(
                          color: Color(0xFF212C3A),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'ProximaNova-Black'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (isClosed)
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.lock,
                        color: Colors.red,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(AppLocalizations.of(context).closed)
                    ],
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
