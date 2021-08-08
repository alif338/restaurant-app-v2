import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/providers/main_providers.dart';
import 'package:restaurant_app/data/resultstate.dart';
import 'package:restaurant_app/restaurant_card.dart';
import 'package:restaurant_app/search_page.dart';
import 'package:shimmer/shimmer.dart';

import 'data/model/list_restaurant.dart';
import 'data/model/restaurants.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  List<ListRestaurants> restaurants = [];
  final _scrollController = ScrollController();
  bool _onTopPage = true;

  Future<void> loadData() async {
    await rootBundle.loadString('assets/local_restaurant.json')
        .then((value) {
      final Map<String, dynamic> data = json.decode(value);
      final result = Restaurant.fromJson(data);
      setState(() {
        restaurants = result.restaurants;
      });
      print(result);
    });
  }

  @override
  void initState() {
    super.initState();
    // loadData();
    _scrollController..addListener(() {
      setState(() {
        if (_scrollController.offset >= 400) {
          _onTopPage = false;
        } else {
          _onTopPage = true;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff89a66b),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text('Restaurants',textScaleFactor: 1.5,
                style: TextStyle(
                    fontFamily: 'ChivoHeadings'
                ),
              ),
              SizedBox(height: 8,),
              Builder(
                builder: (context) {
                  return OpenContainer(
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    closedBuilder: (context, openContainer) {
                      return Container(
                        height: 40,
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: "Search",
                            enabled: false,
                            prefixIcon: Icon(Icons.search, color: Colors.white,),
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none
                            ),
                            filled: true,
                            fillColor: Colors.white30,
                            hintStyle: TextStyle(color: Colors.white, fontFamily: 'ChivoRegular')
                          ),
                          onTap: (){
                            print("READY to EDIT");
                            openContainer();
                          },
                        ),
                      );
                    },
                    openBuilder: (context, closeContainer) {
                      return SearchPage(listRestaurants: restaurants,);
                    }
                  );
                }
              ),
              SizedBox(height: 16,),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))
        ),
        elevation: 0,
        toolbarHeight: 140,
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => MainProviders(),
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Consumer<MainProviders>(
                builder: (context, snapshot, _) {
                  if (snapshot.state == ResultState.HasData) {
                    restaurants = snapshot.result.restaurants;
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(restaurants.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          child: RestaurantCard(
                            listRestaurants: restaurants[index],
                          ),
                        );
                      }),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(5, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0x1F000000),
                                highlightColor: Color(0x66000000),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                  )
                                ),
                              ),
                              SizedBox(height: 12,),
                              Shimmer.fromColors(
                                baseColor: Color(0x1F000000),
                                highlightColor: Color(0x66000000),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                ),
                              ),
                              SizedBox(height: 12,),
                              Shimmer.fromColors(
                                baseColor: Color(0x1F000000),
                                highlightColor: Color(0x66000000),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                ),
                              ),
                              SizedBox(height: 24,)
                            ],
                          );
                        }),
                      )
                    );
                  }
                }
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _onTopPage ? null : FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0, duration: Duration(seconds: 2), curve: Curves.easeInOutCubic);
        },
        child: Icon(Icons.arrow_upward, color: Color(0xff89a66b)),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
    );
  }
}
