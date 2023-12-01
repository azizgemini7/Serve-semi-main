import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantCategoryItemShimmer extends StatelessWidget {
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color.fromARGB(255, 57, 186, 186))),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  right: AppLocalizations.of(context).isArabic ? 0.0 : 14.0,
                  left: AppLocalizations.of(context).isArabic ? 14.0 : 0.0),
              child: Icon(
                Icons.check,
              ),
            ),
            Container(
              width: 100.0,
              height: 6.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
