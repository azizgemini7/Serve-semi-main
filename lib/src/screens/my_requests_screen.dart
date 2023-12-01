import 'dart:io';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/orders.dart';
import 'package:Serve_ios/src/screens/home_screen.dart';
import 'package:Serve_ios/src/screens/main_screen.dart';
import 'package:Serve_ios/src/screens/registration_screen.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:Serve_ios/src/widgets/request_widget.dart';
import 'package:Serve_ios/src/widgets/shimmers/restaurant_item_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyRequestsScreen extends StatefulWidget {
  static const routeName = '/my-requests';

  @override
  _MyRequestsScreenState createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> with AlertsMixin {
  Future<void> _fetchMyOrders([int page]) async {
    try {
      await Provider.of<Orders>(context, listen: false).fetchMyOrders(page);
    } on HttpException catch (e) {
      if (this.mounted) showErrorDialog(context, e.toString());
    } catch (e) {
      rethrow;
    }
  }

  Orders _ordersReference;
  bool calledMyOrders = false;

  @override
  void didChangeDependencies() {
    //'https://ps.w.org/replace-broken-images/assets/icon-256x256.png?rev=2561727'
    print("Called:: my_requests_screen::");
    _ordersReference = Provider.of<Orders>(context);
    if (!calledMyOrders && _ordersReference.user != null) {
      Future.delayed(Duration(milliseconds: 10), () {
        _fetchMyOrders(1);
      });
      calledMyOrders = true;
    }
    super.didChangeDependencies();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final ScrollController _scrollController = ScrollController();
  Future<void> _refresh() async {
    await _ordersReference.fetchMyOrders(1);
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100.0 &&
          !_ordersReference.isLoading) {
        if (_ordersReference.user != null) _fetchMyOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context).settings.arguments ?? {}) as Map;
    return Scaffold(
      appBar: (args['isFromNotifications'] ?? false)
          ? AppBar(
            leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(MainScreen.routeName);
          }),
              title: Text(AppLocalizations.of(context).myRequests),
            )
          : null,
      body: SmartRefresher(
        primary: false,
        controller: _refreshController,
        onRefresh: _refresh,
        scrollController: _scrollController,
        header: WaterDropHeader(
          waterDropColor: Theme.of(context).accentColor,
          complete: Icon(Icons.check, color: Theme.of(context).accentColor),
        ),
        child: _ordersReference.user == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.grey,
                    size: 80.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    AppLocalizations.of(context).pleaseLoginFirst,
                    style: TextStyle(
                        fontSize: 16.0, color: Theme.of(context).accentColor),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 150.0,
                        child: MyCustomFormButton(
                          backgroundColor: Theme.of(context).accentColor,
                          onPressedEvent: () {
                            Navigator.of(context)
                                .pushNamed(RegistrationScreen.routeName);
                          },
                          buttonText: AppLocalizations.of(context).login,
                        ),
                      ),
                    ],
                  )
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: _ordersReference.myOrders.length == 0 &&
                        _ordersReference.isLoading
                    ? 5
                    : _ordersReference.myOrders.length + 1,
                separatorBuilder: (_, i) => SizedBox(
                  height: 10,
                ),
                itemBuilder: (_, i) => _ordersReference.myOrders.length == 0 &&
                        _ordersReference.isLoading
                    ? RestaurantItemShimmer()
                    : i == _ordersReference.myOrders.length
                        ? (_ordersReference.currentPage >=
                                _ordersReference.ordersPagesCount
                            ? Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                        _ordersReference.myOrders.length == 0
                                            ? AppLocalizations.of(context)
                                                .noResultsFound
                                            : AppLocalizations.of(context)
                                                .noMoreResults)),
                              )
                            : Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Platform.isIOS
                                      ? CupertinoActivityIndicator()
                                      : CircularProgressIndicator(),
                                )))
                        : RequestWidget(
                            order: _ordersReference.myOrders[i],
                          ),
              ),
      ),
    );
  }
}
