import 'dart:ui';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/material.dart';

class DelegateLoginScreen extends StatelessWidget {
  static const routeName = '/delegate-login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).delegateLogin,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 1.5,
      ),
      body: Container(
        padding: const EdgeInsets.only(
            left: 26.0, right: 26.0, top: 21.0, bottom: 31.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 43.0,
                    height: 135.0,
                    color: Color.fromARGB(255, 57, 186, 186).withOpacity(0.85),
                  ),
                  CircleAvatar(
                    radius: 48,
                  ),
                  GestureDetector(
                    child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            color: Color(0xFFF2F1F2).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(MyCustomIcons.upload)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              AppLocalizations.of(context).changeYourProfilePicture,
              style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
            ),
            SizedBox(
              height: 40.0,
            ),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Text(
                      AppLocalizations.of(context).id,
                      style:
                          TextStyle(color: Color(0xFF1A1A1A).withOpacity(0.7)),
                    ),
                  ),
                  MyCustomInput(
                    prefixIcon: Icon(MyCustomIcons.id),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Text(
                      AppLocalizations.of(context).password,
                      style:
                          TextStyle(color: Color(0xFF1A1A1A).withOpacity(0.7)),
                    ),
                  ),
                  MyCustomInput(
                    prefixIcon: Icon(
                      MyCustomIcons.password,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            MyCustomFormButton(
              buttonText: AppLocalizations.of(context).login,
              onPressedEvent: () {},
            )
          ],
        ),
      ),
    );
  }
}
