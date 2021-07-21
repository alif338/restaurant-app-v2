import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurants.dart';

import '../resultstate.dart';

class MainProviders extends ChangeNotifier{

  MainProviders() {
    _fetchAllRestaurants();
  }

  String _message = '';
  String get message => _message;

  late Restaurant _restaurant;
  Restaurant get result => _restaurant;

  ResultState _state = ResultState.Loading;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurants() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final bar = await loadData();
      if (bar.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'empty';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurant = bar;
      }
    } catch(e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<Restaurant> loadData() async {
    final String _baseUrl = 'https://restaurant-api.dicoding.dev/list';
    http.Client client = http.Client();

    final response = await client.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      print(json.decode(response.body)['error']);
      return Restaurant.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load data');
    }
  }
}