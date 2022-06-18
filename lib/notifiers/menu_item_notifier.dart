import 'dart:collection';
import 'package:trilicious_dashboard/models/menu_item.dart';
import 'package:flutter/cupertino.dart';

class MenuItemNotifier with ChangeNotifier {
  List<MenuItem> _menuItemList = [];
  MenuItem? _currentMenuItem;

  UnmodifiableListView<MenuItem> get menuItemList => UnmodifiableListView(_menuItemList);

  MenuItem? get currentMenuItem => _currentMenuItem;

  set menuItemList(List<MenuItem> menuItemList) {
    _menuItemList = menuItemList;
    notifyListeners();
  }

  set currentMenuItem(MenuItem? menuItem) {
    _currentMenuItem = menuItem;
    notifyListeners();
  }

  addMenuItem(MenuItem menuItem) {
    _menuItemList.insert(0, menuItem);
    notifyListeners();
  }

  deleteMenuItem(MenuItem menuItem) {
    _menuItemList.removeWhere((_menuItem) => _menuItem.id == menuItem.id);
    notifyListeners();
  }
}