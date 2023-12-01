import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/addition.dart';
import 'package:Serve_ios/src/models/cart_restaurant.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/models/meal.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/providers/cart.dart';
import 'package:Serve_ios/src/providers/restaurants.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:Serve_ios/src/widgets/items/addition_item.dart';
import 'package:Serve_ios/src/widgets/items/meal_bar_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MealScreen extends StatefulWidget {
  static const routeName = '/meal';

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> with AlertsMixin {
  CarouselController _carouselController = CarouselController();
  int _activeIndex = 0;
  int _selectedCategory;
  Restaurants _restaurantsReference;
  int _mealId;
  int _restaurantId;
  int _productId;
  bool _isLoading = false;
  Auth _authReference;
  bool _gotMealDetails = false;
  Meal _meal;

  int _selectedAdditionCategory = 0;

  List<Addition> _selectedAdditions = [];

  Future<void> _getMealDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _meal = await _restaurantsReference.getMealDetails(_mealId);
    } on HttpException catch (error) {
      if (error.statusCode == 401) {
        _authReference.logoutDone();
      } else {
        showErrorDialog(context, error.toString());
      }
    } catch (error) {
      throw error;
    } finally {
      if (this.mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  double _getFinalPrice(mCount) {
    double price = 0.0;
    _selectedAdditions.forEach((element) {
      price += element.price * (_additionsCount[element.id] ?? 1);
    });
    price += (_meal?.price ?? 0.0) * mCount;
    return price;
  }

  int _mealsCount = 1;

  Map<int, int> _additionsCount = {};

  @override
  void didChangeDependencies() {
    _restaurantsReference = Provider.of<Restaurants>(context);
    _authReference = Provider.of<Auth>(context, listen: false);
    final args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
      _mealId = args['mealId'];
      _productId = args['productId'];
      _restaurantId = args['restaurantId'];
      if (!_gotMealDetails) {
        _getMealDetails();
        _gotMealDetails = true;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = _restaurantsReference.restaurants.singleWhere(
        (element) => element.id == _restaurantId,
        orElse: () => null);
    final product = restaurant?.products?.singleWhere(
        (element) => element.id == _productId,
        orElse: () => null);
    if (_meal == null) {
      _meal = product?.meals
          ?.singleWhere((element) => element.id == _mealId, orElse: () => null);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant?.title ?? ''),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (restaurant?.cover != null || _isLoading)
            CarouselSlider(
              carouselController: _carouselController,
              items: [
                if (_isLoading && _meal?.photos?.length == 0)
                  Shimmer.fromColors(
                    child: Container(
                      color: Colors.white,
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    direction: AppLocalizations.of(context).isArabic
                        ? ShimmerDirection.rtl
                        : ShimmerDirection.ltr,
                  )
                else
                  ..._meal?.photos
                      ?.map((e) => InkWell(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                imageUrl: e.photo,
                                placeholder: (_, __) => Container(),
                              ),
                            ),
                          ))
                      ?.toList()
              ],
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: 180.0,
                initialPage: 0,
                enlargeCenterPage: false,
                enableInfiniteScroll: true,
                autoPlay: true,
                scrollPhysics: ClampingScrollPhysics(),
                onPageChanged: (int index, reason) {
                  setState(() {
                    _activeIndex = index;
                  });
                },
              ),
            ),
          MealBarItem(
            name: _meal?.title ?? '',
            id: _mealId,
            photo: _meal?.photo,
            description: _meal?.description,
            calories: _meal?.calories,
            deliveryTime: _meal?.deliveryTime,
            price: _meal?.price?.toDouble(),
            context: context,
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 70.0,
                  child: ListView.builder(
                    itemBuilder: (_, int i) => InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAdditionCategory = i;
                        });
                      },
                      child: AdditionItem(
                        selected: _selectedAdditionCategory == i,
                        title: _meal.additionCategories[i].name,
                      ),
                    ),
                    itemCount: _meal?.additionCategories?.length ?? 0,
                    physics: BouncingScrollPhysics(),
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                  padding: const EdgeInsets.only(left: 40.0),
                  itemCount: (_meal?.additionCategories?.length ?? 0) == 0
                      ? 0
                      : _meal?.additionCategories
                              ?.elementAt(_selectedAdditionCategory)
                              ?.prod
                              ?.length ??
                          0,
                  separatorBuilder: (_, int i) => Divider(
                    color: Color(0xFF707070).withOpacity(0.1),
                  ),
                  itemBuilder: (_, int i) {
                    final addition = _meal?.additionCategories
                        ?.elementAt(_selectedAdditionCategory)
                        ?.prod
                        ?.elementAt(i);
                    return ExpansionTile(
                      leading: Checkbox(
                          value: _selectedAdditions.indexWhere(
                                  (element) => element.id == addition.id) !=
                              -1,
                          onChanged: (bool val) {
                            final additionIndex = _selectedAdditions.indexWhere(
                                (element) => element.id == addition?.id);
                            if (val) {
                              if (additionIndex == -1)
                                setState(() {
                                  _selectedAdditions.add(addition);
                                });
                            } else {
                              if (additionIndex != -1)
                                setState(() {
                                  _selectedAdditions.removeAt(additionIndex);
                                });
                            }
                          }),
                      trailing: Text(
                        '+ ${_meal?.additionCategories?.elementAt(_selectedAdditionCategory)?.prod?.elementAt(i)?.price} ${AppLocalizations.of(context).sar}',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      title: Text(
                        _meal?.additionCategories
                                ?.elementAt(_selectedAdditionCategory)
                                ?.prod
                                ?.elementAt(i)
                                ?.name ??
                            '',
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if ((_additionsCount[addition.id] ?? 1) >
                                          1)
                                        setState(() {
                                          _additionsCount[addition.id]--;
                                        });
                                    },
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: Container(
                                      width: 28.0,
                                      height: 28.0,
                                      child: Icon(
                                        Icons.remove,
                                        size: 18,
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50.0,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${_additionsCount[addition.id] ?? 1}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF242C37),
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_additionsCount[addition.id] !=
                                          null) {
                                        setState(() {
                                          _additionsCount[addition.id]++;
                                        });
                                      } else {
                                        setState(() {
                                          _additionsCount[addition.id] = 2;
                                        });
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: Container(
                                      width: 28.0,
                                      height: 28.0,
                                      child: Icon(
                                        Icons.add,
                                        size: 18.0,
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                )),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, -2.0),
                  blurRadius: 2.0),
            ], color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                MyCustomFormButton(
                  onPressedEvent: () async {
                    await Provider.of<Cart>(context, listen: false).addToCart(
                        CartRestaurant(
                            additions: _selectedAdditions,
                            cartItemId:
                                '$_restaurantId-$_mealId.$_mealsCount-${_selectedAdditions?.map((e) => e.id)?.join(',')}',
                            additionsCount: _additionsCount,
                            deliveryPrice: restaurant.deliveryPrice.toDouble(),
                            meals: [_meal],
                            discount: 0.0,
                            mealsCount: _mealsCount,
                            orderPrice: _getFinalPrice(_mealsCount),
                            restaurant: restaurant));
                    Navigator.of(context).pop(true);
                  },
                  fontSize: 13.0,
                  buttonText:
                      '${_getFinalPrice(_mealsCount)} ${AppLocalizations.of(context).sar}  |  ${AppLocalizations.of(context).add}',
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (_mealsCount != 1)
                          setState(() {
                            _mealsCount--;
                          });
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        width: 28.0,
                        height: 28.0,
                        child: Icon(
                          Icons.remove,
                          size: 18,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(color: Colors.grey)),
                      ),
                    ),
                    Container(
                      width: 50.0,
                      alignment: Alignment.center,
                      child: Text(
                        '$_mealsCount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF242C37),
                            fontSize: 14.0),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _mealsCount++;
                        });
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        width: 28.0,
                        height: 28.0,
                        child: Icon(
                          Icons.add,
                          size: 18.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(color: Colors.grey)),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
