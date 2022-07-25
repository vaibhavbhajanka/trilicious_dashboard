// import 'dart:io';
// import 'package:trilicious_menu/models/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:trilicious_dashboard/models/restaurant.dart';


class ProfileNotifier with ChangeNotifier {
  Restaurant? _currentRestaurant;

  Restaurant? get currentRestaurant => _currentRestaurant;
  // File? get coverImageFile => _coverImageFile;
  // File? get profileImageFile => _profileImageFile; 

  set currentRestaurant(Restaurant? restaurant) {
    _currentRestaurant = restaurant;
    notifyListeners();
  }

  // set coverImageFile(File? coverFile){
  //   _coverImageFile=coverFile;
  //   notifyListeners();
  // }
  // set profileImageFile(File? profileFile){
  //   _profileImageFile=profileFile;
  //   notifyListeners();
  // }

  // addOrder(Order order) {
  //   _orderList.insert(0, order);
  //   notifyListeners();
  // }
}