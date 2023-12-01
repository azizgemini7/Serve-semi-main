import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:Serve_ios/src/widgets/items/restaurant_meal_item.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order_screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Map<String, Object>> checkValues = [
    {'name': 'Caramel', 'checked': false, 'cost': '3'},
    {'name': 'Vanilla', 'checked': false, 'cost': '1.5'},
    {'name': 'Hazelnut', 'checked': false, 'cost': '4'},
    {'name': 'Espresso standard', 'checked': false, 'cost': '1'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Starbuks',
          style: TextStyle(
              letterSpacing: 0.26,
              color: Color(0xDE000000),
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/slider_image.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          RestaurantMealItem(
            isForOrder: true,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 18,
              ),
              Column(
                children: <Widget>[
                  RotatedBox(
                    child: Text(
                      AppLocalizations.of(context).additions,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.07,
                          fontSize: 12),
                    ),
                    quarterTurns: 3,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RotatedBox(
                    child: Text(
                      AppLocalizations.of(context).dessert,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.07,
                          fontSize: 12),
                    ),
                    quarterTurns: 3,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RotatedBox(
                    child: Text(
                      AppLocalizations.of(context).snacks,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.07,
                          fontSize: 12),
                    ),
                    quarterTurns: 3,
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width - 125,
                child: ListView.separated(
                  separatorBuilder: (_, i) => Divider(
                    color: Color(0xFF707070).withOpacity(0.1),
                    indent: 13,
                  ),
                  itemCount: checkValues.length,
                  itemBuilder: (_, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: checkValues[index]['checked'] ? 0 : 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 18,
                            child: Checkbox(
                              value: checkValues[index]['checked'],
                              onChanged: (val) {
                                setState(() {
                                  checkValues[index]['checked'] = val;
                                });
                              },
                            ),
                          ),
                          Text(
                            checkValues[index]['name'],
                            style: TextStyle(
                                color: Color(0xDE000000),
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '+ ${checkValues[index]['cost']} ${AppLocalizations.of(context).sar}',
                                style: TextStyle(
                                    color: Color(0xFF212C3A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                              SizedBox(
                                height: checkValues[index]['checked'] ? 16 : 0,
                              ),
                              checkValues[index]['checked']
                                  ? Row(
                                      children: <Widget>[
                                        Icon(Icons.remove,
                                            size: 18, color: Color(0xFFC4C4C4)),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '2',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color(0xFF242C37)),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(Icons.add, size: 18),
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: checkValues[index]['checked'] ? 16 : 0,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 19, right: 20, left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0x0D000000),
                    offset: Offset(0, -2),
                    blurRadius: 2)
              ],
            ),
            child: Row(
              children: <Widget>[
                MyCustomFormButton(
                  buttonText: '116 sar   |   Add',
                  onPressedEvent: () {},
                ),
                Spacer(),
                Icon(
                  Icons.remove_circle,
                  size: 33,
                ),
                SizedBox(
                  width: 20,
                ),
                Text('2'),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.add_circle,
                  size: 33,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
