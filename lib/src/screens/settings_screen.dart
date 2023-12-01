import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/mixins/navigation_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/language.dart';
import 'package:Serve_ios/src/screens/about_screen.dart';
import 'package:Serve_ios/src/screens/balance_screen.dart';
import 'package:Serve_ios/src/screens/change_language_screen.dart';
import 'package:Serve_ios/src/screens/delivery_requests_screen.dart';
import 'package:Serve_ios/src/screens/privacy_policy_screen.dart';
import 'package:Serve_ios/src/screens/profile_information_screen.dart';
import 'package:Serve_ios/src/screens/registration_screen.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'timeout_splashscreen.dart';

class SettingsScreen extends StatelessWidget with NavigationMixin, AlertsMixin {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    Future<void> _logout() async {
      try {
        await Provider.of<Auth>(context, listen: false).logout(true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).logoutDoneSuccessfully),
          duration: Duration(milliseconds: 2000),
        ));
      } on HttpException catch (e) {
        showErrorDialog(context, e.toString());
      } catch (e) {
        throw e;
      }
    }

    final Auth _authReference = Provider.of<Auth>(context);

    whatsCon({bool driver = false}) async {
      var url = "";
      if (driver) {
        url = 'https://lazah.net/driver-request';
      } else {
        url = 'https://wa.me/message/KLDVII4BGKQPI1';
      }

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'ERROR :: Could not launch $url';
      }
    }

    final List<Map<String, Object>> _tileList = [
      {
        'leading': MyCustomIcons.language,
        'title': AppLocalizations.of(context).language,
        'trailing': Icons.arrow_forward_ios,
        'value': 'English'
      },
      {
        'leading': Icons.handshake,
        'title': AppLocalizations.of(context).whatsapp,
        'onTap': () => {whatsCon().then((value) => print("Called whatsapp"))},
        'trailing': Icons.link_outlined
      },
      {
        'leading': Icons.drive_eta_rounded,
        'title': AppLocalizations.of(context).driverReg,
        'onTap': () => {
              whatsCon(driver: true)
                  .then((value) => print("Called driver Register"))
            },
        'trailing': Icons.link_outlined
      },
      {
        'leading': MyCustomIcons.delivery_requests,
        'title': AppLocalizations.of(context).deliveryRequests,
        'trailing': Icons.arrow_forward_ios,
        'onTap': () =>
            Navigator.of(context).pushNamed(DeliveryRequestsScreen.routeName),
//        'value': AppLocalizations.of(context).requests,
//        'number of requests': '2'
      },
      {
        'leading': Icons.account_balance_wallet,
        'title': AppLocalizations.of(context).balance,
        'trailing': Icons.arrow_forward_ios,
        'onTap': () => Navigator.of(context).pushNamed(BalanceScreen.routeName),
//        'value': AppLocalizations.of(context).requests,
//        'number of requests': '2'
      },
      {
        'leading': Icons.payment,
        'title': AppLocalizations.of(context).paymentMethod,
        'trailing': Icons.arrow_forward_ios,
        'onTap': () => Navigator.of(context)
            .pushNamed(ChangePaymentMethodScreen.routeName),
//        'value': AppLocalizations.of(context).requests,
//        'number of requests': '2'
      },
      {
        'leading': MyCustomIcons.about_co,
        'title': AppLocalizations.of(context).aboutCo,
        'onTap': () => Navigator.of(context).pushNamed(AboutScreen.routeName),
        'trailing': Icons.arrow_forward_ios
      },
      {
        'leading': MyCustomIcons.our_policy,
        'onTap': () =>
            Navigator.of(context).pushNamed(PrivacyPolicyScreen.routeName),
        'title': AppLocalizations.of(context).ourPolicy,
        'trailing': Icons.arrow_forward_ios
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_authReference.isAuth)
              tileBuilder(
                context: context,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ProfileInformationScreen.routeName);
                },
                leading: MyCustomIcons.profile_information,
                title: AppLocalizations.of(context).profileInformation,
                trailing: Icons.arrow_forward_ios,
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 33, vertical: 10.0),
              child: Text(
                AppLocalizations.of(context).setting,
                style: TextStyle(
                    color: Color(0xFF0D0D0D),
                    fontWeight: AppLocalizations.of(context).isArabic
                        ? FontWeight.w500
                        : FontWeight.w600,
                    fontSize: 13),
              ),
            ),
            if (_authReference.isAuth)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF1B242B),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                margin: const EdgeInsets.only(
                    top: 10, bottom: 20, left: 15, right: 15),
                child: Row(
                  children: <Widget>[
                    // Padding(
                    //     padding: EdgeInsets.fromLTRB(0, 0, 0.5, 14),
                    //     child: Text(
                    //       _authReference.user.notificationCount.toString(),
                    //       textDirection: TextDirection.rtl,
                    //       style: TextStyle(
                    //           color: Color.fromARGB(255, 236, 6, 6),
                    //           fontWeight: FontWeight.bold),
                    //     )),
                    Icon(
                      MyCustomIcons.notification,
                      color: Color(0xFF74717D),
                      size: 20,
                    ),
                    SizedBox(
                      width: 17,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _authReference.updateNotification(
                              !_authReference.user.notification);
                        },
                        child: Text(
                          AppLocalizations.of(context).notification,
                          style: TextStyle(
                              color: Color(0xFF454545),
                              fontWeight: AppLocalizations.of(context).isArabic
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                    ),
                    Switch(
                      value: _authReference.user.notification,
                      onChanged: (value) {
                        _authReference.updateNotification(value);
                      },
                    ),
                  ],
                ),
              ),
            ..._tileList.map((item) {
              return item['title'] == AppLocalizations.of(context).language
                  ? FractionallySizedBox(
                      widthFactor: 1.0,
                      child: PopupMenuButton<String>(
                        child: tileBuilder(
                            context: context,
                            leading: item['leading'],
                            title: item['title'],
                            trailing: item['trailing'],
                            value:
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? 'العربية'
                                    : 'English'),
                        tooltip: AppLocalizations.of(context).changeLanguage,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        offset: Offset(
                            AppLocalizations.of(context).isArabic ? -1.0 : 1.0,
                            0.0),
                        onSelected: (String val) {
                          Navigator.of(context)
                              .push(slideRightRouteBuilder(
                                  context,
                                  TimeoutSplashScreen(),
                                  Duration(milliseconds: 600),
                                  {'timeout': Duration(seconds: 1)},
                                  TimeoutSplashScreen.routeName))
                              .then((_) async {
                            await Provider.of<AppLanguage>(context,
                                    listen: false)
                                .changeLanguage(val);
                          });
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            child: Text(AppLocalizations.of(context).arabic),
                            value: 'ar',
                            enabled:
                                Localizations.localeOf(context).languageCode !=
                                    'ar',
                          ),
                          PopupMenuItem<String>(
                            child: Text(AppLocalizations.of(context).english),
                            value: 'en',
                            enabled:
                                Localizations.localeOf(context).languageCode !=
                                    'en',
                          )
                        ],
                      ),
                    )
                  : (item['title'] ==
                              AppLocalizations.of(context).deliveryRequests ||
                          item['title'] == AppLocalizations.of(context).balance)
                      ? (_authReference.user?.isDriver ?? false
                          ? tileBuilder(
                              context: context,
                              leading: item['leading'],
                              title: item['title'],
                              trailing: item['trailing'],
                              onTap: item['onTap'],
                              value: item['value'],
                              numOfRequests: item['number of requests'])
                          : Container())
                      : (item['title'] ==
                              AppLocalizations.of(context).paymentMethod
                          ? Container()
                          : tileBuilder(
                              context: context,
                              leading: item['leading'],
                              title: item['title'],
                              trailing: item['trailing'],
                              onTap: item['onTap'],
                              value: item['value'],
                              numOfRequests: item['number of requests']));
            }).toList(),
            SizedBox(
              height: 20,
            ),
            Center(
              child: MyCustomFormButton(
                fontSize: 14,
                buttonText: _authReference.isAuth
                    ? AppLocalizations.of(context).logout
                    : AppLocalizations.of(context).login,
                backgroundColor: Color(0xFF212C3A).withOpacity(0.5),
                onPressedEvent: () async {
                  if (_authReference.isAuth) {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.BOTTOMSLIDE,
                      dialogType: DialogType.WARNING,
                      body: Center(
                        child: Text(
                          AppLocalizations.of(context).confirmLogoutText,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      title: AppLocalizations.of(context).logout,
                      desc: 'This is also Ignored',
                      btnCancelColor:
                          Theme.of(context).primaryColor.withOpacity(0.6),
                      btnOkText: AppLocalizations.of(context).logout,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      btnOkColor: Theme.of(context).accentColor,
                      btnCancelText: AppLocalizations.of(context).cancel,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        _logout();
                      },
                    )..show();
                  } else
                    Navigator.of(context)
                        .pushNamed(RegistrationScreen.routeName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tileBuilder(
      {BuildContext context,
      IconData leading,
      Auth authReference,
      String title,
      IconData trailing,
      String value,
      onTap,
      String numOfRequests}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33.0, vertical: 12.0),
        child: Row(
          children: <Widget>[
            Icon(
              leading,
              color: Color(0xFF74717D),
              size: 20,
            ),
            SizedBox(
              width: 17,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Color(0xFF454545),
                  fontWeight: AppLocalizations.of(context).isArabic
                      ? FontWeight.w500
                      : FontWeight.w600,
                  fontSize: 13),
            ),
            Spacer(),
            value != null
                ? Row(
                    children: <Widget>[
                      if (numOfRequests != null)
                        Text(
                          numOfRequests,
                          style: TextStyle(
                              fontWeight: AppLocalizations.of(context).isArabic
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              fontSize: 12.0),
                        ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(value,
                          style: TextStyle(
                              fontWeight: AppLocalizations.of(context).isArabic
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              fontSize: 12.0)),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  )
                : Container(),
            Icon(
              trailing,
              color: Color(0xFFB2B2B2),
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}
