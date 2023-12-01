import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/mixins/navigation_mixin.dart';
import 'package:Serve_ios/src/providers/language.dart';
import 'package:Serve_ios/src/screens/main_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'timeout_splashscreen.dart';

class LanguageScreen extends StatelessWidget with NavigationMixin {
  static const routeName = '/language';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          AppLocalizations.of(context).language,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Stack(
              fit: StackFit.loose,
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: CarouselSlider(
                          items: <Widget>[
                            Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/language_slider.png',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xBB0083E7),
                                        Color(0x00545454),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          options: CarouselOptions(
                              aspectRatio: 309.0 / 359.0,
                              autoPlay: true,
                              enableInfiniteScroll: false,
                              viewportFraction: 1.0,
                              scrollPhysics: ClampingScrollPhysics(),
                              initialPage: 0),
                        ),
                      ),
                      SizedBox(
                        height: 55.0,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  child: Container(
                    width: 45.0,
                    height: double.infinity,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(color: Color.fromARGB(255, 57, 186, 186)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Icon(
                        MyCustomIcons.language,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: CarouselSlider(
                          items: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Image.asset(
                                          'assets/images/logo_icon.png'),
                                      const SizedBox(
                                        height: 13.0,
                                      ),
                                      Text(
                                        AppLocalizations.of(context).find,
                                        style: TextStyle(
                                            color: Colors.white,
                                            height: 1.36363636,
                                            fontSize: 22.0),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)
                                            .yourRestaurant,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            height: 1.36363636,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        AppLocalizations.of(context).thenOrder,
                                        style: TextStyle(
                                            height: 1.36363636,
                                            color: Colors.white,
                                            fontSize: 22.0),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        width: 6.0,
                                        height: 6.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                          options: CarouselOptions(
                              aspectRatio: 309.0 / 359.0,
                              autoPlay: true,
                              enableInfiniteScroll: false,
                              viewportFraction: 1.0,
                              scrollPhysics: ClampingScrollPhysics(),
                              initialPage: 0),
                        ),
                      ),
                      SizedBox(
                        height: 55.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Selector<AppLanguage, String>(
            selector: (_, language) => language.language,
            builder: (_, lang, __) => Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(slideRightRouteBuilder(
                            context,
                            TimeoutSplashScreen(),
                            Duration(milliseconds: 600),
                            {'timeout': Duration(seconds: 1)},
                            TimeoutSplashScreen.routeName))
                        .then((_) async {
                      await Provider.of<AppLanguage>(context, listen: false)
                          .changeLanguage('en');
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        'ENGLISH',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 9.0,
                      ),
                      Container(
                        width: 36.0,
                        color:
                            Localizations.localeOf(context).languageCode == 'en'
                                ? Theme.of(context).accentColor
                                : Colors.transparent,
                        height: 3.0,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(slideRightRouteBuilder(
                            context,
                            TimeoutSplashScreen(),
                            Duration(milliseconds: 600),
                            {'timeout': Duration(seconds: 1)},
                            TimeoutSplashScreen.routeName))
                        .then((_) async {
                      await Provider.of<AppLanguage>(context, listen: false)
                          .changeLanguage('ar');
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        'العربية',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                      const SizedBox(
                        height: 9.0,
                      ),
                      Container(
                        width: 36.0,
                        color:
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? Theme.of(context).accentColor
                                : Colors.transparent,
                        height: 3.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
//          Spacer(),
          SafeArea(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    final SharedPreferences sharedPreference =
                        await SharedPreferences.getInstance();
                    sharedPreference.setBool('landed', true);
                    Navigator.of(context)
                        .pushReplacementNamed(MainScreen.routeName);
                  },
                  // shape: BeveledRectangleBorder(),
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).next,
                        style: TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 19.0,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
