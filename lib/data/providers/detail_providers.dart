import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:http/http.dart' as http;

import '../resultstate.dart';

class DetailProviders extends ChangeNotifier {

  final String id;
  DetailProviders({required this.id}) {
    _fetchRestaurantDetail();
  }

  String _message = '';
  String get message => _message;

  late DetailRestaurant _restaurantData;
  DetailRestaurant get result => _restaurantData;

  ResultState _state = ResultState.Loading;
  ResultState get state => _state;

  Future<dynamic> _fetchRestaurantDetail() async {
    try {
      final data = await loadData(id);
      if (data.error) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = "No Data";
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantData = data;
      }
    } catch(e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = "Error --> $e";
    }
  }

  Future<DetailRestaurant> loadData(String id) async {
    final String _baseUrl = 'https://restaurant-api.dicoding.dev/detail/$id';
    http.Client client = http.Client();

    final response = await client.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return DetailRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error to load data');
    }
  }

  Future<void> addReview(String id, String name, String review) async {
    try {
      await http.post(Uri.parse('https://restaurant-api.dicoding.dev/review'),
        headers: {
          'Content-Type': 'application/json',
          'X-Auth-Token': '12345'
        },
        body: jsonEncode(
            <String, String>{"id": id, "name": name, "review": review}));
      _fetchRestaurantDetail();
    } catch(e) {
      _state = ResultState.Error;
      _message = 'Error $e';
      notifyListeners();
    }
  }
}