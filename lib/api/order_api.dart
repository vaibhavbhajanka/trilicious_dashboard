import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:trilicious_dashboard/models/order.dart';

changeOrderStatus(Order? order, bool isCompleted) async {
  var orderDate = DateFormat('dd-M-y').format(DateTime.now());
  CollectionReference foodItemRef =
      FirebaseFirestore.instance.collection('date').doc(orderDate).collection('orders');
  print('updating:$order');
  order?.isCompleted = isCompleted;
  await foodItemRef.doc(order?.id.toString()).update(order!.toMap());
  print('Avaibility successfully changed for Fooditem: ${order.toString()}');
}