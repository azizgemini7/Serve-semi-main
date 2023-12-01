import 'package:Serve_ios/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final String localeName;
  bool get isArabic => this.localeName == 'ar';

  String get remove => Intl.message(
        'Remove',
        name: 'remove',
        desc: 'Translation for the word Remove',
        locale: localeName,
      );
  String get areYouSureYouWantToRemoveThisCoupon => Intl.message(
        'Are you sure you want to remove this coupon?',
        name: 'areYouSureYouWantToRemoveThisCoupon',
        desc:
            'Translation for the word Are you sure you want to remove this coupon?',
        locale: localeName,
      );
  String get removeCoupon => Intl.message(
        'Remove coupon',
        name: 'removeCoupon',
        desc: 'Translation for the word Remove coupon',
        locale: localeName,
      );
  String get discount => Intl.message(
        'Discount',
        name: 'discount',
        desc: 'Translation for the word Discount',
        locale: localeName,
      );
  String get searchForPlace => Intl.message(
        'Search for place',
        name: 'searchForPlace',
        desc: 'Translation for the word Search for place',
        locale: localeName,
      );
  String get changeLocation => Intl.message(
        'Change location',
        name: 'changeLocation',
        desc: 'Translation for the word Change location',
        locale: localeName,
      );
  String get freeDeliveryIfOrderPriceExceeds => Intl.message(
        'Free delivery if order price exceeds',
        name: 'freeDeliveryIfOrderPriceExceeds',
        desc: 'Translation for the word Free delivery if order price exceeds',
        locale: localeName,
      );
  String get editAddress => Intl.message(
        'Edit address',
        name: 'editAddress',
        desc: 'Translation for the word Edit address',
        locale: localeName,
      );
  String get areYouSureYouWantToDeleteThisAddress => Intl.message(
        'Are you sure you want to delete this address',
        name: 'areYouSureYouWantToDeleteThisAddress',
        desc:
            'Translation for the word Are you sure you want to delete this address',
        locale: localeName,
      );
  String get myLocation => Intl.message(
        'My location',
        name: 'myLocation',
        desc: 'Translation for the word My location',
        locale: localeName,
      );
  String get contactwithcustom => Intl.message(
    'Chat with the customer',
    name: 'contactwithcustom',
    desc: 'Chat with the customer',
    locale: localeName,
  );
  String get restaurantLocation => Intl.message(
        'Restaurant location',
        name: 'restaurantLocation',
        desc: 'Translation for the word Restaurant location',
        locale: localeName,
      );
  String get storeLocation => Intl.message(
        'Store location',
        name: 'storeLocation',
        desc: 'Translation for the word Store location',
        locale: localeName,
      );
  String get clientLocation => Intl.message(
        'Client location',
        name: 'clientLocation',
        desc: 'Translation for the word Client location',
        locale: localeName,
      );
  String get onMaps => Intl.message(
        'On maps',
        name: 'onMaps',
        desc: 'Translation for the word On maps',
        locale: localeName,
      );
  String get incomeOrderDelivery => Intl.message(
        'Income: Order delivery',
        name: 'incomeOrderDelivery',
        desc: 'Translation for the word Income: Order delivery',
        locale: localeName,
      );
  String get successful => Intl.message(
        'Successful',
        name: 'successful',
        desc: 'Translation for the word Successfully',
        locale: localeName,
      );
  String get withdrawABalance => Intl.message(
        'Withdraw a balance',
        name: 'withdrawABalance',
        desc: 'Translation for the word Withdraw a blance',
        locale: localeName,
      );
  String get totalBalance => Intl.message(
        'Total balance',
        name: 'totalBalance',
        desc: 'Translation for the word Total balance',
        locale: localeName,
      );
  String get balance => Intl.message(
        'Balance',
        name: 'balance',
        desc: 'Translation for the word Balance',
        locale: localeName,
      );
  String get track => Intl.message(
        'Track',
        name: 'track',
        desc: 'Translation for the word track',
        locale: localeName,
      );
  String get haveYouDeliveredThisOrder => Intl.message(
        'Have you delivered this order?',
        name: 'haveYouDeliveredThisOrder',
        desc: 'Translation for the word Have you delivered this order?',
        locale: localeName,
      );
  String get haveYouTakenThisOrderFromTheRestaurant => Intl.message(
        'Have you taken this order from the restaurant?',
        name: 'haveYouTakenThisOrderFromTheRestaurant',
        desc:
            'Translation for the word Have you taken this order from the restaurant',
        locale: localeName,
      );
  String get pleaseWait => Intl.message(
        'Please wait...',
        name: 'pleaseWait',
        desc: 'Translation for the word Please wait...',
        locale: localeName,
      );
  String get takeOrder => Intl.message(
        'Take order',
        name: 'takeOrder',
        desc: 'Translation for the word Take order',
        locale: localeName,
      );
  String get deliverOrder => Intl.message(
        'Deliver order',
        name: 'deliverOrder',
        desc: 'Translation for the word Deliver order',
        locale: localeName,
      );
  String get youConfirmedTakingOrderSuccessfully => Intl.message(
        'You confirmed taking order successfully, your location will be shared to the order owner until you deliver the order.',
        name: 'youConfirmedTakingOrderSuccessfully',
        desc:
            'Translation for the word You confirmed taking order successfully',
        locale: localeName,
      );
  String get youConfirmedDeliveringTheOrderSuccessfully => Intl.message(
        'You confirmed delivering the order successfully',
        name: 'youConfirmedDeliveringTheOrderSuccessfully',
        desc:
            'Translation for the word You confirmed delivering the order successfully',
        locale: localeName,
      );
  String get youHaveReceivedThisOrderSuccessfully => Intl.message(
        'You have received this order successfully',
        name: 'youHaveReceivedThisOrderSuccessfully',
        desc:
            'Translation for the word You have received this order successfully',
        locale: localeName,
      );
  String get confirm => Intl.message(
        'Confirm',
        name: 'confirm',
        desc: 'Translation for the word Confirm',
        locale: localeName,
      );
  String get areYouSureYouWantToReceiveThisRequest => Intl.message(
        'Are you sure you want to receive this request?',
        name: 'areYouSureYouWantToReceiveThisRequest',
        desc:
            'Translation for the word Are you sure you want to receive this request',
        locale: localeName,
      );
  String get receiveTheRequest => Intl.message(
        'Receive the request',
        name: 'receiveTheRequest',
        desc: 'Translation for the word ReceiveTheRequest',
        locale: localeName,
      );
  String get noNewDelegateOrdersYet => Intl.message(
        'There is no new orders for delegate  yet',
        name: 'noNewDelegateOrdersYet',
        desc: 'Translation for the word There is no new delegate orders yet',
        locale: localeName,
      );
  String get noFinishedDelegateOrdersYet => Intl.message(
        'There is no finished orders for delegate  yet',
        name: 'noFinishedDelegateOrdersYet',
        desc: 'Translation for the word There is no new delegate orders yet',
        locale: localeName,
      );
  String get noCurrentDelegateOrdersYet => Intl.message(
        'There is no current orders for delegate  yet',
        name: 'noCurrentDelegateOrdersYet',
        desc: 'Translation for the word There is no new delegate orders yet',
        locale: localeName,
      );
  String get finished => Intl.message(
        'Finished',
        name: 'finished',
        desc: 'Translation for the word Finished',
        locale: localeName,
      );
  String get current => Intl.message(
        'Current',
        name: 'current',
        desc: 'Translation for the word Current',
        locale: localeName,
      );
  String get payForOrder => Intl.message(
        'Pay for order',
        name: 'payForOrder',
        desc: 'Translation for the word Pay for order ',
        locale: localeName,
      );
  String get orderFrom => Intl.message(
        'orderFrom',
        name: 'orderFrom',
        desc: 'Translation for the word orderFrom',
        locale: localeName,
      );
  String get payment => Intl.message(
        'Payment',
        name: 'payment',
        desc: 'Translation for the word Payment',
        locale: localeName,
      );
  String get changePaymentType => Intl.message(
        'Change payment type',
        name: 'changePaymentType',
        desc: 'Translation for the word Change payment type',
        locale: localeName,
      );
  String get onlinePayment => Intl.message(
        'Online payment',
        name: 'onlinePayment',
        desc: 'Translation for the word Online payment',
        locale: localeName,
      );
  String get cash => Intl.message(
        'Cash',
        name: 'cash',
        desc: 'Translation for the word Cashe',
        locale: localeName,
      );
  String get orMore => Intl.message(
        'Or more',
        name: 'orMore',
        desc: 'Translation for the word Or more',
        locale: localeName,
      );
  String get onRequestOf => Intl.message(
        'On request of',
        name: 'onRequestOf',
        desc: 'Translation for the word On request of',
        locale: localeName,
      );
  String get freeDelivery => Intl.message(
        'Free Delivery',
        name: 'freeDelivery',
        desc: 'Translation for the word Free Delivery',
        locale: localeName,
      );
  String get close => Intl.message(
        'Close',
        name: 'close',
        desc: 'Translation for the word Close',
        locale: localeName,
      );
  String get delegate => Intl.message(
        'Delegate',
        name: 'delegate',
        desc: 'Translation for the word Delegate',
        locale: localeName,
      );
  String get orderTracking => Intl.message(
        'Order tracking',
        name: 'orderTracking',
        desc: 'Translation for the word Order tracking',
        locale: localeName,
      );
  String get privacyPolicy => Intl.message(
        'Privacy policy',
        name: 'privacyPolicy',
        desc: 'Translation for the word Privacy policy',
        locale: localeName,
      );
  String get successfullyDone => Intl.message(
        'Successfully done',
        name: 'successfullyDone',
        desc: 'Translation for the word Successfully done',
        locale: localeName,
      );
  String get theAddressWasAddedSuccessfully => Intl.message(
        'Your address was added successfully',
        name: 'theAddressWasAddedSuccessfully',
        desc: 'Translation for the word Your address was added successfully',
        locale: localeName,
      );
  String get pleaseLoginFirst => Intl.message(
        'Please login first',
        name: 'pleaseLoginFirst',
        desc: 'Translation for the word Please loginFirst',
        locale: localeName,
      );
  String get noAddressesYet => Intl.message(
        'You have no addresses yet',
        name: 'noAddressesYet',
        desc: 'Translation for the word You have no addresses yet',
        locale: localeName,
      );
  String get enterLocation => Intl.message(
        'Enter your location',
        name: 'enterLocation',
        desc: 'Translation for the word Enter your location',
        locale: localeName,
      );
  String get or => Intl.message(
        'Or',
        name: 'or',
        desc: 'Translation for the word Or',
        locale: localeName,
      );
  String get manuallyEnterAddress => Intl.message(
        'Manually enter address',
        name: 'manuallyEnterAddress',
        desc: 'Translation for the word Manually enter address',
        locale: localeName,
      );
  String get about => Intl.message(
        'About Us',
        name: 'about',
        desc: 'Translation for the word About Us',
        locale: localeName,
      );
  String get yourCartIsEmpty => Intl.message(
        'Your cart is empty',
        name: 'yourCartIsEmpty',
        desc: 'Translation for the word Your cart is empty',
        locale: localeName,
      );

  String get noMealsInThisCategory => Intl.message(
        'No meals in this category',
        name: 'noMealsInThisCategory',
        desc: 'Translation for the word No meals in this category',
        locale: localeName,
      );
  String get km => Intl.message(
        'km',
        name: 'km',
        desc: 'Translation for the word km',
        locale: localeName,
      );
  String get searchByRestaurantName => Intl.message(
        'Search by restaurant name',
        name: 'searchByRestaurantName',
        desc: 'Translation for the word Search by restaurant name',
        locale: localeName,
      );
  String get noRestaurantsFound => Intl.message(
        'No restaurants found',
        name: 'noRestaurantsFound',
        desc: 'Translation for the word No restaurants found',
        locale: localeName,
      );
  String get closed => Intl.message(
        'Closed',
        name: 'closed',
        desc: 'Translation for the word Closed',
        locale: localeName,
      );
  String get all => Intl.message(
        'All',
        name: 'all',
        desc: 'Translation for the word All',
        locale: localeName,
      );
  String get logoutDoneSuccessfully => Intl.message(
        'Logout done successfully',
        name: 'logoutDoneSuccessfully',
        desc: 'Translation for the word Logout done successfully',
        locale: localeName,
      );
  String get confirmLogoutText => Intl.message(
        'Are you sure you want to logout?',
        name: 'confirmLogoutText',
        desc: 'Translation for the word Are you sure you want to logout?',
        locale: localeName,
      );
  String get requests => Intl.message(
        'Requests',
        name: 'requests',
        desc: 'Translation for the word Requests',
        locale: localeName,
      );
  String get restaurant => Intl.message(
        'Restaurant',
        name: 'restaurant',
        desc: 'Translation for the word Restaurant',
        locale: localeName,
      );
  String get uploadYourProfilePicture => Intl.message(
        'Upload your profile picture',
        name: 'uploadYourProfilePicture',
        desc: 'Translation for the word Upload your profile picture',
        locale: localeName,
      );
  String get pleaseEnter => Intl.message(
        'Please enter',
        name: 'pleaseEnter',
        desc: 'Translation for the word Please enter',
        locale: localeName,
      );
  String get find => Intl.message(
        'Find',
        name: 'find',
        desc: 'Translation for the word Find',
        locale: localeName,
      );
  String get yourRestaurant => Intl.message(
        'Your Restaurant',
        name: 'yourRestaurant',
        desc: 'Translation for the word Your Restaurant',
        locale: localeName,
      );
  String get thenOrder => Intl.message(
        'Then Order',
        name: 'thenOrder',
        desc: 'Translation for the word Then Order',
        locale: localeName,
      );
  String get changeYourProfilePicture => Intl.message(
        'Change your profile picture',
        name: 'changeYourProfilePicture',
        desc: 'Translation for the word Change your profile picture',
        locale: localeName,
      );
  String get delegateLogin => Intl.message(
        'Delegate Login',
        name: 'delegateLogin',
        desc: 'Translation for the word DelegateLogin',
        locale: localeName,
      );
  String get delete => Intl.message(
        'Delete',
        name: 'delete',
        desc: 'Translation for the word Delete',
        locale: localeName,
      );
  String get deleteProduct => Intl.message(
        'Delete product',
        name: 'deleteProduct',
        desc: 'Translation for the word Delete product',
        locale: localeName,
      );
  String get confirmDeleteProduct => Intl.message(
        'Are you sure you want to delete this product?',
        name: 'confirmDeleteProduct',
        desc:
            'Translation for the word Are you sure you want to delete this product?',
        locale: localeName,
      );
  String get edit => Intl.message(
        'Edit',
        name: 'edit',
        desc: 'Translation for the word Edit',
        locale: localeName,
      );
  String get editProduct => Intl.message(
        'Edit product',
        name: 'editProduct',
        desc: 'Translation for the word Edit product',
        locale: localeName,
      );
  String get confirmDeletePhoto => Intl.message(
        'Are you sure you want to delete this photo?',
        name: 'confirmDeletePhoto',
        desc:
            'Translation for the word Are you sure you want to delete this photo?',
        locale: localeName,
      );
  String get deletePhoto => Intl.message(
        'Delete photo',
        name: 'deletePhoto',
        desc: 'Translation for the word Delete photo',
        locale: localeName,
      );
  String get errorUploading => Intl.message(
        'Error occured while uploading!',
        name: 'errorUploading',
        desc: 'Translation for the word Error occured while uploading',
        locale: localeName,
      );
  String get play => Intl.message(
        'Play',
        name: 'play',
        desc: 'Translation for the word Play',
        locale: localeName,
      );
  String get changeFont => Intl.message(
        'Change font',
        name: 'changeFont',
        desc: 'Translation for the word Change font',
        locale: localeName,
      );
  String get pick => Intl.message(
        'Pick',
        name: 'pick',
        desc: 'Translation for the word Pick',
        locale: localeName,
      );
  String get pickAColor => Intl.message(
        'Pick a color',
        name: 'pickAColor',
        desc: 'Translation for the word Pick a color',
        locale: localeName,
      );
  String get changeTextColor => Intl.message(
        'Change text color',
        name: 'changeTextColor',
        desc: 'Translation for the word Change text color',
        locale: localeName,
      );
  String get chatOptions => Intl.message(
        'Chat options',
        name: 'chatOptions',
        desc: 'Translation for the word Chat options',
        locale: localeName,
      );
  String get noMessagesInThisRoomYet => Intl.message(
        'No messages in this room yet',
        name: 'noMessagesInThisRoomYet',
        desc: 'Translation for the word No messages in this room yet',
        locale: localeName,
      );
  String get writeYourMessage => Intl.message(
        'Write your message',
        name: 'writeYourMessage',
        desc: 'Translation for the word Write your message',
        locale: localeName,
      );
  String get premiumMembership => Intl.message(
        'Premium membership',
        name: 'premiumMembership',
        desc: 'Translation for the word Premium membership',
        locale: localeName,
      );
  String get match => Intl.message(
        'Match',
        name: 'match',
        desc: 'Translation for the word Match',
        locale: localeName,
      );
  String get priceInSAR => Intl.message(
        'Price in SAR',
        name: 'priceInSAR',
        desc: 'Translation for the word Price in SAR',
        locale: localeName,
      );
  String get chooseCategory => Intl.message(
        'Choose category',
        name: 'chooseCategory',
        desc: 'Translation for the word Choose category',
        locale: localeName,
      );
  String get productTitle => Intl.message(
        'Product title',
        name: 'productTitle',
        desc: 'Translation for the word Product title',
        locale: localeName,
      );
  String get addProduct => Intl.message(
        'Add product',
        name: 'addProduct',
        desc: 'Translation for the word Add product',
        locale: localeName,
      );

  String get add => Intl.message(
        'Add',
        name: 'add',
        desc: 'Translation for the word Add',
        locale: localeName,
      );
  String get allResults => Intl.message(
        'All results',
        name: 'allResults',
        desc: 'Translation for the word All results',
        locale: localeName,
      );

  String get storesPageContentText => Intl.message(
        'Contains the products of well known brands and its contact numbers',
        name: 'storesPageContentText',
        desc:
            'Translation for the word Contains the products of well known brands and its contact numbers',
        locale: localeName,
      );

  String get notifications => Intl.message(
        'Notifications',
        name: 'notifications',
        desc: 'Translation for the word Notifications',
        locale: localeName,
      );
  String get leagueCouncil => Intl.message(
        'League council',
        name: 'leagueCouncil',
        desc: 'Translation for the word League council',
        locale: localeName,
      );
       String get orderdetails => Intl.message(
        'orderdetails',
        name: 'orderdetails',
        desc: 'orderdetails',
        locale: localeName,
      );
           String get orderher => Intl.message(
        'orderher',
        name: 'orderher',
        desc: 'orderher',
        locale: localeName,
      );
       String get rating => Intl.message(
        'rating',
        name: 'rating',
        desc: 'rating us',
        locale: localeName,
      );


  String get orderdate => Intl.message(
    'orderdate',
    name: 'orderdate',
    desc: 'Translation for the word sar',
    locale: localeName,
  );

  String get sar => Intl.message(
        'sar',
        name: 'sar',
        desc: 'Translation for the word sar',
        locale: localeName,
      );
  String get camera => Intl.message(
        'Camera',
        name: 'camera',
        desc: 'Translation for the word Camera',
        locale: localeName,
      );
  String get searchByProductName => Intl.message(
        'Search by product name',
        name: 'searchByProductName',
        desc: 'Translation for the word Search by product name',
        locale: localeName,
      );
  String get chooseProfilePictureOptional => Intl.message(
        'Choose profile picture (optional)',
        name: 'chooseProfilePictureOptional',
        desc: 'Translation for the word Choose profile picture (optional)',
        locale: localeName,
      );
  String get name => Intl.message(
        'Name',
        name: 'name',
        desc: 'Translation for the word Name',
        locale: localeName,
      );
  String get logout => Intl.message(
        'Logout',
        name: 'logout',
        desc: 'Translation for the word Logout',
        locale: localeName,
      );
  String get termsOfGettingRanks => Intl.message(
        'Terms of getting ranks',
        name: 'termsOfGettingRanks',
        desc: 'Translation for the word Terms of getting ranks',
        locale: localeName,
      );
  String get aboutLeagueCouncil => Intl.message(
        'About league council',
        name: 'aboutLeagueCouncil',
        desc: 'Translation for the word About league council',
        locale: localeName,
      );
  String get language => Intl.message(
        'Language',
        name: 'language',
        desc: 'Translation for the word Language',
        locale: localeName,
      );

  String get arabic => Intl.message(
        'Arabic',
        name: 'arabic',
        desc: 'Translation for the word Arabic',
        locale: localeName,
      );
  String get english => Intl.message(
        'English',
        name: 'english',
        desc: 'Translation for the word English',
        locale: localeName,
      );
  String get myStore => Intl.message(
        'My store',
        name: 'myStore',
        desc: 'Translation for the word My store',
        locale: localeName,
      );

  String get myAccount => Intl.message(
        'My account',
        name: 'myAccount',
        desc: 'Translation for the word My account',
        locale: localeName,
      );
  String get more => Intl.message(
        'More',
        name: 'more',
        desc: 'Translation for the word More',
        locale: localeName,
      );

  String get store => Intl.message(
        'Store',
        name: 'store',
        desc: 'Translation for the word Store',
        locale: localeName,
      );

  String get newUser => Intl.message(
        'New user',
        name: 'newUser',
        desc: 'Translation for the word New user',
        locale: localeName,
      );

  String get forgotPasswordQuestion => Intl.message(
        'Did you forget password?',
        name: 'forgotPasswordQuestion',
        desc: 'Translation for the word Did you forget password?',
        locale: localeName,
      );
  String get choose => Intl.message(
        'Choose',
        name: 'choose',
        desc: 'Translation for the word Choose',
        locale: localeName,
      );
  String get ranks => Intl.message(
        'Ranks',
        name: 'ranks',
        desc: 'Translation for the word Ranks',
        locale: localeName,
      );

  String get ranksPageContentText => Intl.message(
        'يوفر التطبيق ميزة جديدة وهي السماح للمستخدمين بالحصول على رتب رياضية بناءاً على مساهمتهم ويمكنك معرفة المزيد من صفحة الشروط',
        name: 'ranksPageContentText',
        desc:
            'Translation for the word يوفر التطبيق ميزة جديدة وهي السماح للمستخدمين بالحصول على رتب رياضية بناءاً على مساهمتهم ويمكنك معرفة المزيد من صفحة الشروط',
        locale: localeName,
      );

  String get storesPage => Intl.message(
        'Stores page',
        name: 'storesPage',
        desc: 'Translation for the word Stores page',
        locale: localeName,
      );
  String get leagueCouncilPageContentText => Intl.message(
        'وتحتوي على غرف لفرق الدوري السعودي وغرف أخرى للمباريات الهامة للدردشة بين المستخدمين',
        name: 'leagueCouncilPageContentText',
        desc: 'Translation for the word ',
        locale: localeName,
      );
  String get leagueCouncilPage => Intl.message(
        'League council page',
        name: 'leagueCouncilPage',
        desc: 'Translation for the word League council page',
        locale: localeName,
      );
  String get homePage => Intl.message(
        'Home page',
        name: 'homePage',
        desc: 'Translation for the word Home page',
        locale: localeName,
      );

  String get homePageContentText => Intl.message(
        'Contains matches dates arranged according to date, and can be sorted by date',
        name: 'homePageContentText',
        desc:
            'Translation for the word Contains matches dates arranged according to date, and can be sorted by date',
        locale: localeName,
      );
  String get myResults => Intl.message(
        'My results',
        name: 'myResults',
        desc: 'Translation for the word My results',
        locale: localeName,
      );

  String get passwordBeenResetSuccessfully => Intl.message(
        'Password has been reset successfully',
        name: 'passwordBeenResetSuccessfully',
        desc: 'Translation for the word password has been reset successfully',
        locale: localeName,
      );
  String get resetPasswordText => Intl.message(
        'Code was entered successfully, now you can reset your password',
        name: 'resetPasswordText',
        desc:
            'Translation for the word Code was entered successfully, now you can reset your password',
        locale: localeName,
      );

  String get nationalId => Intl.message(
        'National id',
        name: 'nationalId',
        desc: 'Translation for the word National id',
        locale: localeName,
      );
  String get youHaventChosenAnyLeagueYet => Intl.message(
        'You haven\'t chosen any league yet',
        name: 'youHaventChosenAnyLeagueYet',
        desc: 'Translation for the word You Haven\'t chosen any league yet',
        locale: localeName,
      );
  String get commercialNumber => Intl.message(
        'Commercial number',
        name: 'commercialNumber',
        desc: 'Translation for the word Commercial number',
        locale: localeName,
      );
  String get storeRegistration => Intl.message(
        'Store registration',
        name: 'storeRegistration',
        desc: 'Translation for the word Store registration',
        locale: localeName,
      );
  String get gallery => Intl.message(
        'Gellery',
        name: 'gallery',
        desc: 'Translation for the word Gellery',
        locale: localeName,
      );

  String get commercialName => Intl.message(
        'Commercial name',
        name: 'commercialName',
        desc: 'Translation for the word Commercial name',
        locale: localeName,
      );

  String get changePassword => Intl.message(
        'Change password',
        name: 'changePassword',
        desc: 'Translation for the word Change password',
        locale: localeName,
      );
  String get addressInDetail => Intl.message(
        'Address in details',
        name: 'addressInDetail',
        desc: 'Translation for the word Address in details',
        locale: localeName,
      );
  String get activate => Intl.message(
        'Activate',
        name: 'activate',
        desc: 'Translation for the word Activate',
        locale: localeName,
      );

  String get register => Intl.message(
        'Register',
        name: 'register',
        desc: 'Translation for the word Register',
        locale: localeName,
      );

  String get login => Intl.message(
        'Login',
        name: 'login',
        desc: 'Translation for the word Login',
        locale: localeName,
      );

  String get forgotPassword => Intl.message(
        'Forgot password',
        name: 'forgotPassword',
        desc: 'Translation for the word Forgot password',
        locale: localeName,
      );

  String get recoverAccount => Intl.message(
        'Recover account',
        name: 'recoverAccount',
        desc: 'Translation for the word Recover account',
        locale: localeName,
      );
  String get recoverPassword => Intl.message(
        'Recover password',
        name: 'recoverPassword',
        desc: 'Translation for the word Recover password',
        locale: localeName,
      );

  String get resetPassword => Intl.message(
        'Reset password',
        name: 'resetPassword',
        desc: 'Translation for the word Reset password',
        locale: localeName,
      );
  String get officialContactPhone => Intl.message(
        'Official contact phone',
        name: 'officialContactPhone',
        desc: 'Translation for the word Official contact phone',
        locale: localeName,
      );
  String get leagueCouncils => Intl.message(
        'League councils',
        name: 'leagueCouncils',
        desc: 'Translation for the word League councils',
        locale: localeName,
      );
  String get activateAccount => Intl.message(
        'Activate account',
        name: 'activateAccount',
        desc: 'Translation for the word Activate Account',
        locale: localeName,
      );

  String get activationText => Intl.message(
        'Please enter the 6 numbers code which was sent to your email',
        name: 'activationText',
        desc:
            'Translation for the word Please enter the 6 numbers code which was sent to your email',
        locale: localeName,
      );

  String get didntReceiveCodeText => Intl.message(
        'Didn\'t receive a code? ',
        name: 'didntReceiveCodeText',
        desc: 'Translation for the word Didn\'',
        locale: localeName,
      );


  String get adddetails => Intl.message(
    'Please fill the Total price',
    name: 'Please fill the Total price',
    desc: 'Translation for the word Ok',
    locale: localeName,);


    String get ok => Intl.message(
        'Ok',
        name: 'ok',
        desc: 'Translation for the word Ok',
        locale: localeName,
      );

  String get cancel => Intl.message(
        'Cancel',
        name: 'cancel',
        desc: 'Translation for the word Cancel',
        locale: localeName,
      );

  String get sendAgain => Intl.message(
        'Resend',
        name: 'sendAgain',
        desc: 'Translation for the word Resend',
        locale: localeName,
      );
  String get mercato => Intl.message(
        'Mercato',
        name: 'mercato',
        desc: 'Translation for the word Mercato',
        locale: localeName,
      );

  String get passwordConfirmation => Intl.message(
        'Password confirmation',
        name: 'passwordConfirmation',
        desc: 'Translation for the word Password confirmation',
        locale: localeName,
      );

  String get save => Intl.message(
        'Save',
        name: 'save',
        desc: 'Translation for the word Save',
        locale: localeName,
      );

  String get password => Intl.message(
        'Password',
        name: 'password',
        desc: 'Translation for the word Password',
        locale: localeName,
      );
  String get passwordNotMatching => Intl.message(
        'Password and password confirmation are not matching',
        name: 'passwordNotMatching',
        desc: 'Translation for the word ',
        locale: localeName,
      );

  String get oldPassword => Intl.message(
        'Old password',
        name: 'oldPassword',
        desc: 'Translation for the word Old password',
        locale: localeName,
      );
  String get accountDetails => Intl.message(
        'Account details',
        name: 'accountDetails',
        desc: 'Translation for the word Account details',
        locale: localeName,
      );
  String get changeLanguage => Intl.message(
        'Change language',
        name: 'changeLanguage',
        desc: 'Translation for the word Change language',
        locale: localeName,
      );
  String get skip => Intl.message(
        'Skip',
        name: 'skip',
        desc: 'Translation for the word Skip',
        locale: localeName,
      );
  String get congratulations => Intl.message(
        'Congratulations',
        name: 'congratulations',
        desc: 'Translation for the word Congratulations',
        locale: localeName,
      );
  String get done => Intl.message(
        'Done',
        name: 'done',
        desc: 'Translation for the word Done',
        locale: localeName,
      );
  String get noMoreResults => Intl.message(
        'No more results',
        name: 'noMoreResults',
        desc: 'Translation for the word No more results',
        locale: localeName,
      );

  String get next => Intl.message(
        'Next',
        name: 'next',
        desc: 'Translation for the word Next',
        locale: localeName,
      );

  String get accountInfo => Intl.message(
        'Account info',
        name: 'accountInfo',
        desc: 'Translation for the word Account info',
        locale: localeName,
      );
  String get email => Intl.message(
        'Email',
        name: 'email',
        desc: 'Translation for the word Email',
        locale: localeName,
      );
  String get hide => Intl.message(
        'Hide',
        name: 'hide',
        desc: 'Translation for the word Hide',
        locale: localeName,
      );

  String get enterCodeText => Intl.message(
        'Enter the 6 numbers code which was sent to your email',
        name: 'enterCodeText',
        desc:
            'Translation for the word Enter the 6 numbers code which was sent to your email',
        locale: localeName,
      );
  String get anEmailHasBeenSentToYourMail => Intl.message(
        'An email has been sent to your mail',
        name: 'anEmailHasBeenSentToYourMail',
        desc: 'Translation for the word An email has been sent to your mail',
        locale: localeName,
      );
  String get resend => Intl.message(
        'Resend',
        name: 'resend',
        desc: 'Translation for the word Resend',
        locale: localeName,
      );
  String get didntReceiveCodeQuestion => Intl.message(
        'Didn\'t receive a code?',
        name: 'didntReceiveCodeQuestion',
        desc: 'Translation for the word Didn',
        locale: localeName,
      );
  String get dontWorryWeAllAlwaysForget => Intl.message(
        'Don\'t worry, we all usually forget..',
        name: 'dontWorryWeAllAlwaysForget',
        desc: 'Translation for the word Don\'t worry, we all usually forget..',
        locale: localeName,
      );
  String get phone => Intl.message(
        'Phone',
        name: 'phone',
        desc: 'Translation for the word Phone',
        locale: localeName,
      );

  String get forgotPasswordText => Intl.message(
        'Just enter your email and we will send you a message with an activation code',
        name: 'forgotPasswordText',
        desc:
            'Translation for the word Just enter your email and we will send you a message with an activation code',
        locale: localeName,
      );
  String get contactUs => Intl.message(
        'Contact us',
        name: 'contactUs',
        desc: 'Translation for the word Contact us',
        locale: localeName,
      );

  String get details => Intl.message(
        'Details',
        name: 'details',
        desc: 'Translation for the word Details',
        locale: localeName,
      );

  String get enterMessageTitle => Intl.message(
        'Enter message title',
        name: 'enterMessageTitle',
        desc: 'Translation for the word Enter message title',
        locale: localeName,
      );

  String get noResultsFound => Intl.message(
        'No results found',
        name: 'noResultsFound',
        desc: 'Translation for the word No results found',
        locale: localeName,
      );
  String get chooseLeaguesYouWantToFollow => Intl.message(
        'Choose leagues you want to follow',
        name: 'chooseLeaguesYouWantToFollow',
        desc: 'Translation for the word Choose leagues you want to follow',
        locale: localeName,
      );
  String get home => Intl.message(
        'Home',
        name: 'home',
        desc: 'Translation for the word Home',
        locale: localeName,
      );
  String get profileInformation => Intl.message(
        'Profile Information',
        name: 'profileInformation',
        desc: 'Translation for the word Profile Information',
        locale: localeName,
      );
  String get setting => Intl.message(
        'Setting',
        name: 'setting',
        desc: 'Translation for the word Setting',
        locale: localeName,
      );
  String get notification => Intl.message(
        'Notification',
        name: 'notification',
        desc: 'Translation for the word Notifcation',
        locale: localeName,
      );
  String get deliveryRequests => Intl.message(
        'Delivery requests',
        name: 'deliveryRequests',
        desc: 'Translation for the word Delivery Requests',
        locale: localeName,
      );
  String get aboutCo => Intl.message(
        'About co',
        name: 'aboutCo',
        desc: 'Translation for the word About co',
        locale: localeName,
      );
  String get whatsapp => Intl.message(
        'Contact Us via Whatsapp',
        name: 'whatsapp',
        desc: 'Translation for the word Contact Us via Whatsapp',
        locale: localeName,
      );
  String get driverReg => Intl.message(
        'Register as Driver',
        name: 'driverReg',
        desc: 'Translation for the word Register as Driver',
        locale: localeName,
      );
  String get ourPolicy => Intl.message(
        'Our Policy',
        name: 'ourPolicy',
        desc: 'Translation for the word Our policy',
        locale: localeName,
      );
  String get registration => Intl.message(
        'Registration',
        name: 'registration',
        desc: 'Translation for the word Registration',
        locale: localeName,
      );
  String get verifyYourNumber => Intl.message(
        'Verify Your Number',
        name: 'verifyYourNumber',
        desc: 'Translation for the word Verify Your Number',
        locale: localeName,
      );
  String get verifyNumberText => Intl.message(
        'Please enter your mobile number to receive a verification code',
        name: 'verifyNumberText',
        desc:
            'Translation for the word Please enter your mobile number to receive a verification code',
        locale: localeName,
      );
  String get mobileNumber => Intl.message(
        'Mobile Number',
        name: 'mobileNumber',
        desc: 'Translation for the word Mobile Number',
        locale: localeName,
      );
  String get send => Intl.message(
        'Send',
        name: 'send',
        desc: 'Translation for the word Send',
        locale: localeName,
      );
  String get noOtherTime => Intl.message(
        'No, other time',
        name: 'noOtherTime',
        desc: 'Translation for the word No, other time',
        locale: localeName,
      );
  String get verificationCode => Intl.message(
        'Verification Code',
        name: 'verificationCode',
        desc: 'Translation for the word Verification Code',
        locale: localeName,
      );
  String get verificationCodeText => Intl.message(
        'Please enter verification code that get from sms',
        name: 'verificationCodeText',
        desc:
            'Translation for the word Please enter verification code that get from sms',
        locale: localeName,
      );
  String get verify => Intl.message(
        'Verify',
        name: 'verify',
        desc: 'Translation for the word Verify',
        locale: localeName,
      );
  String get resendCode => Intl.message(
        'Resend Code',
        name: 'resendCode',
        desc: 'Translation for the word Resend Code',
        locale: localeName,
      );
  String get yourName => Intl.message(
        'Your Name',
        name: 'yourName',
        desc: 'Translation for the word Your Name',
        locale: localeName,
      );
  String get successfullyRegistered => Intl.message(
        'successfully registered',
        name: 'successfullyRegistered',
        desc: 'Translation for the word successfully registered',
        locale: localeName,
      );
  String get successfullyRegisteredText => Intl.message(
        'The number has been successfully activated, you can now complete the order',
        name: 'successfullyRegisteredText',
        desc:
            'Translation for the word The number has been successfully activated, you can now complete the order',
        locale: localeName,
      );
  String get changedSuccessfully => Intl.message(
        'Changed Successfully',
        name: 'changedSuccessfully',
        desc: 'Translation for the word Changed Successfully',
        locale: localeName,
      );
  String get changedSuccessfullyText => Intl.message(
        'Your account information has been changed successfully',
        name: 'changedSuccessfullyText',
        desc:
            'Translation for the word Your account information has been changed successfully',
        locale: localeName,
      );
  String get newWord => Intl.message(
        'New',
        name: 'newWord',
        desc: 'Translation for the word New',
        locale: localeName,
      );
  String get continueWord => Intl.message(
        'Continue',
        name: 'continueWord',
        desc: 'Translation for the word Continue',
        locale: localeName,
      );
  String get sure => Intl.message(
        'sure',
        name: 'sure',
        desc: 'Translation for the word sure',
        locale: localeName,
      );
        String get deleteaccountcon => Intl.message(
        'deleteaccountcon',
        name: 'deleteaccountcon',
        desc: 'Translation for the word sure',
        locale: localeName,
      );
        String get deleteaccountconf => Intl.message(
        'deleteaccountconf',
        name: 'deleteaccountconf',
        desc: 'Translation for the word sure',
        locale: localeName,
      );
  String get sureText => Intl.message(
        'Are you sure you want to cancel your order?',
        name: 'sureText',
        desc:
            'Translation for the word Are you sure you want to cancel your order?',
        locale: localeName,
      );
  String get yes => Intl.message(
        'Yes',
        name: 'yes',
        desc: 'Translation for the word Yes',
        locale: localeName,
      );
  String get no => Intl.message(
        'No',
        name: 'no',
        desc: 'Translation for the word No',
        locale: localeName,
      );
  String get thanks => Intl.message(
        'Thanks',
        name: 'thanks',
        desc: 'Translation for the word Thanks',
        locale: localeName,
      );
  String get thanksText => Intl.message(
        'Thanks for your review',
        name: 'thanksText',
        desc: 'Translation for the word Thanks for your review',
        locale: localeName,
      );
  String get addLocation => Intl.message(
        'Add Location',
        name: 'addLocation',
        desc: 'Translation for the word Add Location',
        locale: localeName,
      );
  String get title => Intl.message(
        'Title',
        name: 'title',
        desc: 'Translation for the word title',
        locale: localeName,
      );
  String get streetName => Intl.message(
        'Street name',
        name: 'streetName',
        desc: 'Translation for the word Street name',
        locale: localeName,
      );
  String get city => Intl.message(
        'City',
        name: 'city',
        desc: 'Translation for the word City',
        locale: localeName,
      );
  String get deliveryAddress => Intl.message(
        'Delivery Address',
        name: 'deliveryAddress',
        desc: 'Translation for the word Delivery Address',
        locale: localeName,
      );
  String get addNewAddress => Intl.message(
        'Add New Address',
        name: 'addNewAddress',
        desc: 'Translation for the word Add New Address',
        locale: localeName,
      );
  String get completeOrder => Intl.message(
        'Complete Order',
        name: 'completeOrder',
        desc: 'Translation for the word Complete Order',
        locale: localeName,
      );
  String get deliveryMethod => Intl.message(
        'Delivery method',
        name: 'deliveryMethod',
        desc: 'Translation for the word Delivery method',
        locale: localeName,
      );
  String get delivery => Intl.message(
        'Delivery',
        name: 'delivery',
        desc: 'Translation for the word Delivery',
        locale: localeName,
      );
  String get fromTheRestaurant => Intl.message(
        'From The Restaurant',
        name: 'fromTheRestaurant',
        desc: 'Translation for the word From The Restaurant',
        locale: localeName,
      );
  String get address => Intl.message(
        'Address',
        name: 'address',
        desc: 'Translation for the word Address',
        locale: localeName,
      );
  String get change => Intl.message(
        'change',
        name: 'change',
        desc: 'Translation for the word change',
        locale: localeName,
      );
  String get paymentMethod => Intl.message(
        'Payment Method',
        name: 'paymentMethod',
        desc: 'Translation for the word Payment Method',
        locale: localeName,
      );
  String get addOne => Intl.message(
        'add one',
        name: 'addOne',
        desc: 'Translation for the word add one',
        locale: localeName,
      );
  String get haveACoupon => Intl.message(
        'have a coupon ?',
        name: 'haveACoupon',
        desc: 'Translation for the word have a coupon ?',
        locale: localeName,
      );
  String get noprod => Intl.message(
    'noprod',
    name: 'noprod',
    desc: 'Translation for the word Subtotal',
    locale: localeName,
  );

  String get productname => Intl.message(
    'productname',
    name: 'productname',
    desc: 'Translation for the word Subtotal',
    locale: localeName,
  );
  String get fprice => Intl.message(
    'fprice',
    name: 'fprice',
    desc: 'Translation for the word Subtotal',
    locale: localeName,
  );
  String get countt => Intl.message(
    'countt',
    name: 'countt',
    desc: 'Translation for the word Subtotal',
    locale: localeName,
  );



  String get subTotal => Intl.message(
        'Subtotal',
        name: 'subTotal',
        desc: 'Translation for the word Subtotal',
        locale: localeName,
      );
  String get checkout => Intl.message(
        'Checkout',
        name: 'checkout',
        desc: 'Translation for the word Checkout',
        locale: localeName,
      );
  String get yourCart => Intl.message(
        'Your Cart',
        name: 'yourCart',
        desc: 'Translation for the word Your Cart',
        locale: localeName,
      );
  String get deliveryCost => Intl.message(
        'Delivery Cost',
        name: 'deliveryCost',
        desc: 'Translation for the word Delivery Cost',
        locale: localeName,
      );
  String get offers => Intl.message(
        'Offers',
        name: 'offers',
        desc: 'Translation for the word Offers',
        locale: localeName,
      );
  String get creditCard => Intl.message(
        'Credit Card',
        name: 'creditCard',
        desc: 'Translation for the word Credit Card',
        locale: localeName,
      );
  String get payOnDelivery => Intl.message(
        'Pay on delivery',
        name: 'payOnDelivery',
        desc: 'Translation for the word Pay on delivery',
        locale: localeName,
      );
  String get cardholderName => Intl.message(
        'Cardholder name',
        name: 'cardholderName',
        desc: 'Translation for the word Cardholder name',
        locale: localeName,
      );
  String get cardNumber => Intl.message(
        'Card number',
        name: 'cardNumber',
        desc: 'Translation for the word Card number',
        locale: localeName,
      );
  String get expiryDate => Intl.message(
        'Expiry date',
        name: 'expiryDate',
        desc: 'Translation for the word Expiry date',
        locale: localeName,
      );
  String get cvv => Intl.message(
        'CVV',
        name: 'cvv',
        desc: 'Translation for the word CVV',
        locale: localeName,
      );
  String get pay => Intl.message(
        'Pay',
        name: 'pay',
        desc: 'Translation for the word Pay',
        locale: localeName,
      );
  String get id => Intl.message(
        'ID',
        name: 'id',
        desc: 'Translation for the word ID',
        locale: localeName,
      );
  String get minimumPrice => Intl.message(
        'Minimum price',
        name: 'minimumPrice',
        desc: 'Translation for the word Minimun price',
        locale: localeName,
      );
  String get calories => Intl.message(
        'Calories',
        name: 'calories',
        desc: 'Translation for the word Calories',
        locale: localeName,
      );
  String get min => Intl.message(
        'min',
        name: 'min',
        desc: 'Translation for the word min',
        locale: localeName,
      );
  String get deliveryTime => Intl.message(
        'Delivery time',
        name: 'deliveryTime',
        desc: 'Translation for the word Delivery time',
        locale: localeName,
      );
  String get additions => Intl.message(
        'ADDITIONS',
        name: 'additions',
        desc: 'Translation for the word ADDITIONS',
        locale: localeName,
      );
  String get dessert => Intl.message(
        'DESSERT',
        name: 'dessert',
        desc: 'Translation for the word dessert',
        locale: localeName,
      );
  String get snacks => Intl.message(
        'SNACKS',
        name: 'snacks',
        desc: 'Translation for the word SNACKS',
        locale: localeName,
      );
  String get myRequests => Intl.message(
        'My Requests',
        name: 'myRequests',
        desc: 'Translation for the word My Requests',
        locale: localeName,
      );
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
