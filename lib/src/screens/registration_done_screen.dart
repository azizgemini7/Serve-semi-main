import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/screens/main_screen.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/material.dart';

class RegistrationDoneScreen extends StatelessWidget {
  static const routeName = '/registration-done';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/registration_done.png'),
              alignment: Alignment.center,
              fit: BoxFit.cover),
        ),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/successfully_registered.png'),
                SizedBox(
                  height: 18,
                ),
                Text(
                  AppLocalizations.of(context).successfullyRegistered,
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                Container(
                  width: 280,
                  child: Text(
                    AppLocalizations.of(context).successfullyRegisteredText,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              child: MyCustomFormButton(
                buttonText: AppLocalizations.of(context).continueWord,
                onPressedEvent: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainScreen.routeName, (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
