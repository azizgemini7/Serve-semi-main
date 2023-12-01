import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/material.dart';

class ThanksPopupScreen extends StatelessWidget {
  static const routeName = '/thanks-popup';
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
//                Container(child: Icon(MyCustomIcons.emoji_3,size: 100,color: Color.fromARGB(255, 57, 186, 186),)),
                SizedBox(
                  height: 12,
                ),
                Text(
                  AppLocalizations.of(context).thanks,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 27),
                Container(
                  width: 280,
                  child: Text(
                    AppLocalizations.of(context).thanksText,
                    style: TextStyle(
                        color: Color(0xFFB2B2B2),
                        fontSize: 12,
                        letterSpacing: 0.21,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              child: MyCustomFormButton(
                buttonText: AppLocalizations.of(context).done,
                onPressedEvent: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
