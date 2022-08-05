import 'dart:collection';

import 'package:trilicious_dashboard/models/food_item.dart';
import 'package:flutter/cupertino.dart';

class FoodItemNotifier with ChangeNotifier {
  List<String> _categoryList = [];
  String _currentCategory="";

  Map<String,List<FoodItem>> _foodItemMap ={};

  List<FoodItem> _foodItemList = [];
  FoodItem? _currentFoodItem;

  UnmodifiableListView<String> get categoryList => UnmodifiableListView(_categoryList);
  UnmodifiableListView<FoodItem> get foodItemList => UnmodifiableListView(_foodItemList);
  UnmodifiableMapView<String,List<FoodItem>> get foodItemMap => UnmodifiableMapView(_foodItemMap);
  // Map<String,List<FoodItem>> get foodItemMap => _foodItemMap;

  FoodItem? get currentFoodItem => _currentFoodItem;

  set foodItemList(List<FoodItem> foodItemList) {
    _foodItemList = foodItemList;
    notifyListeners();
  }
  set foodItemMap(Map<String,List<FoodItem>> foodItemMap){
    _foodItemMap = foodItemMap;
    notifyListeners();
  }

  set currentFoodItem(FoodItem? foodItem) {
    _currentFoodItem = foodItem;
    notifyListeners();
  }

  addFoodItem(FoodItem foodItem,String category) {
    _foodItemMap[category]?.add(foodItem);
    notifyListeners();
  }

  deleteFoodItem(FoodItem foodItem,String category) {
    _foodItemMap[category]?.removeWhere((_foodItem) => _foodItem.id == foodItem.id);
    notifyListeners();
  }
  
  String get currentCategory => _currentCategory;

  set categoryList(List<String> categoryList) {
    _categoryList = categoryList;
    notifyListeners();
  }

  set currentCategory(String category) {
    _currentCategory = category;
    notifyListeners();
  }

  addCategory(String category) {
    _categoryList.insert(0, category);
    notifyListeners();
  }

  deleteCategory(String category) {
    _categoryList.remove(category);
    notifyListeners();
  }
}