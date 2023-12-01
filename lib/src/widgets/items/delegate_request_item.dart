import 'dart:io';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/order.dart';
import 'package:Serve_ios/src/models/order_for_delegate.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/maps.dart';
import 'package:Serve_ios/src/providers/orders.dart';
import 'package:Serve_ios/src/screens/chatscreen.dart';
import 'package:Serve_ios/src/screens/delivery_location_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:provider/provider.dart';

class DelegateRequestItem extends StatelessWidget with AlertsMixin {
  final String name;

  final DelegateOrderType delegateOrderType;
  final totalPrice;
  final int id;
  final int orderStatus;
  final Location storeLocation;
  final Location clientLocation;
  final OrderForDelegate order;
  final List<products> myprod;
  final String photo;

  DelegateRequestItem(
      {Key key,
      this.myprod,
      this.name,
      this.totalPrice,
      this.photo,
      this.delegateOrderType,
      this.id,
      this.orderStatus,
      this.storeLocation,
      this.clientLocation,
      this.order})
      : super(key: key);

  Future<void> _deliverOrder(BuildContext context) async {
    try {
      final xx = await Provider.of<Orders>(context, listen: false).deliverOrder(
          id,
          delegateOrderType,
          ccc.text.trim().isEmpty ? '-1' : ccc.text.trim());
      AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.SUCCES,
        body: Center(
          child: Text(
            AppLocalizations.of(context)
                .youConfirmedDeliveringTheOrderSuccessfully,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkText: AppLocalizations.of(context).ok,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        btnOkOnPress: () {},
        btnOkColor: Theme.of(context).accentColor,
      )..show();
    } on HttpException catch (error) {
      if (error.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).logoutDone();
      } else {
        showErrorDialog(context, error.toString());
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _receiveRequest(BuildContext context) async {
    try {
      final xx = await Provider.of<Orders>(context, listen: false)
          .receiveRequest(id, delegateOrderType);

      AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.SUCCES,
        body: Center(
          child: Text(
            AppLocalizations.of(context).youHaveReceivedThisOrderSuccessfully,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkText: AppLocalizations.of(context).ok,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        btnOkOnPress: () {},
        btnOkColor: Theme.of(context).accentColor,
      )..show();
    } on HttpException catch (error) {
      if (error.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).logoutDone();
      } else {
        showErrorDialog(context, error.toString());
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _takeOrder(BuildContext context) async {
    try {
      final xx = await Provider.of<Orders>(context, listen: false)
          .takeOrder(id, delegateOrderType);
      AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.SUCCES,
        body: Center(
          child: Text(
            AppLocalizations.of(context).youConfirmedTakingOrderSuccessfully,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkText: AppLocalizations.of(context).ok,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        btnOkOnPress: () {
          Provider.of<MapsProvider>(context, listen: false)
              .startLocationSharing();
        },
        onDismissCallback: (type) {
          print('dismissed');
          Provider.of<MapsProvider>(context, listen: false)
              .startLocationSharing();
        },
        btnOkColor: Theme.of(context).accentColor,
      )..show();
    } on HttpException catch (error) {
      if (error.statusCode == 401) {
        Provider.of<Auth>(context, listen: false).logoutDone();
      } else {
        showErrorDialog(context, error.toString());
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("totalPrice:: " + totalPrice);
        showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).orderdetails,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[100],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: order.details.toString().length > 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Icon(Icons.info),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                order.details.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: totalPrice > 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.money),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of(context).subTotal,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                            Text(
                              totalPrice.toString() +
                                  ' ' +
                                  AppLocalizations.of(context).sar,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    order.myproducts.length == 0
                        ? Padding(
                            padding:
                                EdgeInsets.only(top: 50, left: 10, right: 10),
                            child: Text(
                              AppLocalizations.of(context).noprod,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ))
                        : SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                  order.myproducts.length,
                                  (index) => Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .productname,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    AppLocalizations.of(context)
                                                            .isArabic
                                                        ? order
                                                            .myproducts[index]
                                                            .title
                                                        : order
                                                            .myproducts[index]
                                                            .title_en,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .fprice,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    order.myproducts[index]
                                                            .price +
                                                        ' ' +
                                                        AppLocalizations.of(
                                                                context)
                                                            .sar,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .countt,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    order.myproducts[index]
                                                        .quantity,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .subTotal,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    order.myproducts[index]
                                                            .final_price +
                                                        ' ' +
                                                        AppLocalizations.of(
                                                                context)
                                                            .sar,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                            ),
                          )
                    // final String name;
                    //
                    // final DelegateOrderType delegateOrderType;
                    // final totalPrice;
                    // final int id;
                    // final int orderStatus;
                    // final Location storeLocation;
                    // final Location clientLocation;
                    // final OrderForDelegate order;
                  ],
                ),
              );
            });
      },
      child: Container(
        padding: const EdgeInsets.only(top: 18),
        decoration: BoxDecoration(
            color: Color(0xFFFCFCFC), borderRadius: BorderRadius.circular(6.0)),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 11, right: 20, left: 20),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider('$photo' ??
                          'https://bitsofco.de/content/images/2018/12/broken-1.png'),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 13.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name != null ? name : ' ',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0x80000000)),
                        ),
                        Text(
                          '$totalPrice ${AppLocalizations.of(context).sar}',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF242C37),
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context).orderdate,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF242C37),
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              order.date,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF242C37),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Visibility(
                      visible: order != null && order.orderStatus == 2,
                      child: InkWell(
                        onTap: () {
                          print(
                              Provider.of<Auth>(context, listen: false).userId);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Chatscreen(
                                  orderid: order.orderId.toString(),
                                  userid:
                                      Provider.of<Auth>(context, listen: false)
                                          .userId
                                          .toString(),
                                  deliverlat: order.deliverLatitude,
                                  deliverlong: order.deliverLongitude,
                                ),
                              ));
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.message),
                        ),
                      ),
                    )
                  ],
                )),
            Divider(
              color: Colors.black.withOpacity(0.05),
              thickness: 1,
              height: 1.0,
            ),
            if (delegateOrderType != DelegateOrderType.Finished)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              DeliveryLocationScreen.routeName,
                              arguments: {'order': order});
                        },
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
                        onTap: () {
                          ccc.clear();
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.BOTTOMSLIDE,
                            dialogType: DialogType.NO_HEADER,
                            body: Center(
                              child: (delegateOrderType ==
                                          DelegateOrderType.Current &&
                                      orderStatus == 2)
                                  ? Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            delegateOrderType ==
                                                    DelegateOrderType.New
                                                ? AppLocalizations.of(context)
                                                    .areYouSureYouWantToReceiveThisRequest
                                                : delegateOrderType ==
                                                        DelegateOrderType
                                                            .Current
                                                    ? orderStatus == 2
                                                        ? AppLocalizations.of(
                                                                context)
                                                            .haveYouDeliveredThisOrder
                                                        : AppLocalizations.of(
                                                                context)
                                                            .haveYouDeliveredThisOrder
                                                    : '',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          totalPrice.toString() == '0.0'
                                              ? TextField(
                                                  controller: ccc,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey[100],
                                                      border: InputBorder.none,
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)
                                                              .subTotal),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    )
                                  : Text(
                                      delegateOrderType == DelegateOrderType.New
                                          ? AppLocalizations.of(context)
                                              .areYouSureYouWantToReceiveThisRequest
                                          : delegateOrderType ==
                                                  DelegateOrderType.Current
                                              ? orderStatus == 2
                                                  ? AppLocalizations.of(context)
                                                      .haveYouDeliveredThisOrder
                                                  : AppLocalizations.of(context)
                                                      .haveYouDeliveredThisOrder
                                              : '',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                            ),
                            title: 'This is Ignored',
                            desc: 'This is also Ignored',
                            btnCancelColor:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                            btnOkText: AppLocalizations.of(context).yes,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            btnOkColor: Theme.of(context).accentColor,
                            btnCancelText: AppLocalizations.of(context).cancel,
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              if (delegateOrderType == DelegateOrderType.New)
                                _receiveRequest(context);
                              else if (delegateOrderType ==
                                  DelegateOrderType.Current) {
                                if (orderStatus == 2) {
                                  if (totalPrice.toString() == '0.0' &&
                                      ccc.text.trim().isEmpty)
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) =>
                                          Platform.isIOS
                                              ? CupertinoAlertDialog(
                                                  content: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .adddetails),
                                                  actions: <Widget>[
                                                    CupertinoDialogAction(
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .ok),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        isDefaultAction: true)
                                                  ],
                                                )
                                              : AlertDialog(
                                                  content: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .adddetails),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .ok),
                                                    ),
                                                  ],
                                                ),
                                    );
                                  else
                                    _deliverOrder(context);
                                }
                              }
                            },
                          )..show();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            delegateOrderType == DelegateOrderType.New
                                ? AppLocalizations.of(context).receiveTheRequest
                                : delegateOrderType == DelegateOrderType.Current
                                    ? orderStatus == 2
                                        ? AppLocalizations.of(context).takeOrder
                                        : AppLocalizations.of(context)
                                            .deliverOrder
                                    : '',
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

  TextEditingController ccc = new TextEditingController();
}
