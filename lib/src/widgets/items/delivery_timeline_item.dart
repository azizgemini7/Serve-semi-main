import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:flutter/material.dart';

class DeliveryTimelineItem extends StatelessWidget {
  final bool isNext;
  final bool isActive;

  final String statusDescription;
  final int status;
  final onStartTrackingClicked;
  final String statusName;

  final bool isLast;

  const DeliveryTimelineItem(
      {Key key,
      this.isNext = false,
      this.isActive = false,
      this.statusDescription,
      this.statusName,
      this.isLast = false,
      this.status,
      this.onStartTrackingClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: status!=3&&status!=1,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: isActive || isNext
                            ? Theme.of(context).accentColor
                            : Theme.of(context).accentColor.withOpacity(0.5),
                        width: isActive || isNext ? 3.0 : 2.0,
                      )),
                  child: isActive
                      ? Icon(
                          Icons.done,
                          color: Colors.black,
                          size: 15.0,
                        )
                      : Container(),
                ),
                if (!isLast)
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        constraints: BoxConstraints(minHeight: 60.0),
                        width: 2.0,
                        color: Color(0xFFEEEEEE),
                      ),
                      SizedBox(
                        width: 40.0,
                        height: 15.0,
                        child: Container(
                          transform: Matrix4.translationValues(0.0, -15.0, 0.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFFEEEEEE),
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox(
                    width: 40.0,
                  ),
              ],
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  statusName ,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  statusDescription,
                  style: TextStyle(color: Colors.black, fontSize: 12.0),
                ),
                if (onStartTrackingClicked != null)
                  Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: 100.0,
                        child: MyCustomFormButton(
                          onPressedEvent: onStartTrackingClicked,
//                        padding: const EdgeInsets.all(10.0),
                          height: 30.0,
                          buttonText: AppLocalizations.of(context).track,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
//        Text(
//          'actionDate',
//          style: TextStyle(color: Color(0xFF7E7E7E), fontSize: 11.0),
//        ),
        ],
      ),
    );
  }
}
