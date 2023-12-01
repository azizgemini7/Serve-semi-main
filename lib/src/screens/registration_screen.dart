import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/mixins/validation_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/screens/delivery_address_screen.dart';
import 'package:Serve_ios/src/screens/home_screen.dart';
import 'package:Serve_ios/src/screens/main_screen.dart';
import 'package:Serve_ios/src/screens/verification_code_screen.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with AlertsMixin, ValidationMixin {
  final FocusNode _focusNode1 = FocusNode();
  Map<String, dynamic> _authData = {
    'phonecode': '966',
    'phone': '',
  };
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Future<void> _login(BuildContext context) async {
    print('logggginn');
    if (_loginFormKey.currentState.validate()) {
      setState(() {});
      _loginFormKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
         print('fggggggggggggggggggg');
         print(_authData);
     var x=   await Provider.of<Auth>(context, listen: false)
            .login(json.encode(_authData));
  
  
        setState(() {
          _isLoading = false;
        });
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
         //  Navigator.of(context).pushReplacementNamed(DeliveryAddressScreen.routeName);
          
        }
      } on HttpException catch (error) {
        if (error.statusCode == 4003) {
          print('sdfsdfsdfddddddddddddddddddddddddddddddddddddddddd');
          print(error.message);
          _authData['activation_code'] = error.message;
          Navigator.of(context).pushNamed(VerificationCodeScreen.routeName,
              arguments: _authData);
          _isLoading = false;
        } else {
          _isLoading = false;
          showErrorDialog(
              context, error.toString(), Duration(milliseconds: 1500));
        }
      } catch (error) {
        _isLoading = false;
        throw error;
      }
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final appBar = AppBar(
      backgroundColor: Colors.white,
      title: Text(
        AppLocalizations.of(context).login,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      elevation: 1.5,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 26.0, right: 26.0, top: 21.0),
          height: deviceSize.height - appBar.preferredSize.height - 60.0,
          width: deviceSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                    //           image: AssetImage(
                    //               'assets/images/registration_image.png'),
                    //           alignment: Alignment.center,
                    //           fit: BoxFit.cover),
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
                        MyCustomIcons.verify_no,
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
                AppLocalizations.of(context).verifyYourNumber,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: 270,
                child: Text(
                  AppLocalizations.of(context).verifyNumberText,
                  style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: Text(
                        AppLocalizations.of(context).mobileNumber,
                        style: TextStyle(
                            color: Color(0xFF1A1A1A).withOpacity(0.7)),
                      ),
                    ),
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: MyCustomInput(
                        inputType: TextInputType.phone,
                        focusNode: _focusNode1,
                        onSaved: (val) {
                          _authData['phone'] = '$val';
                        },
                        validator: validatePhone,
                        onFieldSubmitted: (val) {
                          _focusNode1.unfocus();
                          _login(context);
                        },
                        enabled: true,
                        prefixIcon: Icon(
                          MyCustomIcons.mobile,
                          color: Colors.black,
                          size: 18,
                        ),
                        suffixIcon: Icon(
                          MyCustomIcons.ok,
                          color: Color.fromARGB(255, 57, 186, 186),
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Spacer(),
              SizedBox(height: 35.0),
              Column(
                children: <Widget>[
                  _isLoading
                      ? SizedBox(
                          height: 50.0,
                          child: Center(
                            child: Platform.isIOS
                                ? CupertinoActivityIndicator()
                                : CircularProgressIndicator(),
                          ),
                        )
                      : Hero(
                          tag: 'login-btn',
                          child: MyCustomFormButton(
                            buttonText: AppLocalizations.of(context).send,
                            onPressedEvent: () {
                              _login(context);
                            },
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (Navigator.of(context).canPop())
                        Navigator.of(context).pop();
                      else
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            MainScreen.routeName, (route) => false);
                    },
                    child: Text(
                      AppLocalizations.of(context).noOtherTime,
                      style: TextStyle(color: Color(0xFF6C738A)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//const SizedBox(
//width: 10.0,
//),
//CountryCodePicker(
//padding: EdgeInsets.zero,
//onChanged: (val) {
//_authData['phonecode'] =
//val.dialCode.replaceAll('+', '');
//},
//builder: (countryCode) => Text(
//countryCode.dialCode,
//style: TextStyle(color: Colors.black),
//),
//// Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
//initialSelection: '+966',
//favorite: ['+20', '+966', '+965', '+971'],
//// optional. Shows only country name and flag
//showCountryOnly: false,
//// optional. Shows only country name and flag when popup is closed.
//showOnlyCountryWhenClosed: false,
//showFlag: false,
//showFlagDialog: true,
//
//// optional. aligns the flag and the Text left
//alignLeft: false,
//),
//const SizedBox(
//width: 5.0,
//),
