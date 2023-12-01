import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      direction: AppLocalizations.of(context).isArabic
          ? ShimmerDirection.rtl
          : ShimmerDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(),
            SizedBox(
              width: 13.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200.0,
                  height: 8.0,
                  color: Colors.white,
                ),
                Container(
                  width: 100.0,
                  height: 6.0,
                ),
              ],
            ),
            Spacer(),
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
                      '5.0',
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
