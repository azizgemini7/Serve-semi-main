import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/providers/orders.dart';
import 'package:Serve_ios/src/screens/tabs/delegate_current_orders.dart';
import 'package:Serve_ios/src/screens/tabs/delegate_finished_orders.dart';
import 'package:Serve_ios/src/screens/tabs/delegate_new_orders.dart';
import 'package:Serve_ios/src/widgets/dialogs/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class DeliveryRequestsScreen extends StatefulWidget {
  static const routeName = '/delivery-requests';
  @override
  _DeliveryRequestsScreenState createState() => _DeliveryRequestsScreenState();
}

class _DeliveryRequestsScreenState extends State<DeliveryRequestsScreen> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(text: AppLocalizations.of(context).newWord),
              Tab(text: AppLocalizations.of(context).current),
              Tab(text: AppLocalizations.of(context).finished),
            ]),
            title: Text(AppLocalizations.of(context).deliveryRequests)),
        body: Selector<Orders, bool>(
          selector: (_, orders) => orders.isMakingRequest,
          builder: (_, isMakingRequest, child) => ModalProgressHUD(
            progressIndicator:
                LoadingDialog(AppLocalizations.of(context).pleaseWait),
            inAsyncCall: isMakingRequest,
            child: child,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter ss) => TabBarView(
              children: [
                DelegateNewOrders(),
                DelegateCurrentOrders(),
                DelegateFinishedOrders(),
              ],
            ),
          ),
        ),
      ),
      length: 3,
      initialIndex: 0,
    );
  }
}
