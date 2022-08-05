// import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_dashboard/api/profile_api.dart';
import 'package:trilicious_dashboard/notifiers/profile_notifier.dart';
import 'package:trilicious_dashboard/widgets/glass_card.dart';

GlobalKey globalKey = GlobalKey();

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    // ProfileNotifier profileNotifier =
    //     Provider.of<ProfileNotifier>(context, listen: false);
    // getProfileData(profileNotifier);
    super.initState();
  }

  // getProfileData(ProfileNotifier profileNotifier) {
  //   getProfile(profileNotifier);
  //   print(profileNotifier.currentRestaurant);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/edit-account');
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("restaurants")
                  .doc('abc@gmail.com')
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                return snapshot.hasData
                    ? Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 5 / 2,
                            child: Image.network(
                              snapshot.data?['coverImage'] ??
                                  'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.03),
                            child: Center(
                              child: GlassCard(
                                image: snapshot.data?['profileImage'],
                                restaurantName: snapshot.data?['name'] ?? '',
                                restaurantAddress:
                                    snapshot.data?['address'] ?? '',
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container();
                // Restaurant _restaurant = Restaurant.fromMap(snapshot);
                // profileNotifier.currentRestaurant = _restaurant;
              }),
          Expanded(
            child: Column(
              // shrinkWrap: true,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    const snackBar = SnackBar(
                      content: Text('Coming Soon!'),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.orange,
                    ),
                    title: Text('Wallet'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    const snackBar = SnackBar(
                      content: Text('Coming Soon!'),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.insights,
                      color: Colors.orange,
                    ),
                    title: Text('Insights'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    const snackBar = SnackBar(
                      content: Text('Coming Soon!'),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.support_agent,
                      color: Colors.orange,
                    ),
                    title: Text('Support'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    const snackBar = SnackBar(
                      content: Text('Coming Soon!'),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.assignment,
                      color: Colors.orange,
                    ),
                    title: Text('Terms & Conditions'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    const snackBar = SnackBar(
                      content: Text('Coming Soon!'),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.orange,
                    ),
                    title: Text('Settings'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout of Account?'),
                          actions: [
                            _DialogButton(
                                text: 'Cancel',
                                onPressed: () => Navigator.of(context).pop()),
                            _DialogButton(
                                text: 'OK',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  logout(context);
                                }),
                          ],
                        );
                      },
                    );
                    // final snackBar = const SnackBar(
                    //   content: Text('Logged Out Successfully'),
                    //   duration: Duration(seconds: 1),
                    // );
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.orange,
                    ),
                    title: Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    // await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.restorablePushReplacementNamed(context, '/login');
  }
}



class _DialogButton extends StatelessWidget {
  const _DialogButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
