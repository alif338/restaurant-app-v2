import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/detail_page.dart';

import 'data/model/list_restaurant.dart';
import 'data/providers/detail_providers.dart';

class RestaurantCard extends StatefulWidget {
  final ListRestaurants listRestaurants;

  RestaurantCard({
    required this.listRestaurants
  });

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(
              // builder: (_) => ChangeNotifierProvider(
              //   create: (BuildContext context) => DetailProviders(id: widget.listRestaurants.id),
              //   child: DetailPage(listRestaurants: widget.listRestaurants))
              builder: (_) => ChangeNotifierProvider.value(
                value: DetailProviders(id: widget.listRestaurants.id),
                child: DetailPage(listRestaurants: widget.listRestaurants,),
              )
            )
            );
          },
          child: Container(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Hero(
                  tag: 'RestoImage${widget.listRestaurants.name}',
                  child: Card(
                    elevation: 2,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.network(
                        "https://restaurant-api.dicoding.dev/images/medium/${widget.listRestaurants.pictureId}",
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, object, stackTrace) {
                          return Container(
                            color: Color(0xff6c6c6c),
                            height: 180,
                            child: Center(
                              child: Icon(Icons.error_outline),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Text("${widget.listRestaurants.name}", textScaleFactor: 1.5, style: TextStyle(
                  height: 1.6,
                  ),
                ),
                Text("${widget.listRestaurants.city}, Indonesia", textScaleFactor: 1.2,
                  style: TextStyle(
                      height: 1.4,
                      fontFamily: 'ChivoRegular'
                  ),
                ),
                Builder(
                  builder: (context) {
                    return Row(
                      children: [
                        Container(
                          height: 20,
                          child: RatingBarIndicator(
                            itemCount: 5,
                            direction: Axis.horizontal,
                            rating: widget.listRestaurants.rating,
                            itemSize: 20,
                            // itemPadding: EdgeInsets.symmetric(horizontal: 0),
                            itemBuilder: (context, items)
                              => Icon(Icons.star, color:Color(0xFFEFA641)),
                          ),
                        ),
                        Text("  (${widget.listRestaurants.rating})", textScaleFactor: 1.2,
                          style: TextStyle(fontFamily: 'ChivoLight'),)
                      ],
                    );
                  }
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            child: InkWell(
              onTap: (){
                print('FAVORITE ${widget.listRestaurants.name}');
              },
              child: Icon(Icons.favorite_border_sharp, color: Colors.white,size: 25,)
            )
          ),
        ),
      ],
    );
  }
}
