import 'package:restaurant_app/data/model/restaurant_data.dart';

class DetailRestaurant {
  bool error;
  String message;
  RestaurantData restaurantData;

  DetailRestaurant({
    required this.error,
    required this.message,
    required this.restaurantData
  });

  factory DetailRestaurant.fromJson(Map<String, dynamic> json) => DetailRestaurant(
    error: json['error'],
    message: json['message'],
    restaurantData: RestaurantData.fromJson(json['restaurant'])
  );

  Map<String, dynamic> toJson() => {
    'error': error,
    'message': message,
    'restaurantData': restaurantData
  };
}