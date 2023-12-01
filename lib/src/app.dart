import 'package:Serve_ios/src/providers/addresses.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/balance.dart';
import 'package:Serve_ios/src/providers/global_data.dart';
import 'package:Serve_ios/src/providers/notifications.dart';
import 'package:Serve_ios/src/providers/restaurants.dart';
import 'package:Serve_ios/src/screens/about_screen.dart';
import 'package:Serve_ios/src/screens/add_location_screen.dart';
import 'package:Serve_ios/src/screens/balance_screen.dart';
import 'package:Serve_ios/src/screens/cancel_order_popup_screen.dart';
import 'package:Serve_ios/src/screens/cart_screen.dart';
import 'package:Serve_ios/src/screens/change_language_screen.dart';
import 'package:Serve_ios/src/screens/changed_successfully_screen.dart';
import 'package:Serve_ios/src/screens/choose_location_screen.dart';
import 'package:Serve_ios/src/screens/complete_order_screen.dart';
import 'package:Serve_ios/src/screens/delegate_login_screen.dart';
import 'package:Serve_ios/src/screens/delivery_address_screen.dart';
import 'package:Serve_ios/src/screens/delivery_location_screen.dart';
import 'package:Serve_ios/src/screens/delivery_requests_screen.dart';
import 'package:Serve_ios/src/screens/directions_screen.dart';
import 'package:Serve_ios/src/screens/home_screen.dart';
import 'package:Serve_ios/src/screens/language_screen.dart';
import 'package:Serve_ios/src/screens/main_screen.dart';
import 'package:Serve_ios/src/screens/meal_screen.dart';
import 'package:Serve_ios/src/screens/my_requests_screen.dart';
import 'package:Serve_ios/src/screens/new_screen.dart';
import 'package:Serve_ios/src/screens/offers_screen.dart';
import 'package:Serve_ios/src/screens/order_screen.dart';
import 'package:Serve_ios/src/screens/order_tracking_map_screen.dart';
import 'package:Serve_ios/src/screens/order_tracking_screen.dart';
import 'package:Serve_ios/src/screens/payment_method_screen.dart';
import 'package:Serve_ios/src/screens/payment_screen.dart';
import 'package:Serve_ios/src/screens/privacy_policy_screen.dart';
import 'package:Serve_ios/src/screens/profile_information_screen.dart';
import 'package:Serve_ios/src/screens/registration_done_screen.dart';
import 'package:Serve_ios/src/screens/registration_screen.dart';
import 'package:Serve_ios/src/screens/restaurant_screen.dart';
import 'package:Serve_ios/src/screens/settings_screen.dart';
import 'package:Serve_ios/src/screens/splashscreen.dart';
import 'package:Serve_ios/src/screens/thanks_popup_screen.dart';
import 'package:Serve_ios/src/screens/timeout_splashscreen.dart';
import 'package:Serve_ios/src/screens/verification_code_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'helpers/app_translations.dart';
import 'providers/cart.dart';
import 'providers/language.dart';
import 'providers/maps.dart';
import 'providers/orders.dart';

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(home: TimeoutSplashScreen());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AppLanguage>(create: (_) => AppLanguage()),
              ChangeNotifierProxyProvider<AppLanguage, Auth>(
                update: (_, appLanguage, previous) => Auth(
                    previous != null ? previous.user : null,
                    previous != null ? previous.token : null,
                    previous != null ? previous.userId : null,
                    appLanguage.language),
              ),
              ChangeNotifierProxyProvider<Auth, MapsProvider>(
                lazy: false,
                update: (_, auth, previous) => MapsProvider(
                    auth.user,
                    previous?.currentLocation,
                    previous?.shouldShareLocation ?? false,
                    auth.appLanguage,
                    previous?.locationSubscription,
                    previous?.address ?? '',
                    previous?.chosenLocation),
              ),
              ChangeNotifierProxyProvider<Auth, GlobalData>(
                update: (_, auth, previous) => GlobalData(
                  auth.user,
                  previous?.about,
                  previous?.terms,
                  previous?.cities ?? [],
                  auth.appLanguage,
                ),
              ),
              ChangeNotifierProxyProvider<Auth, Notifications>(
                update: (_, auth, previous) =>
                    Notifications(auth.user, previous?.items ?? []),
              ),
              ChangeNotifierProxyProvider<Auth, Restaurants>(
                update: (_, auth, previous) => Restaurants(
                    auth.user,
                    previous == null ? [] : previous.restaurants,
                    previous == null ? [] : previous.offersSlider,
                    previous == null ? [] : previous.restaurantCategories,
                    auth.appLanguage),
              ),
              ChangeNotifierProxyProvider<Auth, Orders>(
                update: (_, auth, previous) => Orders(
                    auth.user,
                    previous?.myOrders ?? [],
                    previous?.delegateNewOrders,
                    previous?.delegateCurrentOrders,
                    previous?.delegateFinishedOrders,
                    auth.appLanguage),
              ),
              ChangeNotifierProxyProvider<Auth, Cart>(
                update: (_, auth, previous) =>
                    Cart(auth.user, auth.appLanguage),
              ),
              ChangeNotifierProxyProvider<Auth, Balance>(
                update: (_, auth, previous) => Balance(
                    auth.user,
                    previous?.balanceTransfers,
                    previous?.balance,
                    auth.appLanguage),
              ),
              ChangeNotifierProxyProvider<Auth, Addresses>(
                update: (_, auth, previous) => Addresses(
                    auth.user,
                    previous?.addresses ?? [],
                    auth.appLanguage,
                    previous?.paymentType ?? PaymentType.Cash),
              ),
            ],
            child: Selector<AppLanguage, String>(
              selector: (BuildContext context, appLanguage) =>
                  appLanguage.language,
              builder: (BuildContext context, language, _) => OverlaySupport(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: [
                    const AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [Locale('en', ''), Locale('ar', '')],
                  locale: language != null ? Locale(language, '') : null,
                  title: 'Serve | سيرڤ',
                  color: Colors.white,
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      tabBarTheme: TabBarTheme(
                        labelColor: Colors.black,
                      ),
                      canvasColor: Colors.transparent,
                      fontFamily: language == 'ar' ? 'Almarai' : 'ProximaNova',
                      buttonColor: Color.fromARGB(255, 57, 186, 186),
                      accentColor: Color.fromARGB(255, 57, 186, 186),
                      primaryColor: Colors.black,
                      appBarTheme: AppBarTheme(
                        color: Colors.white,
                        iconTheme: IconThemeData(color: Color(0xFF1C252C)),
                        textTheme: TextTheme(
                          subtitle1: TextStyle(
                              fontSize: 20,
                              fontFamily:
                                  language == 'ar' ? 'Almarai' : 'ProximaNova',
                              color: Color(0xDE000000),
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                  home: SplashScreen(),
                  routes: {
                    HomeScreen.routeName: (_) => HomeScreen(),
                    ProfileInformationScreen.routeName: (_) =>
                        ProfileInformationScreen(),
                    DelegateLoginScreen.routeName: (_) => DelegateLoginScreen(),
                    SplashScreen.routeName: (_) => SplashScreen(),
                    RegistrationDoneScreen.routeName: (_) =>
                        RegistrationDoneScreen(),
                    ChooseLocationScreen.routeName: (_) =>
                        ChooseLocationScreen(),
                    RegistrationScreen.routeName: (_) => RegistrationScreen(),
                    PrivacyPolicyScreen.routeName: (_) => PrivacyPolicyScreen(),
                    OrderTrackingScreen.routeName: (_) => OrderTrackingScreen(),
                    DirectionsScreen.routeName: (_) => DirectionsScreen(),
                    OrderTrackingMapScreen.routeName: (_) =>
                        OrderTrackingMapScreen(),
                    DeliveryLocationScreen.routeName: (_) =>
                        DeliveryLocationScreen(),
                    SettingsScreen.routeName: (_) => SettingsScreen(),
                    VerificationCodeScreen.routeName: (_) =>
                        VerificationCodeScreen(),
                    PaymentScreen.routeName: (_) => PaymentScreen(),
                    CancelOrderPopupScreen.routeName: (_) =>
                        CancelOrderPopupScreen(),
                    AddLocationScreen.routeName: (_) => AddLocationScreen(),
                    ChangedSuccessfullyScreen.routeName: (_) =>
                        ChangedSuccessfullyScreen(),
                    DeliveryRequestsScreen.routeName: (_) =>
                        DeliveryRequestsScreen(),
                    NewScreen.routeName: (_) => NewScreen(),
                    ThanksPopupScreen.routeName: (_) => ThanksPopupScreen(),
                    DeliveryAddressScreen.routeName: (_) =>
                        DeliveryAddressScreen(),
                    MainScreen.routeName: (_) => MainScreen(),
                    CompleteOrderScreen.routeName: (_) => CompleteOrderScreen(),
                    BalanceScreen.routeName: (_) => BalanceScreen(),
                    ChangePaymentMethodScreen.routeName: (_) =>
                        ChangePaymentMethodScreen(),
                    CartScreen.routeName: (_) => CartScreen(),
                    LanguageScreen.routeName: (_) => LanguageScreen(),
                    OffersScreen.routeName: (_) => OffersScreen(),
                    PaymentMethodScreen.routeName: (_) => PaymentMethodScreen(),
                    TimeoutSplashScreen.routeName: (_) => TimeoutSplashScreen(),
                    RestaurantScreen.routeName: (_) => RestaurantScreen(),
                    OrderScreen.routeName: (_) => OrderScreen(),
                    MyRequestsScreen.routeName: (_) => MyRequestsScreen(),
                    MealScreen.routeName: (_) => MealScreen(),
                    AboutScreen.routeName: (_) => AboutScreen()
                  },
                ),
              ),
            ),
          );
        }

        return Loading();
      },
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CupertinoActivityIndicator(
      radius: 20.0,
    ));
  }
}
