import 'dart:io';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/balance_transfer.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/balance.dart';
import 'package:Serve_ios/src/widgets/items/balance_transfer_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BalanceScreen extends StatefulWidget {
  static const routeName = '/balance';
  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> with AlertsMixin {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  bool _firstCalled = false;
  Future<void> _loadMore() async {
    await _getBalanceTransfers();
  }

  Future<void> _getBalanceTransfers([bool refresh = false]) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _balanceReference.getMyBalance(refresh);
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
        (_balanceReference?.balanceTransfers?.data?.length ?? 0) == 0)
      _getBalanceTransfers(true);
    super.didChangeDependencies();
  }

  Auth _authReference;
  Balance _balanceReference;

  @override
  void initState() {
    super.initState();
    _authReference = Provider.of<Auth>(context, listen: false);
    _balanceReference = Provider.of<Balance>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100.0 &&
          !_isLoading) {
        _loadMore();
      }
    });
  }

  Future<void> _refresh() async {
    await _getBalanceTransfers(true);
    _refreshController.refreshCompleted();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).balance),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SmartRefresher(
            primary: false,
            controller: _refreshController,
            onRefresh: _refresh,
            scrollController: _scrollController,
            header: WaterDropHeader(
              waterDropColor: Theme.of(context).accentColor,
              complete: Icon(Icons.check, color: Theme.of(context).accentColor),
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 120.0,
                  backgroundColor: Color(0xFFFBFBFB),
                  flexibleSpace: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).sar,
                        style: TextStyle(
                            fontSize: 8.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B6B6B)),
                      ),
                      Consumer<Balance>(
                        builder: (_, balance, __) => Text(
                          '${balance.balance ?? 0.0}',
                          style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        AppLocalizations.of(context).totalBalance,
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B6B6B)),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Consumer<Balance>(
                      builder: (_, balance, __) => ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10.0),
                        itemBuilder: (_, int i) => balance.balanceTransfers ==
                                null
                            ? Container()
                            : i == balance.balanceTransfers.data.length
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Center(
                                        child: balance.balanceTransfers
                                                    .lastPage ==
                                                balance.balanceTransfers
                                                    .currentPage
                                            ? Text(balance.balanceTransfers.data
                                                        .length ==
                                                    0
                                                ? AppLocalizations.of(context)
                                                    .noCurrentDelegateOrdersYet
                                                : AppLocalizations.of(context)
                                                    .noMoreResults)
                                            : Platform.isIOS
                                                ? CupertinoActivityIndicator()
                                                : CircularProgressIndicator()),
                                  )
                                : BalanceTransferItem(
                                    isIncome: (balance.balanceTransfers.data[i]
                                                as BalanceTransfer)
                                            .price >
                                        0,
                                    createdAt: (balance.balanceTransfers.data[i]
                                            as BalanceTransfer)
                                        .createdAt,
                                    notes: (balance.balanceTransfers.data[i]
                                            as BalanceTransfer)
                                        .notes,
                                    price: (balance.balanceTransfers.data[i]
                                            as BalanceTransfer)
                                        .price,
                                  ),
                        separatorBuilder: (_, __) => Divider(),
                        itemCount: balance.balanceTransfers == null
                            ? 3
                            : (balance.balanceTransfers?.data?.length ?? 0) + 1,
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
          if (_isLoading)
            Positioned(
              top: 0.0,
              height: 3.0,
              left: 0.0,
              right: 0.0,
              child: SizedBox(
                  height: 3.0,
                  width: double.infinity,
                  child: LinearProgressIndicator()),
            )
        ],
      ),
    );
  }
}
