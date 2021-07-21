import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/add_review_page.dart';
import 'package:restaurant_app/data/providers/detail_providers.dart';
import 'package:restaurant_app/data/resultstate.dart';

import 'data/model/list_restaurant.dart';

class ReviewPage extends StatefulWidget {

  final ListRestaurants listRestaurants;

  const ReviewPage({
    Key? key,
    required this.listRestaurants
  }) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    final imgUrl = 'https://restaurant-api.dicoding.dev/images/small/${widget.listRestaurants.pictureId}';
    final id = widget.listRestaurants.id;
    return Scaffold(
      appBar: AppBar(
        title: Text('Review', style: TextStyle(
            color: Colors.black, fontFamily: 'ChivoRegular'
          ),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(imgUrl),
          ),
          IconButton(
            icon: Icon(Icons.restart_alt, color: Colors.black,),
            onPressed: (){
              print("reassemble");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ChangeNotifierProvider.value(
                          value: DetailProviders(id: widget.listRestaurants.id),
                          child: this.widget)));
            },
          )
        ],
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Scrollbar(
        child: Consumer<DetailProviders>(
          builder: (context, snapshot, _) {
            if (snapshot.state == ResultState.HasData){
              final reviews = snapshot.result.restaurantData.customerReview;
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final idx = reviews.length - 1 - index;
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_circle, size: 30,),
                        title: Text(reviews[idx].name,
                          style: TextStyle(fontFamily: 'ChivoLight'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reviews[idx].review,
                              textScaleFactor: 1.3,
                              style: TextStyle(fontFamily: 'ChivoRegular'),
                            ),
                            SizedBox(height: 16,),
                            Text(
                              reviews[idx].date,
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
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              // pageBuilder: (context, primary, secondary) => ChangeNotifierProvider(
              //   create: (BuildContext context)  => DetailProviders(id: id),
              //   child: AddReviewPage(listRestaurants: widget.listRestaurants,),
              // ),
              pageBuilder: (context, _, __) => ChangeNotifierProvider.value(
                value: DetailProviders(id: widget.listRestaurants.id),
                child: AddReviewPage(
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
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }


}
