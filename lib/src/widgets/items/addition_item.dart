import 'package:flutter/material.dart';

class AdditionItem extends StatelessWidget {
  final String title;
  final bool selected;

  const AdditionItem({Key key, this.title, this.selected = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: RotatedBox(
        quarterTurns: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: selected ? 1 : 0.5,
              child: Text(
                title?.toUpperCase() ?? '',
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 5.0,
              height: 5.0,
              decoration: BoxDecoration(
                  color:
                      selected ? Theme.of(context).accentColor : Colors.white,
                  shape: BoxShape.circle),
            )
          ],
        ),
      ),
    );
  }
}
