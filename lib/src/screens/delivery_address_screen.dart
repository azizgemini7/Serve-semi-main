import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/address.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/screens/add_location_screen.dart';
import 'package:Serve_ios/src/screens/choose_location_screen.dart';
import 'package:Serve_ios/src/screens/home_screen.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:Serve_ios/src/widgets/items/address_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DeliveryAddressScreen extends StatefulWidget {
  static const routeName = '/delivery-address';

  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen>
    with AlertsMixin {
  bool _gotAddresses = false;
  Addresses _addressesReference;

  bool _isLoading = false;
  Future<void> _getAddresses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _addressesReference.fetchAddresses();
    } on HttpException catch (e) {
      showErrorDialog(context, e.toString());
    } catch (e) {
      throw e;
    } finally {
      if (this.mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  Address addressToEdit;

  @override
  void didChangeDependencies() {
    _addressesReference = Provider.of<Addresses>(context, listen: false);
    final Map args = ModalRoute.of(context).settings.arguments ?? {};
    addressToEdit = args['address'];

    super.didChangeDependencies();
    if (!_gotAddresses) {
      _getAddresses();
      _gotAddresses = true;
    }
  }

  var _radioGroupVal = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1.5,
          title: Text(
            AppLocalizations.of(context).deliveryAddress,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xDE000000),
                letterSpacing: 0.26),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 19),
                  child: Text(
                    AppLocalizations.of(context).deliveryAddress,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Consumer<Addresses>(
                  builder: (_, addresses, __) => addresses.addresses.length == 0
                      ? (_isLoading
                          ? Shimmer.fromColors(
                              child: AddressItem(),
                              direction: AppLocalizations.of(context).isArabic
                                  ? ShimmerDirection.rtl
                                  : ShimmerDirection.ltr,
                              enabled: true,
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100])
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocalizations.of(context)
                                    .noAddressesYet),
                              ),
                            ))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (_, int i) => AddressItem(
                                radioGroupVal:
                                    addresses.selectedAddress?.id ?? 0,
                                id: addresses.addresses[i].id,
                                address: addresses.addresses[i],
                                onChanged: (val) {
                                  print(
                                      "Selected address:: ${addresses.addresses[i].id}");

                                  addresses.changeSelectedAddress(
                                      addresses.addresses[i].id);
                                },
                                title: addresses.addresses[i].address,
                                radioValue: addresses.addresses[i].id,
                              ),
                          separatorBuilder: (_, int i) => const SizedBox(
                                height: 10.0,
                              ),
                          itemCount: addresses.addresses.length),
                ),
                SizedBox(
                  height: 30,
                ),
                Builder(
                  builder: (BuildContext context) => InkWell(
                    onTap: () async {
                      final xx = (await Navigator.of(context)
                              .pushNamed(ChooseLocationScreen.routeName) ??
                          false);
                      if (xx) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          onVisible: (() => {
                              _getAddresses()
                          }),
                          content: Text(
                            AppLocalizations.of(context)
                                .theAddressWasAddedSuccessfully,
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: Duration(seconds: 2),
                          
                        ));
                        // _getAddresses();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300]),
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 25.0,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            AppLocalizations.of(context).addNewAddress,
                            style: TextStyle(
                                color: Color(0xFF1C252C),
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Consumer<Addresses>(
                //   builder: (_, addresses, __) =>
                //         Center(
                //       child : MyCustomFormButton(
                //               buttonText: Localizations.localeOf(context).languageCode=='ar'?'متابعة':'Get Start',
                //               onPressedEvent: () {
                //                 if( addresses.selectedAddress==null){
                //         Scaffold.of(context).showSnackBar(SnackBar(
                //           content: Text(
                //             Localizations.localeOf(context).languageCode=='ar'?'يرجى تحديد عنوان التوصيل':'Please specify the delivery address',
                //             style: TextStyle(color: Colors.white),
                //           ),
                //           duration: Duration(seconds: 2),
                //         ));

                //                 }else{
                //                 Navigator.of(context)
                //                                   .pushNamed(HomeScreen.routeName);
                //                 }

                //               },
                //             ),
                // )),
              ],
            ),
          ),
        ));
  }
}
