import 'dart:io';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/order_for_delegate.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/orders.dart';
import 'package:Serve_ios/src/widgets/items/delegate_request_item.dart';
import 'package:Serve_ios/src/widgets/shimmers/delegate_request_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DelegateNewOrders extends StatefulWidget {
  @override
  _DelegateNewOrdersState createState() => _DelegateNewOrdersState();
}

class _DelegateNewOrdersState extends State<DelegateNewOrders>
    with AlertsMixin {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  bool _firstCalled = false;
  Future<void> _loadMore() async {
    await _getDelegateOrders();
  }

  Future<void> _getDelegateOrders([bool refresh = false]) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _ordersReference.getDelegateNewOrders(refresh);
    } on HttpException catch (error) {
      if (error.statusCode == 401) {
        _authReference.logoutDone();
      } else {
        showErrorDialog(context, error.toString());
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      return throw error;
    } finally {
      if (this.mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  void didChangeDependencies() {
    _refresh();
    if (!_firstCalled &&
        (_ordersReference?.delegateNewOrders?.data?.length ?? 0) == 0)
      _getDelegateOrders();
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
    await _getDelegateOrders(true)
        .then((value) => {_refreshController.refreshCompleted()});
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
          itemBuilder: (_, i) => orders.delegateNewOrders == null
              ? DelegateRequestShimmer()
              : i == orders.delegateNewOrders.data.length
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                          child: orders.delegateNewOrders.lastPage ==
                                  orders.delegateNewOrders.currentPage
                              ? Text(orders.delegateNewOrders.data.length == 0
                                  ? AppLocalizations.of(context)
                                      .noNewDelegateOrdersYet
                                  : AppLocalizations.of(context).noMoreResults)
                              : Platform.isIOS
                                  ? CupertinoActivityIndicator()
                                  : CircularProgressIndicator()),
                    )
                  : DelegateRequestItem(
                      name:
                          (orders.delegateNewOrders.data[i] as OrderForDelegate)
                              .restaurantName,
                      order: orders.delegateNewOrders.data[i],
                      orderStatus:
                          (orders.delegateNewOrders.data[i] as OrderForDelegate)
                              .orderStatus,
                      id: (orders.delegateNewOrders.data[i] as OrderForDelegate)
                          .orderId,
                      delegateOrderType: DelegateOrderType.New,
                      photo:
                          (orders.delegateNewOrders.data[i] as OrderForDelegate)
                              .restaurantPhoto,
                      totalPrice:
                          (orders.delegateNewOrders.data[i] as OrderForDelegate)
                              .deliveryPrice,
                    ),
          separatorBuilder: (_, __) => const SizedBox(
            height: 10.0,
          ),
          itemCount: orders.delegateNewOrders == null
              ? 3
              : (orders.delegateNewOrders?.data?.length ?? 0) + 1,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
