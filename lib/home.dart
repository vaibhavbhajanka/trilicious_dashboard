import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:trilicious_dashboard/account.dart';
import 'package:trilicious_dashboard/menu.dart';
import 'package:trilicious_dashboard/order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _kIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _kIndex,
        children: const [
           Menu(),
           OrderScreen(),
           AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _kIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _kIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.menu_book_rounded),
            title: const Text('Menu'),
            activeColor: Colors.orange,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.ad_units_sharp),
            title: const Text('Orders'),
            activeColor: Colors.orange,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.account_circle),
            title: const Text('Account'),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
