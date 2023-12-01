import 'dart:async';

import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/screens/language_screen.dart';
import 'package:Serve_ios/src/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashscreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
//  double _logoHeight;
  double _translateVal = 0;
  Size deviceSize;

  double _opacityVal = 0.0;

  double _bottomVal = -50.0;

  double _bottomValWord = -50.0;
//  AnimationController _animationController;
//  Animation<double> _opacityAnimation;
//  double _currentLogoOffsetTop = 110.0;
//  double _currentLogoOffsetBottom = deviceSize.height / 2;

  Future<void> hideScreen() async {
    bool landed = false;
    // FirebaseCrashlytics.instance.crash();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('landed')) {
      landed = prefs.getBool('landed');
    }
    final xx = Provider.of<Auth>(context, listen: false);
    bool isLoggedIn = false;
    if (!xx.isAuth)
      isLoggedIn = await xx.tryAutoLogin();
    else
      isLoggedIn = true;

    final bool hh = (await xx.getAppSettings()) ?? false;
    if (mounted) {
      Provider.of<Auth>(context, listen: false).appReviewed = hh;
    }

    if (isLoggedIn)
      Provider.of<Addresses>(context, listen: false).getStoredPaymentType();
    Future.delayed(Duration(milliseconds: 1500), () {
      if (this.mounted)
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            opaque: true,
            settings: RouteSettings(
                name: landed ? MainScreen.routeName : LanguageScreen.routeName),
            transitionDuration: const Duration(milliseconds: 1500),
            pageBuilder: (BuildContext context, _, __) =>
                landed ? MainScreen() : LanguageScreen(),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      ;
    });
  }

  @override
  void dispose() {
//    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    deviceSize = MediaQuery.of(context).size;
    Future.delayed(Duration(milliseconds: 300), () {
      if (this.mounted)
        setState(() {
          _opacityVal = 1.0;
          _bottomVal = 0.0;
          _bottomValWord = 80.0;
        });
    });
//    _translateVal = deviceSize.width / 1.5;
//    Provider.of<GlobalData>(context, listen: false).getCountriesAndCategories();
//    Provider.of<GlobalData>(context, listen: false).getCountriesAndCategories();
    // TODO: implement didChangeDependencies

    hideScreen();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 208, 208),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          // AnimatedOpacity(
          //   duration: Duration(milliseconds: 1000),
          //   opacity: _opacityVal,
          //   curve: Curves.easeInOut,
          //   child: Container(
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //         color: Colors.black,
          //         image: DecorationImage(
          //           image: AssetImage('assets/images/splash.png'),
          //           alignment: Alignment.center,
          //           fit: BoxFit.cover,
          //         )),
          //   ),
          // ),
          Image.asset('assets/images/spl.png'),
          AnimatedPositioned(
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            bottom: _bottomVal,
            child: Container(
              width: 61.0,
              height: 120,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Color.fromARGB(255, 57, 186, 186).withOpacity(0.5),
                          width: 7.0),
                      left: BorderSide(
                          color: Color.fromARGB(255, 57, 186, 186).withOpacity(0.5),
                          width: 7.0),
                      right: BorderSide(
                          color: Color.fromARGB(255, 57, 186, 186).withOpacity(0.5),
                          width: 7.0))),
            ),
          ),
          Positioned(
            bottom: 50.0,
            child: CupertinoActivityIndicator(),
          ),
          // AnimatedPositioned(
          //   duration: Duration(milliseconds: 1500),
          //   curve: Curves.easeInOut,
          //   bottom: _bottomValWord != 0 ? _bottomValWord + 250 : _bottomValWord,
          //   child: Text(
          //     'أهلاً بك ',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 20.0,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 50,
          // ),
          // AnimatedPositioned(
          //   duration: Duration(milliseconds: 1500),
          //   curve: Curves.easeInOutCubicEmphasized,
          //   bottom: _bottomValWord != 0 ? _bottomValWord + 200 : _bottomValWord,
          //   child: Text(
          //     'كل شيء بين يديك من ألذ وطاب 😋',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 16.0,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
