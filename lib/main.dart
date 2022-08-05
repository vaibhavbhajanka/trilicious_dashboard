import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trilicious_dashboard/edit_account.dart';
import 'package:trilicious_dashboard/home.dart';
import 'package:trilicious_dashboard/login.dart';
import 'package:trilicious_dashboard/menu.dart';
import 'package:trilicious_dashboard/notifiers/food_item_notifier.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_dashboard/add_food_item.dart';
import 'package:trilicious_dashboard/notifiers/order_notifier.dart';
import 'package:trilicious_dashboard/notifiers/profile_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDdGzjVuU2JwQoxgl_NqyxxcSR5ma6kKMM',
      appId: '1:1082364642390:android:c8374ffbf999681d0b27f7',
      messagingSenderId: '1082364642390',
      projectId: 'trilicious-a9b87',
    ),
  );
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FoodItemNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileNotifier(),
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/login',
      routes: {
        '/home': (ctx) => const HomeScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/menu': (ctx) => const Menu(),
        '/add-menu-item': (ctx) => const AddFoodItemScreen(isUpdating: false),
        '/edit-account':(ctx)=> const EditAccountScreen(),
      },
    );
  }
}
