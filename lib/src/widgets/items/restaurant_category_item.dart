import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:flutter/material.dart';

class RestaurantCategoryItem extends StatelessWidget {
  final name;
  final bool selected;
  final onTap;

  const RestaurantCategoryItem(
      {Key key, this.name, this.onTap, this.selected = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !selected ? onTap : null,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        
        duration: Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        decoration: BoxDecoration(
          // color:  Colors.grey.withOpacity(0.3),
          shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2,
              color: selected ? Color.fromARGB(255, 57, 186, 186) : Color.fromARGB(255, 77, 75, 75))),
        child: Row(
          children: <Widget>[
            if (selected)
              Padding(
                padding: EdgeInsets.only(
                    right: AppLocalizations.of(context).isArabic ? 0.0 : 14.0,
                    left: AppLocalizations.of(context).isArabic ? 14.0 : 0.0),
                child: Icon(
                  Icons.check,
                ),
              ),
            Text(
              name ?? '',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: selected ? Color(0xDE000000) : Color(0x61000000),
                  letterSpacing:
                      AppLocalizations.of(context).isArabic ? null : 0.25),
            ),
          ],
        ),
      ),
    );
  }
}
