import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/mixins/validation_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/screens/main_screen.dart';
import 'package:Serve_ios/src/screens/profile_information_screen.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationCodeScreen extends StatelessWidget {
  static const routeName = '/verification-code';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final appBar = AppBar(
      backgroundColor: Colors.white,
      title: Text(
        AppLocalizations.of(context).verificationCode,
      ),
      elevation: 1.5,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height - appBar.preferredSize.height - 35,
          padding: const EdgeInsets.only(
              left: 26.0, right: 26.0, top: 21.0, bottom: 37.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 162,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // Positioned(
                    //   top: 13,
                    //   child: Container(
                    //     width: 162,
                    //     height: 108,
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //         image: AssetImage(
                    //             'assets/images/verification_code_image.png'),
                    //         fit: BoxFit.cover,
                    //         alignment: Alignment.center,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: 43.0,
                      height: 166.0,
                      color: Color.fromARGB(255, 57, 186, 186).withOpacity(0.85),
                    ),
                    Positioned(
                      bottom: 9,
                      child: Icon(
                        MyCustomIcons.messgae,
                        size: 26,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context).verificationCode,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: 250,
                child: Text(
                  AppLocalizations.of(context).verificationCodeText,
                  style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  AppLocalizations.of(context).verificationCode,
                  style: TextStyle(color: Color(0xFF1A1A1A).withOpacity(0.7)),
                ),
              ),
              Expanded(child: ActivationBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivationBody extends StatefulWidget {
  @override
  _ActivationBodyState createState() => _ActivationBodyState();
}

class _ActivationBodyState extends State<ActivationBody>
    with AlertsMixin, ValidationMixin {
  String _activationCode = '';
  bool _isLoading2 = false;
  bool _isLoading = false;
  Future<void> _resendCode(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final regResponse = await Provider.of<Auth>(context, listen: false)
          .forgotPassword(json.encode({'email': _activationData['email']}));

      final parsedRegResponse = json.decode(regResponse);
      _activationCode = '${parsedRegResponse['activation_code']}';
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString(), Duration(milliseconds: 1500));
    } catch (error) {
      throw error;
    }
    setState(() {
      _isLoading = false;
    });
  }

  GlobalKey<FormState> _activationFormKey = GlobalKey<FormState>();
  Future<void> _activateUser() async {
    if (_activationFormKey.currentState.validate()) {
      _activationFormKey.currentState.save();
      print('eeeeeeeeeeeeeeeeeeeeeeeee');
      if (this.mounted)
        setState(() {
          _isLoading2 = true;
        });
      try {
        print(act);
        //    _activationData2['activation_code']=act;
        print('yyyyyyyyyyyyaaaaaaazzzzzzzzzoooooooonnnnnnnnn');
        print(_activationData);
        final String response = await Provider.of<Auth>(context, listen: false)
            .activateUser(json.encode(_activationData));
        final parsedResponse = json.decode(response);

        showSuccessDialog(
            context, parsedResponse['message'], Duration(milliseconds: 1500));
        print(
            'hjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
        Navigator.of(context)
            .pushNamedAndRemoveUntil(MainScreen.routeName, (_) => false);
      } on HttpException catch (error) {
        if (error.statusCode == 400) {
          print(error.message);
          showErrorDialog(context, '$error', Duration(milliseconds: 1500));
        } else if (error.statusCode == 202) {
          print('erroe2');
          Navigator.of(context).pushNamed(ProfileInformationScreen.routeName,
              arguments: {..._activationData, 'isRegister': true});
        } else {
          print('erroe3');
          showErrorDialog(context, error.toString());
        }
      } catch (error) {
        throw (error);
      }
      setState(() {
        _isLoading2 = false;
      });
    }
  }

  Map _activationData;
  Map _activationData2;
  bool hasPutActivationData = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void didChangeDependencies() {
    if (!hasPutActivationData) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      if (args != null) {
        _activationCode = args['activation_code'];

        _activationData = args;
        _activationData2 = args;
        print('sdfsdfsdfsdf');
        print(_activationData2);
        if (args['activation_code'].length > 0) act = args['activation_code'];
        args['activation_code'] = '';
      }
      hasPutActivationData = true;
    }

    super.didChangeDependencies();
  }

  String act = '';
  @override
  void initState() {
    super.initState();
    firebaseMessaging.getToken().then((String token) {
      _activationData['device_token'] = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _activationFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.ltr,
            child: PinCodeTextField(
              appContext: context,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              length: 4,
              autoFocus: true,
              autoDismissKeyboard: true,
              onChanged: (val) {
                _activationData['activation_code'] = val;
              },
              pinTheme: PinTheme(
                inactiveColor: Color(0xFFFBFBFB),
                shape: PinCodeFieldShape.box,
                fieldWidth: 50,
                inactiveFillColor: Color(0xFFFBFBFB),
                fieldHeight: 50,
              ),
              keyboardType: TextInputType.number,
              onCompleted: (String value) {
                _activationData['activation_code'] = value;
                _activateUser();
              },
            ),
          ),
          SizedBox(
              height: 40.0,
            ),
          _isLoading2
              ? SizedBox(
                  height: 50.0,
                  child: Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(),
                  ),
                )
              : MyCustomFormButton(
                  buttonText: AppLocalizations.of(context).verify,
                  onPressedEvent: () {
                    _activateUser();
                  },
                ),
          SizedBox(
            height: 20,
          ),
          _isLoading
              ? SizedBox(
                  height: 50.0,
                  child: Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(),
                  ),
                )
              : TextButton(
                  onPressed: () {
                    _resendCode(context);
                  },
                  child: Text(
                    AppLocalizations.of(context).resendCode,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
        ],
      ),
    );
  }
}
