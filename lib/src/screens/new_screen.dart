import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/widgets/items/restaurant_item.dart';
import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  final List<String> _restaurants = [
    'Starbuks',
    'Costa Coffee',
    'Pret',
    'Starbuks',
    'Costa Coffee',
    'Pret',
  ];
  List<String> chats=[];
   List<String> iamges=[];
  static const routeName = '/new';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).newWord,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        elevation: 1,
      ),
      body: 
      
      
       ListView.separated(
        padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
        itemCount: _restaurants.length,
        itemBuilder: (_, index) {
          return RestaurantItem(name: _restaurants[index], isClosed: true);
        },
        separatorBuilder: (_, idx) => SizedBox(
          height: 10,
        ),
      ),
    );
  }
}
