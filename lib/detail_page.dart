import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/providers/detail_providers.dart';
import 'package:restaurant_app/review_page.dart';
import 'package:shimmer/shimmer.dart';

import 'data/model/list_restaurant.dart';
import 'data/resultstate.dart';

class DetailPage extends StatefulWidget {
  final ListRestaurants listRestaurants;

  const DetailPage({
    Key? key, required this.listRestaurants
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin{
  final _scrollController = ScrollController(initialScrollOffset: 0);
  bool _showTopPage = true;
  bool _showAppBar = false;

  @override
  void initState() {
    _scrollController..addListener(() {
      setState(() {
        if (_scrollController.offset >= 300){
          _showAppBar = true;
        } else {
          _showAppBar = false;
        }
        if(_scrollController.offset >= 400) {
          _showTopPage = false;
        } else {
          _showTopPage = true;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  FutureOr onGoBack(dynamic value) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider.value(
                value: DetailProviders(id: widget.listRestaurants.id),
                child: this.widget)));

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _showAppBar ? AppBar(
        title: Text(widget.listRestaurants.name, style: TextStyle(
          color: Colors.black, fontFamily: 'ChivoRegular'
          ),
        ),
        elevation: 3,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.favorite_border_sharp, color: Colors.black,)
          )
        ],
        backgroundColor: Theme.of(context).canvasColor,
      ) : null,
      floatingActionButton: _showTopPage ? null : FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0, duration: Duration(seconds: 2), curve: Curves.easeInOutCubic);
        },
        child: Icon(Icons.arrow_upward, color: Color(0xff89a66b)),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)
                    ),
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'RestoImage${widget.listRestaurants.name}',
                          child: Container(
                            width: width,
                            height: 300,
                            child: Image.network(
                              "https://restaurant-api.dicoding.dev/images/medium/${widget.listRestaurants.pictureId}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, object, stackTrace) {
                                return Container(
                                  color: Color(0xff6c6c6c),
                                  height: 300,
                                  child: Center(
                                    child: Icon(Icons.error_outline),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          left: 25,
                          child: Container(
                            width: width * 0.7,
                            child: Text(widget.listRestaurants.name, textScaleFactor: 2.5,
                              style: TextStyle(
                                fontFamily: 'ChivoHeadings', color: Colors.white
                              ),
                            ),
                          )
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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ChangeNotifierProvider.value(
                                      value: DetailProviders(id: widget.listRestaurants.id),
                                      child: this.widget
                                    )
                                  )
                                );
                              },
                              child: Icon(Icons.favorite_border_sharp, color: Colors.white,size: 28,)
                            )
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 20,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                            child: InkWell(
                              onTap: (){
                               Navigator.pop(context, true);
                              },
                              child: Icon(Icons.arrow_back_sharp, color: Colors.white,size: 28,)
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<DetailProviders>(
                    builder: (context, snapshot,_) {
                      if (snapshot.state == ResultState.HasData) {
                        final restoData = snapshot.result.restaurantData;
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Text("Overview", textScaleFactor: 1.8, style: TextStyle(
                                    fontFamily: 'ChivoHeadings', height: 2)
                                  ),
                                  SizedBox(height: 8,),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Color(0x4078872c)
                                    ),
                                    width: width,
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Icon(Icons.location_city),
                                                  label: Text("Lokasi"),
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.all(0),
                                                    alignment: Alignment.bottomLeft
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "${restoData.address}, ${widget.listRestaurants.city}"),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                title: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Icon(Icons.access_time),
                                                  label: Text("Jam Operasi"),
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.all(0),
                                                    alignment: Alignment.bottomLeft
                                                  ),
                                                ),
                                                subtitle: Text("09.00-21.00 WIB"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Icon(Icons.people),
                                                  label: Text("Kapasitas"),
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.all(0),
                                                    alignment: Alignment.bottomLeft,
                                                  ),
                                                ),
                                                subtitle: Text("40 - 58 orang"),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                title: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Icon(Icons.star),
                                                  label: Text("Rating"),
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.all(0),
                                                    alignment: Alignment.bottomLeft,
                                                  ),
                                                ),
                                                subtitle: Text("${restoData.rating.toString()}/5.0"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Icon(Icons.check_circle_outline),
                                                  label: Text("Ketersediaan"),
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.all(0),
                                                    alignment: Alignment.bottomLeft,
                                                  ),
                                                ),
                                                subtitle: Text("TERSEDIA"),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8,),
                                  ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Text("Categories :", textScaleFactor: 1.3,),
                                      Row(
                                        children: List.generate(
                                          restoData.categories.length, (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                                              child: Text(
                                                "#${restoData.categories[index].name}", textScaleFactor: 1.3,
                                                style: TextStyle(fontFamily: 'ChivoLight'),),
                                            );
                                          }
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: Text(restoData.description, textScaleFactor: 1.3,
                                      style: TextStyle(fontFamily: 'ChivoRegular'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(thickness: 8,),
                            ExpansionTile(
                              textColor: Colors.black,
                              initiallyExpanded: true,
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.fastfood_sharp),
                              ),
                              title: Row(
                                children: [
                                  Text("Foods  ", textScaleFactor: 1.5,),
                                  Text(
                                    "(${restoData.menus.foods.length.toString()})",
                                    textScaleFactor: 1.5,
                                    style: TextStyle(fontFamily: 'ChivoRegular'),
                                  )
                                ],
                              ),
                              children: [
                                SizedBox(height: 8,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: restoData.menus.foods.length,
                                    itemBuilder: (context, index) {
                                      final foods = restoData.menus.foods[index];
                                      return Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                                    child: Image.network(
                                                      'https://dummyimage.com/600x600/878787/fff.png&text=Food',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, object, stackTrace) {
                                                        return Container(
                                                          color: Color(0xff6c6c6c),
                                                          height: 100,
                                                          child: Center(
                                                            child: Icon(Icons.error_outline),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: ListTile(
                                                    title: Text(foods.name, textScaleFactor: 1.2,
                                                      style: TextStyle(fontFamily: 'ChivoLight'),),
                                                    subtitle: Text("Rp xxx"),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(thickness: 2,)
                                        ],
                                      );
                                    }
                                  ),
                                )
                              ],
                            ),
                            Divider(thickness: 8,),
                            ExpansionTile(
                              textColor: Colors.black,
                              initiallyExpanded: true,
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.emoji_food_beverage),
                              ),
                              title: Row(
                                children: [
                                  Text("Drinks  ", textScaleFactor: 1.5,),
                                  Text(
                                    "(${restoData.menus.drink.length.toString()})",
                                    textScaleFactor: 1.5,
                                    style: TextStyle(fontFamily: 'ChivoRegular'),
                                  )
                                ],
                              ),
                              children: [
                                SizedBox(height: 8,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: restoData.menus.drink.length,
                                    itemBuilder: (context, index) {
                                      final foods = restoData.menus.drink[index];
                                      return Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                                    child: Image.network(
                                                      'https://dummyimage.com/600x600/878787/fff.png&text=Drink',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, object, stackTrace) {
                                                        return Container(
                                                          color: Color(0xff6c6c6c),
                                                          height: 180,
                                                          child: Center(
                                                            child: Icon(Icons.error_outline),
                                                          ),
                                                        );
                                                      }
                                                    ),
                                                  )
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: ListTile(
                                                    title: Text(foods.name, textScaleFactor: 1.2,
                                                      style: TextStyle(fontFamily: 'ChivoLight'),),
                                                    subtitle: Text("Rp xxx"),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(thickness: 2,)
                                        ],
                                      );
                                    }
                                  ),
                                )
                              ],
                            ),
                            Divider(thickness: 8,),
                            ListTile(
                              title: Text("Review", textScaleFactor: 1.5,),
                              trailing: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    new PageRouteBuilder(
                                        // pageBuilder: (context, primary, secondary) => ChangeNotifierProvider(
                                        //   create: (BuildContext context) => DetailProviders(id: restoData.id),
                                        //   child: ReviewPage(
                                        //     listRestaurants: widget.listRestaurants,
                                        //   ),
                                        // ),
                                        pageBuilder: (context, _, __) => ChangeNotifierProvider.value(
                                          value: DetailProviders(id: restoData.id),
                                          child: ReviewPage(
                                            listRestaurants: widget.listRestaurants,
                                          ),
                                        ),
                                        transitionsBuilder: (context, animation, secondAnimation, child) {
                                          var begin = Offset(2.0, 0.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;
                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        }
                                    )
                                  ).then(onGoBack);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Lihat semua", style: TextStyle(fontFamily: 'ChivoRegular'),
                                    ),
                                    Icon(Icons.arrow_forward_ios_sharp, size: 16,),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: restoData.customerReview.length >= 3
                                  ? 3 : restoData.customerReview.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, idx) {
                                final index = restoData.customerReview.length - 1 - idx;
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.account_circle, size: 30,),
                                      title: Text(
                                        restoData.customerReview[index].name,
                                        style: TextStyle(fontFamily: 'ChivoLight'),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            restoData.customerReview[index].review,
                                            textScaleFactor: 1.3,
                                            style: TextStyle(fontFamily: 'ChivoRegular'),
                                          ),
                                          SizedBox(height: 16,),
                                          Text(
                                            restoData.customerReview[index].date,
                                            style: TextStyle(fontFamily: 'ChivoLight'),
                                          )
                                        ],
                                      ),
                                      isThreeLine: true,
                                    ),
                                    Divider(thickness: 1,)
                                  ],
                                );
                              },
                            )
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0x1F000000),
                            highlightColor: Color(0x66000000),
                            child: ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                  width: 12,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                ),
                                SizedBox(height: 24,),
                                ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(6, (index) {
                                    return Container(
                                      height: 100,
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              child: Container(
                                                color: Color(0xff6c6c6c),
                                                height: 100,
                                              ),
                                            )
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                                    )
                                                  ),
                                                  SizedBox(height: 12,),
                                                  Container(
                                                    width: width * 0.3,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                                    )
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
