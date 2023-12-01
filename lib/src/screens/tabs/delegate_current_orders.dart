import 'dart:io';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/order_for_delegate.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/maps.dart';
import 'package:Serve_ios/src/providers/orders.dart';
import 'package:Serve_ios/src/widgets/items/delegate_request_item.dart';
import 'package:Serve_ios/src/widgets/shimmers/delegate_request_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../chatscreen.dart';

class DelegateCurrentOrders extends StatefulWidget {
  @override
  _DelegateCurrentOrdersState createState() => _DelegateCurrentOrdersState();
}

class _DelegateCurrentOrdersState extends State<DelegateCurrentOrders>
    with AlertsMixin {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  bool _firstCalled = false;
  Future<void> _loadMore() async {
    await _getDelegateCurrentOrders();
  }

  Future<void> _getDelegateCurrentOrders([bool refresh = false]) async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool shouldBeSharingLocation =
          await _ordersReference.getDelegateCurrentOrders(refresh);
      if (shouldBeSharingLocation) {
        final maps = Provider.of<MapsProvider>(context, listen: false);
        if (maps.locationSubscription == null) maps.startLocationSharing();
      }
    } on HttpException catch (error) {
      if (error.statusCode == 401) {
        _authReference.logoutDone();
      } else {
        showErrorDialog(context, error.toString());
      }
    } catch (error) {
      throw error;
    } finally {
      if (this.mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  void didChangeDependencies() {
    if (!_firstCalled &&
        (_ordersReference?.delegateCurrentOrders?.data?.length ?? 0) == 0)
      _getDelegateCurrentOrders(true);
    super.didChangeDependencies();
  }

  Auth _authReference;
  Orders _ordersReference;

  @override
  void initState() {
    super.initState();
    _authReference = Provider.of<Auth>(context, listen: false);
    _ordersReference = Provider.of<Orders>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100.0 &&
          !_isLoading) {
        _loadMore();
      }
    });
  }

  Future<void> _refresh() async {
    await _getDelegateCurrentOrders(true);
    _refreshController.refreshCompleted();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      primary: false,
      controller: _refreshController,
      onRefresh: _refresh,
      scrollController: _scrollController,
      header: WaterDropHeader(
        waterDropColor: Theme.of(context).accentColor,
        complete: Icon(Icons.check, color: Theme.of(context).accentColor),
      ),
      child: Consumer<Orders>(
        builder: (_, orders, __) => ListView.separated(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) => orders.delegateCurrentOrders == null
              ? DelegateRequestShimmer()
              : i == orders.delegateCurrentOrders.data.length
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                          child: orders.delegateCurrentOrders.lastPage ==
                                  orders.delegateCurrentOrders.currentPage
                              ? Text(orders.delegateCurrentOrders.data.length ==
                                      0
                                  ? AppLocalizations.of(context)
                                      .noCurrentDelegateOrdersYet
                                  : AppLocalizations.of(context).noMoreResults)
                              : Platform.isIOS
                                  ? CupertinoActivityIndicator()
                                  : CircularProgressIndicator()),
                    )
                  : InkWell(
                      onTap: () {
                        print(orders.delegateCurrentOrders.data[i]);
                      },
                      child: DelegateRequestItem(
                        name: (orders.delegateCurrentOrders.data[i]
                                as OrderForDelegate)
                            .restaurantName,
                        order: orders.delegateCurrentOrders.data[i],
                        clientLocation: Location(
                            (orders.delegateCurrentOrders.data[i]
                                    as OrderForDelegate)
                                .deliverLatitude,
                            (orders.delegateCurrentOrders.data[i]
                                    as OrderForDelegate)
                                .deliverLongitude),
                        storeLocation: Location(
                            (orders.delegateCurrentOrders.data[i]
                                    as OrderForDelegate)
                                .restaurantLatitude,
                            (orders.delegateCurrentOrders.data[i]
                                    as OrderForDelegate)
                                .restaurantLongitude),
                        orderStatus: (orders.delegateCurrentOrders.data[i]
                                as OrderForDelegate)
                            .orderStatus,
                        id: (orders.delegateCurrentOrders.data[i]
                                as OrderForDelegate)
                            .orderId,
                        delegateOrderType: DelegateOrderType.Current,
                        photo: (orders.delegateCurrentOrders.data[i]
                                as OrderForDelegate)
                            .restaurantPhoto,
                        totalPrice: (orders.delegateCurrentOrders.data[i]
                                as OrderForDelegate)
                            .deliveryPrice,
                      ),
                    ),
          separatorBuilder: (_, __) => const SizedBox(
            height: 10.0,
          ),
          itemCount: orders.delegateCurrentOrders == null
              ? 3
              : (orders.delegateCurrentOrders?.data?.length ?? 0) + 1,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
