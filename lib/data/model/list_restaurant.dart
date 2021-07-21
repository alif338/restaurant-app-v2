class ListRestaurants {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  ListRestaurants({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory ListRestaurants.fromJson(Map<String, dynamic> json) {
    return ListRestaurants(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'pictureId': pictureId,
    'city': city,
    'rating': rating,
  };
}

class Menus {
  List<Eats> foods;
  List<Eats> drink;

  Menus({
    required this.foods,
    required this.drink
  });

  factory Menus.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list1 = json['foods'];
    final List<dynamic> list2 = json['drinks'];
    final List<Eats> foodList = list1.map((i) => Eats.fromJson(i)).toList();
    final List<Eats> drinkList = list2.map((i) => Eats.fromJson(i)).toList();

    return Menus(foods: foodList, drink: drinkList);
  }

  Map<String, dynamic> toJson() => {
    'foods': foods,
    'drink': drink
  };
}

class Eats {
  String name;
  Eats({required this.name});

  factory Eats.fromJson(Map<String, dynamic> json) => Eats(name: json['name']);

  Map<String, dynamic> toJson() => {'name': name};
}