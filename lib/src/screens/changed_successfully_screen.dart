import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/material.dart';

class ChangedSuccessfullyScreen extends StatelessWidget {
  static const routeName = '/changed-successfully';
  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context).settings.arguments as Map) ?? {};
    final String message = args['message'];
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(child: Image.asset('assets/images/emoji_2.png')),
                SizedBox(
                  height: 18,
                ),
                Text(
                  message ?? AppLocalizations.of(context).successfullyDone,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 280,
                  child: Text(
                    message == null
                        ? AppLocalizations.of(context).changedSuccessfullyText
                        : '',
                    style: TextStyle(color: Color(0xFFB2B2B2)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              child: MyCustomFormButton(
                buttonText: AppLocalizations.of(context).done,
                onPressedEvent: () {
                  Navigator.of(context)
                      .popUntil((route) => route.settings.name == '/main');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
