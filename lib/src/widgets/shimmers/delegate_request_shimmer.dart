import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DelegateRequestShimmer extends StatelessWidget {
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
        padding: const EdgeInsets.only(top: 18),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 11, right: 20, left: 20),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 13.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 120.0,
                          height: 6.0,
                          color: Colors.white,
                        ),
                        Text(
                          'xx ${AppLocalizations.of(context).sar}',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF242C37),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                )),
            Divider(
              color: Colors.black.withOpacity(0.05),
              thickness: 1,
              height: 1.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          AppLocalizations.of(context).deliveryAddress,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 1.25,
                            fontSize: 15,
                            color: Color(0xFF242C37),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '  |  ',
                    style: TextStyle(
                        color: Color.fromARGB(255, 57, 186, 186),
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          AppLocalizations.of(context).receiveTheRequest,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 1.25,
                              fontSize: 14,
                              color: Color(0xFF242C37),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
