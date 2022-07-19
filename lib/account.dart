import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_dashboard/api/profile_api.dart';
import 'package:trilicious_dashboard/notifiers/profile_notifier.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    ProfileNotifier profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);
    getProfileData(profileNotifier);
    super.initState();
  }
  getProfileData(ProfileNotifier profileNotifier) {
    getProfile(profileNotifier);
    print(profileNotifier.currentRestaurant);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: OutlinedButton(
          child: const Text('EDIT'),
          onPressed: (){
          Navigator.pushNamed(context, '/edit-account');
          },
        ),
      ),
    );
  }
}
