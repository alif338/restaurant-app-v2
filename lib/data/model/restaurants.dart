import 'list_restaurant.dart';

class Restaurant{
  bool error;
  String message;
  int count;
  List<ListRestaurants> restaurants;

  Restaurant({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants
  });

  factory Restaurant.fromJson(json) {
    final List<dynamic> list = json['restaurants'];
    final List<ListRestaurants> parsedList =
      list.map((i) => ListRestaurants.fromJson(i)).toList();
    return Restaurant(
      error: json['error'],
      message: json['message'],
      count: json['count'],
      restaurants: parsedList
    );
  }

  Map<String, dynamic> toJson() => {
    'error': error,
    'message': message,
    'count': count,
    'restaurants' : restaurants
  };
}