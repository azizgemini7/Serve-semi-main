import 'dart:async';

import 'package:flutter/material.dart';

class TimeoutSplashScreen extends StatefulWidget {
  static const routeName = '/timeout-splashscreen';

  @override
  _TimeoutSplashScreenState createState() => _TimeoutSplashScreenState();
}

class _TimeoutSplashScreenState extends State<TimeoutSplashScreen> {
  Size deviceSize;

  @override
  void dispose() {
    super.dispose();
  }

  var timeout;
  bool timerStarted = false;

  @override
  void didChangeDependencies() {
//    Provider.of<GlobalData>(context, listen: false).getCountriesAndCategories();
//    Provider.of<GlobalData>(context, listen: false).getCountriesAndCategories();
    final args = (ModalRoute.of(context)?.settings?.arguments as Map) ?? {};
    if (args != null) {
      timeout = args['timeout'] ?? Duration(seconds: 10);
      if (timeout != null && timerStarted == false) {
        timerStarted = true;
        Future.delayed(timeout, () {
          if (this.mounted) Navigator.of(context).pop();
        });
      }
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage('assets/images/splash.png'),
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                )),
          ),
          Image.asset('assets/images/logo.png'),
        ],
      ),
    );
  }
}
