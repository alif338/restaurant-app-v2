import 'package:restaurant_app/data/model/list_restaurant.dart';

class SearchRestaurants {
  bool error;
  int founded;
  List<ListRestaurants> restaurants;

  SearchRestaurants({
    required this.error,
    required this.founded,
    required this.restaurants
  });

  factory SearchRestaurants.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['restaurants'];
    final List<ListRestaurants> parsedList =
    list.map((i) => ListRestaurants.fromJson(i)).toList();
    return SearchRestaurants(
      error: json['error'],
      founded: json['founded'],
      restaurants: parsedList
    );
  }

  Map<String, dynamic> toJson() => {
    'error': error,
    'founded': founded,
    'restaurants': restaurants
  };
}