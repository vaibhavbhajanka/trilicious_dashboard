import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_dashboard/api/order_api.dart';
// import 'package:trilicious_dashboard/api/order_api.dart';
import 'package:trilicious_dashboard/models/order.dart';
import 'package:trilicious_dashboard/notifiers/order_notifier.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    // getOrders(orderNotifier);
    super.initState();
  }

  var _selectedDate;
  DateTime today = DateTime.now();
  // TabController tabController = TabController(length: 2,vsync: );
  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    // var orderDate = DateFormat('dd-M-y').format(DateTime.now());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Orders'),
            backgroundColor: Colors.orange,
            bottom:
                //  _selectedDate == DateFormat('dd-M-y').format(DateTime.now())    ?
                const TabBar(
                  labelStyle: TextStyle(
                    fontSize: 15,
                  ),
                  tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Completed',
              ),
            ])),
        // : null),
        body: Column(
          children: [
            Flexible(
              child: DatePicker(
                DateTime(today.year, today.month, today.day - 7),
                initialSelectedDate: today,
                selectionColor: Colors.black,
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  // New date selected
                  setState(() {
                    _selectedDate = DateFormat('dd-M-y').format(date);
                  });
                },
              ),
            ),
            SizedBox(
              height: 540,
              child: TabBarView(children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('date')
                      .doc(_selectedDate)
                      .collection('orders')
                      .orderBy('orderedAt',descending: true)
                      .where("isCompleted", isEqualTo: false)
                      .snapshots(),
                  builder: ((BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return snapshot.hasData
                        ? GridView.builder(
                            // shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Order currentOrder =
                                  Order.fromMap(snapshot.data!.docs[index]);
                              DateTime orderedAt =
                                  currentOrder.orderedAt?.toDate() ??
                                      DateTime.now();
                              return OrderCard(
                                itemList: currentOrder.items,
                                orderId: currentOrder.id??'',
                                quantity: currentOrder.quantity,
                                price: currentOrder.price,
                                isComplete: Checkbox(
                                  value: currentOrder.isCompleted ?? false,
                                  onChanged: (value) {
                                    // foodItemNotifier.currentFoodItem =
                                    //     foodItemNotifier.foodItemList[index];
                                    // // setState(() {
                                    // foodItemNotifier.foodItemList[index].isAvailable =
                                    //     value;
                                    changeOrderStatus(currentOrder, value!);
                                    // });
                                  },
                                ),
                                totalBill: currentOrder.totalBill,
                                orderedAt: orderedAt,
                              );
                            })
                        : const Center(
                            child: Text(
                              'No orders',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                  }),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('date')
                      .doc(_selectedDate)
                      .collection('orders')
                      .orderBy('orderedAt',descending: true)
                      .where("isCompleted", isEqualTo: true)
                      .snapshots(),
                  builder: ((BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return snapshot.hasData
                        ? GridView.builder(
                            // shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Order currentOrder =
                                  Order.fromMap(snapshot.data!.docs[index]);
                              DateTime orderedAt =
                                  currentOrder.orderedAt?.toDate() ??
                                      DateTime.now();
                              return OrderCard(
                                itemList: currentOrder.items,
                                orderId: currentOrder.id??'',
                                quantity: currentOrder.quantity,
                                price: currentOrder.price,
                                isComplete: Checkbox(
                                  value: currentOrder.isCompleted ?? true,
                                  onChanged: (value) {
                                    // foodItemNotifier.currentFoodItem =
                                    //     foodItemNotifier.foodItemList[index];
                                    // // setState(() {
                                    // foodItemNotifier.foodItemList[index].isAvailable =
                                    //     value;
                                    changeOrderStatus(currentOrder, value!);
                                    // });
                                  },
                                ),
                                totalBill: currentOrder.totalBill,
                                orderedAt: orderedAt,
                              );
                            })
                        : const Center(
                            child: Text(
                              'No orders',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                  }),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  OrderCard(
      {Key? key,
      required this.itemList,
      required this.quantity,
      required this.orderId,
      required this.price,
      required this.isComplete,
      required this.totalBill,
      required this.orderedAt})
      : super(key: key);
  final List<String> itemList;
  final String orderId;
  final Map<String, int> quantity;
  final Map<String, int> price;
  final double totalBill;
  final Widget isComplete;
  final DateTime orderedAt;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          child: Column(
            children: [
              Container(
                color: const Color(0xff00d436),
                width: double.infinity,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Dine-in',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        DateFormat('hh:mm').format(widget.orderedAt),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        "#${widget.orderId}",
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      DateFormat('dd-M-Y').format(widget.orderedAt) ==
                              DateFormat('dd-M-Y').format(DateTime.now())
                          ? widget.isComplete
                          : Container()
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Item',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Text(
                      'Quantity',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Text(
                      'Price',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  height: 200,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.itemList.length,
                      itemBuilder: (BuildContext context, index) {
                        String _item = widget.itemList[index];
                        int _quantity = widget.quantity[_item] ?? 0;
                        int _price = widget.price[_item] ?? 0;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(flex: 2, child: Text(_item)),
                                  Expanded(child: Text('x $_quantity')),
                                  Expanded(child: Text('\u{20B9}$_price')),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\u{20B9}${widget.totalBill}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
