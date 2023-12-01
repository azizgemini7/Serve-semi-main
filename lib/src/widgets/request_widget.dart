import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/models/order.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/screens/chatscreen.dart';
import 'package:Serve_ios/src/screens/order_tracking_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class RequestWidget extends StatelessWidget {
  final Order order;

  const RequestWidget({Key key, this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(OrderTrackingScreen.routeName, arguments: order.id),
      child: Container(
        color: Color(0xFFFCFCFC),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: order?.photo != null
                  ? CachedNetworkImageProvider(order?.photo)
                  : null,
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    order?.restaurantName ?? '',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xDE000000)),
                  ),
                  Text(
                    order.description ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7E7E7E),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    order.statusName ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121)),
                  ),
                SizedBox(height: 5,),

                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).orderdate  ,
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF242C37),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        order.date ,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF242C37),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                SizedBox(height: 10,),
                InkWell(
                    onTap: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (builder){

                            return Container(decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))

                            ),
                              child: Column(

                                children: [
                                  SizedBox(height: 10,),
                                  Text(AppLocalizations.of(context).orderdetails,style: TextStyle(fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Container(width: double.infinity,height: 1,color: Colors.grey[100],),
                                  SizedBox(height: 20,),
                                  Visibility(
                                    visible: order.details.toString().length>4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child:
                                        Row(
                                          children: [
                                            Icon(Icons.info),SizedBox(width: 10,),
                                            Expanded(child: Text( order.details.toString(),style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey),)),
                                          ],
                                        ),),
                                    ),
                                  ),
                                  Visibility(
                                    visible:order.  finalPrice>0,
                                    child:   Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(children: [
                                        Icon(Icons.money),
                                        SizedBox(width: 10,),

                                        Text(AppLocalizations.of(context).subTotal,style: TextStyle(fontWeight: FontWeight.w700),),
                                        Spacer(),
                                        Text(order.  finalPrice.toString()+' '+AppLocalizations.of(context).sar,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                                      ],),
                                    ),),
                                  order.myproducts.length==0?Padding(
                                      padding: EdgeInsets.only(top: 50,left: 10,right: 10),
                                      child: Text(AppLocalizations.of(context).noprod,style: TextStyle(fontWeight: FontWeight.w700),)):
                                  SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(order.myproducts.length, (index) => Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(color: Colors.grey[200]),
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(children: [
                                              Text(AppLocalizations.of(context).productname,style: TextStyle(fontWeight: FontWeight.w700),),
                                              Spacer(),
                                              Text(AppLocalizations.of(context).isArabic? order.myproducts[index].title:order.myproducts[index].title_en,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                                            ],),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(children: [
                                              Text(AppLocalizations.of(context).fprice,style: TextStyle(fontWeight: FontWeight.w700),),
                                              Spacer(),
                                              Text( order.myproducts[index].price+' '+AppLocalizations.of(context).sar,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                                            ],),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(children: [
                                              Text(AppLocalizations.of(context).countt,style: TextStyle(fontWeight: FontWeight.w700),),
                                              Spacer(),
                                              Text( order.myproducts[index].quantity,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                                            ],),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(children: [
                                              Text(AppLocalizations.of(context).subTotal,style: TextStyle(fontWeight: FontWeight.w700),),
                                              Spacer(),
                                              Text( order.myproducts[index].final_price+' '+AppLocalizations.of(context).sar,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                                            ],),
                                          ),
                                        ],),
                                      )),
                                    ),
                                  )

                                ],),);

                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.grey[200],
                      border: Border.all(width: 1,color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        AppLocalizations.of(context).orderdetails ,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500]),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Column(
              children: <Widget>[
                Text(
                  '${order?.finalPrice ?? ''} ${AppLocalizations.of(context).sar}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212C3A)),
                ),
                SizedBox(height: 10,),
              Visibility(
                visible:order?.status==5 ,
                child:   double.parse(order?. rate)=='-1'?
                Text(AppLocalizations.of(context).rating,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 11,color: Colors.amber),):  RatingBar.builder(
   initialRating: double.parse(order?. rate),
   minRating: 1,
   direction: Axis.horizontal,
   ignoreGestures: true,
   itemCount: 5,
   itemSize: 8,

   itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
   itemBuilder: (context, _) => Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: (rating) {
  
   },
),),
                  Visibility(
                visible:order?.status==2 ,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: (){ 
                             Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>   Chatscreen(orderid:order?.id.toString()  ,userid:  Provider.of<Auth>(context, listen: false).userId.toString(),deliverlat: order?.latitude,deliverlong: order?.logitude, ),
  ));
                  },
                  child: Container(width: 40,height: 40,decoration: BoxDecoration(shape: BoxShape.circle,
              color: Colors.white),child: Icon(Icons.message),),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
