import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RestaurantMealItem extends StatelessWidget {
  final onTap;
  final bool isForOrder;
  final int id;

  final String title;

  final String price;

  final String description;
  final String photo;
  RestaurantMealItem(
      {this.isForOrder = false,
      this.onTap,
      this.id,
      this.title,
      this.price,
      this.description,
      this.photo});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xFFFCFCFC),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'meal-photo-$id',
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.0,
                  backgroundImage:
                      photo == null ? null : CachedNetworkImageProvider(photo),
                ),
              ),
              SizedBox(
                width: 13,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              title ?? '',
                              style: TextStyle(
                                  fontSize: isForOrder ? 21 : 17,
                                  color: Color(0xDE000000),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          Text(
                            '$price ${AppLocalizations.of(context).sar}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF212C3A),
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      description ?? '',
                      style: TextStyle(fontSize: 12, color: Color(0xFF7E7E7E)),
                    ),
                    SizedBox(
                      height: isForOrder ? 7 : 0,
                    ),
                    isForOrder
                        ? Row(
                            children: <Widget>[
                              Text(
                                '10',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ' (${AppLocalizations.of(context).calories})',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 12),
                              ),
                              Text(
                                ' | ',
                                style: TextStyle(
                                    color: Color(0xFF707070).withOpacity(0.2)),
                              ),
                              Text(
                                '30 ${AppLocalizations.of(context).min}',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ' (${AppLocalizations.of(context).deliveryTime})',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 12),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
