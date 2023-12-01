import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/models/address.dart';
import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/screens/add_location_screen.dart';
import 'package:Serve_ios/src/screens/restaurant_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressItem extends StatelessWidget {
  final int radioGroupVal;
  final int radioValue;
  final onChanged;
  final int id;
  final String title;

  final Address address;

  const AddressItem(
      {Key key,
      this.radioGroupVal,
      this.radioValue,
      this.onChanged,
      this.title,
      this.id,
      this.address})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12),
        border: radioGroupVal == radioValue
            ? Border.all(color: Color.fromARGB(255, 57, 186, 186))
            : Border(),
      ),
      child: Row(
        children: <Widget>[
          Radio(
            activeColor: Color.fromARGB(255, 57, 186, 186),
            value: radioValue,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            groupValue: radioGroupVal,
            onChanged: onChanged,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                onChanged(id);
              },
              child: Text(
                title ?? '',
              
                style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 57, 186, 186), fontWeight: FontWeight.w600),
              ),
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black.withOpacity(0.5),
            ),
            onSelected: (int i) {
              if (i == 1) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.BOTTOMSLIDE,
                  dialogType: DialogType.WARNING,
                  body: Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .areYouSureYouWantToDeleteThisAddress,
                      style: TextStyle(fontStyle: FontStyle.italic),
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
                  btnOkOnPress: () async{
                    SharedPreferences prefs4 = await SharedPreferences.getInstance();
                              prefs4.remove('selectedaddress');
                              prefs4.remove('selectedaddressLng');
                              prefs4.remove('selectedaddressLat');
                   await Provider.of<Addresses>(context, listen: false)
                        .removeAddress(id)
                        .then((value) async {
                           
                          print("Deleted addrress !");
                          });
                  },
                )..show();
              } else {
                // final prefs = SharedPreferences.getInstance();
                // var saddress;

                // prefs.then((value) => {
                //       if (value.containsKey('selectedaddress'))
                //         {
                //           saddress = prefs.then(
                //               (value) => value.getString('selectedaddress'))
                //         }
                //     });

                // Navigator.of(context).pushNamed(AddLocationScreen.routeName,
                //     arguments: {'address': saddress});
              }
            },
            itemBuilder: (_) {
              return [
                // PopupMenuItem(
                //   value: 0,
                //   child: Row(
                //     children: <Widget>[
                //       Icon(
                //         MyCustomIcons.edit,
                //         size: 15,
                //       ),
                //       SizedBox(
                //         width: 15,
                //       ),
                //       Text(
                //         AppLocalizations.of(context).edit,
                //         style: TextStyle(
                //             fontWeight: FontWeight.w600, letterSpacing: 0.12),
                //       ),
                //     ],
                //   ),
                // ),
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MyCustomIcons.delete,
                        size: 15,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        AppLocalizations.of(context).delete,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, letterSpacing: 0.12),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
