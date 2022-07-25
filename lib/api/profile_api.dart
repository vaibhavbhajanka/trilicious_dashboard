import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:trilicious_dashboard/models/restaurant.dart';
import 'package:path/path.dart' as path;
import 'package:trilicious_dashboard/notifiers/profile_notifier.dart';
import 'package:uuid/uuid.dart';

uploadProfile(Restaurant restaurant, File? coverFile, File? profileFile) async {
  var fileExtension;
  String? coverUrl,profileUrl;
  if (coverFile != null) {
    print("uploading cover image");

    fileExtension = path.extension(coverFile.path);
    print(fileExtension);

    var uuid = const Uuid().v4();

    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('restaurant/cover/images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(coverFile)
        .whenComplete(() => null)
        .catchError((onError) {
      print(onError);
      // return false;
    });

    coverUrl = await firebaseStorageRef.getDownloadURL();
    print("download cover url: $coverUrl");
    // _uploadrestaurant(restaurant,imageUrl: url);
  } 
  if (profileFile != null) {
    print("uploading profile image");

    fileExtension = path.extension(profileFile.path);
    print(fileExtension);

    var uuid = const Uuid().v4();

    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('restaurant/profile/images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(profileFile)
        .whenComplete(() => null)
        .catchError((onError) {
      print(onError);
      // return false;
    });

    profileUrl = await firebaseStorageRef.getDownloadURL();
    print("download profile url: $profileUrl");
    // _uploadrestaurant(restaurant,imageUrl: url);
  }
  _uploadrestaurant(restaurant,coverImageUrl:coverUrl,profileImageUrl: profileUrl);
  // else {
  //   print('...skipping image upload');
  //   _uploadrestaurant(restaurant, isUpdating, restaurantUploaded);
  // }
}

_uploadrestaurant(Restaurant restaurant,
    {String? coverImageUrl,String? profileImageUrl})async {
  CollectionReference restaurantRef = FirebaseFirestore.instance
      .collection('restaurants');
  print(coverImageUrl);
  print(profileImageUrl);
      // .doc(category)
      // .collection('menuItems');
  if (profileImageUrl != null) {
    restaurant.profileImage = profileImageUrl;
  }
  if (coverImageUrl != null) {
    restaurant.coverImage = coverImageUrl;
  }
  print(restaurant);

  // User? user = FirebaseAuth.instance.currentUser;
  String email = "abc@gmail.com";
  // if (isUpdating) {
    // restaurant.updatedAt = Timestamp.now();
    // print('updating:${restaurant.id}');
    await restaurantRef
        .doc(email)
        .set(restaurant.toMap());
    

                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Coming Soon!'),
                          // duration: const Duration(seconds: 1),));
    
    print('updated restaurant with id: $email');
    // Navigator.pop(context);
  // } else {
  // }
}

getProfile(ProfileNotifier profileNotifier) async {
  // User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('restaurants').doc('abc@gmail.com').get();
  // print(snapshot.data());
  Restaurant _restaurant = Restaurant();
  if (snapshot.exists) {
    _restaurant = Restaurant.fromMap(snapshot.data());
  }
  profileNotifier.currentRestaurant = _restaurant;
  print(profileNotifier.currentRestaurant?.name);
  print(profileNotifier.currentRestaurant?.address);
  print(profileNotifier.currentRestaurant?.coverImage);
  print(profileNotifier.currentRestaurant?.profileImage);
}
