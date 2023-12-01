import 'package:flutter/material.dart';

class RestaurantProductCategory extends StatelessWidget {
  final onTap;
  final String title;
  final bool selected;

  const RestaurantProductCategory(
      {Key key, this.onTap, this.title, this.selected = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        alignment: Alignment.center,
        child: Text(
          title ?? '',
          style: TextStyle(
              color: Color(0xFF212C3A),
              fontSize: 13.0,
              fontWeight: FontWeight.w500),
        ),
        decoration: BoxDecoration(
          border: Border(
              bottom: selected
                  ? BorderSide(color: Theme.of(context).accentColor, width: 2.0)
                  : BorderSide.none),
        ),
      ),
    );
  }
}
