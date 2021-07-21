import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/search_restaurants.dart';
import 'package:restaurant_app/detail_page.dart';
import 'package:http/http.dart' as http;

import 'data/model/list_restaurant.dart';
import 'data/providers/detail_providers.dart';

class SearchPage extends StatefulWidget {
  final List<ListRestaurants> listRestaurants;
  const SearchPage({Key? key, required this.listRestaurants}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  bool isSearching = false;
  SearchRestaurants searchRestaurants = SearchRestaurants(
    error: false, founded: 0, restaurants: []);
  String errorMessage = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  Future<void> retrieveSearch() async {
    setState(() {
      isSearching = true;
    });
    final String query = searchController.text;
    final String url = 'https://restaurant-api.dicoding.dev/search?q=$query';
    http.Client client = http.Client();

    await client.get(Uri.parse(url)).then((value) {
      if (value.statusCode == 200) {
        setState(() {
          searchRestaurants = SearchRestaurants.fromJson(json.decode(value.body));
          isSearching = false;
        });
      } else {
        setState(() {
          errorMessage = "Error status ${value.statusCode}";
          isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              label: Text("Back")
            ),
            TextFormField(
              style: TextStyle(color: Colors.white, fontFamily: 'ChivoRegular'),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Cari Nama, Kategori, atau Menu",
                prefixIcon: Icon(Icons.search, color: Colors.white,),
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.black26,
                hintStyle: TextStyle(color: Colors.white, fontFamily: 'ChivoRegular'),
              ),
              onTap: (){
                print("READY to EDIT");
              },
              controller: searchController,
              onFieldSubmitted: (value) {
                retrieveSearch();
              },
            ),
            Builder(
              builder: (context) {
                if (searchController.text.isNotEmpty) {
                  final items = searchRestaurants.restaurants;
                  if (!isSearching) {
                    if (searchRestaurants.error) {
                      return Expanded(
                        child: Center(
                          child: Text("Terjadi kesalahan dalam pencarian"),
                        )
                      );
                    } else if (items.length == 0) {
                      return Expanded(
                        child: Center(
                          child: Text("Tidak ada hasil pencarian", style: TextStyle(
                            fontFamily: 'ChivoRegular'
                          )),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                              height: 80,
                              width: 80,
                              child: Hero(
                                tag: 'RestoImage${items[index].name}',
                                child: Image.network(
                                  "https://restaurant-api.dicoding.dev/images/medium/${items[index].pictureId}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, object, stackTrace) {
                                    return Container(
                                      color: Color(0xff6c6c6c),
                                      height: 80,
                                      child: Center(
                                        child: Icon(Icons.error_outline),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            title: Text(items[index].name),
                            subtitle: Text(items[index].city, style: TextStyle(fontFamily: 'ChivoLight'),),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (BuildContext context) => DetailProviders(id: items[index].id),
                                  child: DetailPage(listRestaurants: items[index]))
                              ));
                            },
                            trailing: Text("\u2605 ${items[index].rating.toString()}"),
                            isThreeLine: true,
                          );
                        }
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      )
                    );
                  }
                } else {
                  return Expanded(
                    child: SizedBox()
                  );
                }
              }
            )
          ],
        ),
      ),
    );
  }
}
