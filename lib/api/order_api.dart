import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:trilicious_dashboard/models/order.dart';
import 'package:trilicious_dashboard/notifiers/order_notifier.dart';

// getOrders(OrderNotifier orderNotifier) async {
//   // User? user = FirebaseAuth.instance.currentUser;
//   QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('orders')
//       // .doc(user!.uid)
//       // .collection('properties')
//       // .orderBy("date", descending: true)
//       // .where('isAvailable',isEqualTo: true)
//       .get();

//   List<Order> _orderList = [];

//   for (var document in snapshot.docs) {
//     // print(document.data());
//     Order order = Order.fromMap(document.data());
//     _orderList.add(order);
//   }

//   orderNotifier.orderList = _orderList;
// }

changeOrderStatus(Order? order, bool isCompleted) async {
  var orderDate = DateFormat('dd-M-y').format(DateTime.now());
  CollectionReference foodItemRef =
      FirebaseFirestore.instance.collection('date').doc(orderDate).collection('orders');
  print('updating:${order}');
  order?.isCompleted = isCompleted;
  await foodItemRef.doc(order?.id.toString()).update(order!.toMap());
  print('Avaibility successfully changed for Fooditem: ${order.toString()}');
}