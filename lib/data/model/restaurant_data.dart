import 'list_restaurant.dart';

class RestaurantData {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<Categories> categories;
  Menus menus;
  double rating;
  List<CustomerReview> customerReview;

  RestaurantData({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReview
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> listCategory = json['categories'];
    final List<dynamic> listReview = json['customerReviews'];
    final List<Categories> categories = listCategory.map((i) => Categories.fromJson(i)).toList();
    final List<CustomerReview> reviews = listReview.map((i) => CustomerReview.fromJson(i)).toList();
    return RestaurantData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      address: json['address'],
      pictureId: json['pictureId'],
      categories: categories,
      menus: Menus.fromJson(json['menus']),
      rating: json['rating'].toDouble(),
      customerReview: reviews);
  }
}

class Categories {
  String name;
  Categories({required this.name});

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(name: json['name']);

  Map<String, dynamic> toJson() => {
    'name': name
  };
}

class CustomerReview {
  String name;
  String review;
  String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    name: json['name'],
    review: json['review'],
    date: json['date']
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'review': review,
    'date': date
  };
}

