import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/models/order.dart';
import 'package:Serve_ios/src/providers/orders.dart';
import 'package:Serve_ios/src/screens/order_tracking_map_screen.dart';
import 'package:Serve_ios/src/widgets/items/delivery_timeline_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:Serve_ios/src/providers/auth.dart';

class OrderTrackingScreen extends StatefulWidget {
  static const routeName = '/order-tracking';
  @override
  State<StatefulWidget> createState() {
    return _OrderTrackingScreen();
  }
}

class _OrderTrackingScreen extends State<OrderTrackingScreen> {
  static const routeName = '/order-tracking';
  @override
  Widget build(BuildContext context) {
    final int orderId = ModalRoute.of(context).settings.arguments as int;
    final ordersReference = Provider.of<Orders>(context, listen: false);
    if (orderId != null) {
      ordersReference.getOrderStatus(orderId);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).orderTracking),
      ),
      body: Consumer<Orders>(
        builder: (_, orders, __) {
          final Order myOrder = orders.myOrders.singleWhere(
              (element) => element.id == orderId,
              orElse: () => null);

          String resName;
          if (myOrder.restaurantName.isEmpty ||
              myOrder.restaurantName == null) {
            resName = 'المطعم';
          } else {
            resName = myOrder.restaurantName;
          }

          return CustomScrollView(
            slivers: <Widget>[
              if (orders.isGettingStatus)
                SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    SizedBox(
                      height: 3.0,
                      width: double.infinity,
                      child: LinearProgressIndicator(),
                    )
                  ]),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(30.0),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (_, int i) => i == myOrder.statusesDetailed.length
                            ? Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: !(myOrder.statusName.contains('منتهي') ||
                                        myOrder.statusName.contains('finish'))
                                    ? Container()
                                    : myOrder.rate != '-1'
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey[200]),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'تقييمك',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      RatingBar.builder(
                                                        initialRating:
                                                            double.parse(
                                                                myOrder.rate),
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        ignoreGestures: true,
                                                        itemCount: 5,
                                                        itemSize: 15,
                                                        itemPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    4.0),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          rate1 =
                                                              rating.round();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    myOrder.ratetext,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              return showDialog<void>(
                                                context: context,
                                                barrierDismissible:
                                                    false, // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  resName =
                                                      myOrder.restaurantName;
                                                  final rateAr = 'تقييم';
                                                  final rateRes =
                                                      rateAr + ' ' + resName;
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'أضف تقييمك'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(rateRes),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          RatingBar.builder(
                                                            initialRating: 1,
                                                            minRating: 1,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                false,
                                                            itemCount: 5,
                                                            itemSize: 25,
                                                            itemPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4.0),
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            onRatingUpdate:
                                                                (rating) {
                                                              rate1 = rating
                                                                  .round();
                                                            },
                                                          ),
                                                          TextFormField(
                                                            controller: review,
                                                            cursorColor:
                                                                Colors.amber,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'اكتب مراجعتك هنا',
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          Text('تقييم السائق'),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          RatingBar.builder(
                                                            initialRating: 1,
                                                            minRating: 1,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                false,
                                                            itemCount: 5,
                                                            itemSize: 25,
                                                            itemPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4.0),
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            onRatingUpdate:
                                                                (rating) {
                                                              rate2 = rating
                                                                  .round();
                                                            },
                                                          ),
                                                          TextFormField(
                                                            controller: review2,
                                                            cursorColor:
                                                                Colors.amber,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'اكتب مراجعتك هنا',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child:
                                                            const Text('إرسال'),
                                                        onPressed: () async {
                                                          var response23 =
                                                              await http.post(
                                                                  Uri.parse(
                                                                      'https://lazah.net/api/v1/add-review'),
                                                                  body: {
                                                                'order_id': myOrder
                                                                    .id
                                                                    .toString(),
                                                                'restaurant_stars':
                                                                    rate1
                                                                        .toString(),
                                                                'restaurant_txt': review
                                                                        .text
                                                                        .trim()
                                                                        .isEmpty
                                                                    ? ''
                                                                    : review
                                                                        .text,
                                                                'driver_stars':
                                                                    rate2
                                                                        .toString(),
                                                                'driver_txt': review2
                                                                        .text
                                                                        .trim()
                                                                        .isEmpty
                                                                    ? ''
                                                                    : review2
                                                                        .text,
                                                                'user_id': Provider.of<
                                                                            Auth>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    ?.userId,
                                                              },
                                                                  headers: {
                                                                'Authorization':
                                                                    'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
                                                                'Accept-Language':
                                                                    'ar'
                                                              });
                                                          myOrder.rate =
                                                              rate1.toString();
                                                          myOrder.ratetext =
                                                              review.text;
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child:
                                                            const Text('إلغاء'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Center(
                                              child: Container(
                                                width: 140,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.grey[200],
                                                    boxShadow:
                                                        kElevationToShadow[1]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'أضف تقييمك',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Image.asset(
                                                      'assets/images/rating.png',
                                                      height: 30,
                                                      color: Colors.amber,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                              )
                            : DeliveryTimelineItem(
                                isActive:
                                    myOrder.statusesDetailed[i].active ?? false,
                                isLast:
                                    i == myOrder.statusesDetailed.length - 1,
                                isNext: i == 0 ||
                                    (i != 0 &&
                                        myOrder.statusesDetailed[i - 1].active),
                                statusDescription:
                                    myOrder.statusesDetailed[i].id == 0
                                        ? 'تم ارسال الطلب إلى $resName '
                                        : myOrder
                                            .statusesDetailed[i].description,
                                status: myOrder.statusesDetailed[i].id,
                                onStartTrackingClicked: myOrder
                                                .statusesDetailed[i].id ==
                                            3 &&
                                        myOrder.statusesDetailed[i].active &&
                                        (!myOrder.statusesDetailed
                                            .singleWhere(
                                                (element) => element.id == 5)
                                            .active) &&
                                        (!myOrder.statusesDetailed
                                            .singleWhere(
                                                (element) => element.id == 4)
                                            .active)
                                    ? () {
                                        Navigator.of(context).pushNamed(
                                            OrderTrackingMapScreen.routeName,
                                            arguments: {'order': myOrder});
                                      }
                                    : null,
                                statusName: myOrder.statusesDetailed[i].name,
                              ),
                        childCount: myOrder.statusesDetailed.length + 1)),
              ),
            ],
          );
        },
      ),
    );
  }

  TextEditingController review = new TextEditingController();
  TextEditingController review2 = new TextEditingController();
  int rate1 = 1;
  int rate2 = 1;
}
