import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trilicious_dashboard/login.dart';
import 'package:trilicious_dashboard/menu.dart';
import 'package:trilicious_dashboard/notifiers/menu_item_notifier.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_dashboard/add_menu_item.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuItemNotifier(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/menu',
      routes: {
        '/login': (ctx) => const LoginScreen(),
        '/menu':(ctx) => const Menu(),
        '/add-menu-item':(ctx) => const AddMenuItemScreen(isUpdating: false),
      },
    );
  }
}