import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/material.dart';

class CancelOrderPopupScreen extends StatelessWidget {
  static const routeName = '/cancel-order-popup';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Container(child: Icon(MyCustomIcons.emoji_3,size: 70,color: Color.fromARGB(255, 57, 186, 186),)),
                SizedBox(
                  height: 18,
                ),
                Text(
                  AppLocalizations.of(context).sure,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 280,
                  child: Text(
                    AppLocalizations.of(context).sureText,
                    style: TextStyle(color: Color(0xFFB2B2B2)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 41,
              child: Column(
                children: <Widget>[
                  MyCustomFormButton(
                    buttonText: AppLocalizations.of(context).yes,
                    backgroundColor: Color(0xFF8F8F8F),
                    onPressedEvent: () {},
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    width: 150,
                    height: 38,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.6),
                        borderRadius: BorderRadius.circular(19)),
                    child: MyCustomFormButton(
                      buttonText: AppLocalizations.of(context).no,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      onPressedEvent: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
