import 'dart:collection';
// import 'package:trilicious_menu/models/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:trilicious_dashboard/models/order.dart';

class OrderNotifier with ChangeNotifier {
  List<Order> _orderList = [];
  Order? _currentOrder;

  UnmodifiableListView<Order> get orderList => UnmodifiableListView(_orderList);
  Order? get currentOrder => _currentOrder;

  set orderList(List<Order> orderList) {
    _orderList = orderList;
    notifyListeners();
  }

  set currentOrder(Order? order) {
    _currentOrder = order;
    notifyListeners();
  }

  addOrder(Order order) {
    _orderList.insert(0, order);
    notifyListeners();
  }
}