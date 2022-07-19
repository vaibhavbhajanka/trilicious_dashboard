import 'dart:io';
// import 'package:trilicious_dashboard/model/user_model.dart';
// import 'package:trilicious_dashboard/models/catergory.dart';
// import 'package:provider/provider.dart';
import 'package:trilicious_dashboard/models/food_item.dart';
// import 'package:trilicious_dashboard/notifiers/category_notifier.dart';
import 'package:trilicious_dashboard/notifiers/food_item_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

// login(User user, AuthNotifier authNotifier) async {
//   AuthResult authResult = await FirebaseAuth.instance
//       .signInWithEmailAndPassword(email: user.email, password: user.password)
//       .catchError((error) => print(error.code));

//   if (authResult != null) {
//     FirebaseUser firebaseUser = authResult.user;

//     if (firebaseUser != null) {
//       print("Log In: $firebaseUser");
//       authNotifier.setUser(firebaseUser);
//     }
//   }
// }

// signup(User user, AuthNotifier authNotifier) async {
//   AuthResult authResult = await FirebaseAuth.instance
//       .createUserWithEmailAndPassword(email: user.email, password: user.password)
//       .catchError((error) => print(error.code));

//   if (authResult != null) {
//     UserUpdateInfo updateInfo = UserUpdateInfo();
//     updateInfo.displayName = user.displayName;

//     FirebaseUser firebaseUser = authResult.user;

//     if (firebaseUser != null) {
//       await firebaseUser.updateProfile(updateInfo);

//       await firebaseUser.reload();

//       print("Sign up: $firebaseUser");

//       FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//       authNotifier.setUser(currentUser);
//     }
//   }
// }

// signout(AuthNotifier authNotifier) async {
//   await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

//   authNotifier.setUser(null);
// }

// initializeCurrentUser(AuthNotifier authNotifier) async {
//   FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

//   if (firebaseUser != null) {
//     print(firebaseUser);
//     authNotifier.setUser(firebaseUser);
//   }
// }

// searchByName(String searchField) {
//     return FirebaseFirestore.instance
//         .collection("users")
//         .where('name', isEqualTo: searchField)
//         .get();
// }

// addCategory(String category) async {
//     await FirebaseFirestore.instance
//         .collection("menu")
//         .doc('category')
//         .set(chatRoom)
//         .catchError((e) {
//       print(e);
//     });
// }

// getChats(String chatRoomId) async{
//     return FirebaseFirestore.instance
//         .collection("chatRoom")
//         .doc(chatRoomId)
//         .collection("chats")
//         .orderBy('time')
//         .snapshots();
//   }

//   addMessage2(String chatRoomId, chatMessageData)async{

//     await FirebaseFirestore.instance.collection("chatRoom")
//         .doc(chatRoomId)
//         .collection("chats")
//         .add(chatMessageData).catchError((e){
//           print(e.toString());
//     });
//   }

//   getUserChats(String itIsMyName)async {
//     return FirebaseFirestore.instance
//         .collection("chatRoom")
//         .where('users', arrayContains: itIsMyName)
//         .snapshots();
//   }
getCategories(FoodItemNotifier foodItemNotifier) async {
  // User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('menu').doc('category').get();
  print(snapshot.data());
  if (snapshot.exists) {
    List<String> _categories;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _categories = data['categories'].cast<String>();
    foodItemNotifier.categoryList = _categories;
  }
  print(foodItemNotifier.categoryList);
}

uploadCategory(List<String> category) async {
  CollectionReference foodItemRef =
      FirebaseFirestore.instance.collection('menu');
  Map<String, dynamic> categoryMap = {
    "categories": category,
  };
  await foodItemRef.doc('category').set(categoryMap).catchError((e) {
    print(e);
  });
  print('uploaded categroies successfully: ${category.toString()}');
}

getFoodItems(FoodItemNotifier foodItemNotifier) async {
  // User? user = FirebaseAuth.instance.currentUser;
  // getCategories(foodItemNotifier);
  List<String> categories = foodItemNotifier.categoryList;
  Map<String,List<FoodItem>> _foodItemMap = {};

  for (int i = 0; i < categories.length; i++) {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('menu')
        .doc(categories[i])
        .collection('menuItems')
        .get();
    List<FoodItem> _items = [];
    for (var document in snapshot.docs) {
      // print(document.data());
      FoodItem foodItem = FoodItem.fromMap(document.data());
      // print(foodItem.itemName);
      _items.add(foodItem);
    }
    _foodItemMap[categories[i]]=_items;
    // print(_foodItemMap[categories[i]]);
  }
  foodItemNotifier.foodItemMap = _foodItemMap;
}

// getFoodItems(FoodItemNotifier foodItemNotifier) async {
//   // User? user = FirebaseAuth.instance.currentUser;
//   QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('menu')
//       // .doc(user!.uid)
//       // .collection('properties')
//       // .orderBy("date", descending: true)
//       .get();
//   print(snapshot.docs);
//   List<FoodItem> _foodItemList = [];

//   for (var document in snapshot.docs) {
//     // print(document.data())
//     FoodItem foodItem = FoodItem.fromMap(document.data());
//     _foodItemList.add(foodItem);
//   }

//   foodItemNotifier.foodItemList = _foodItemList;
// }

uploadFoodItemAndImage(FoodItem foodItem,String category, bool isUpdating, File localFile,
    Function foodItemUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = const Uuid().v4();

    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('menu/images/$uuid$fileExtension');

    await firebaseStorageRef
        .putFile(localFile)
        .whenComplete(() => null)
        .catchError((onError) {
      print(onError);
      // return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadFoodItem(foodItem, category,isUpdating, foodItemUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadFoodItem(foodItem, category,isUpdating, foodItemUploaded);
  }
}

_uploadFoodItem(FoodItem foodItem, String category,bool isUpdating, Function foodItemUploaded,
    {String? imageUrl}) async {
  CollectionReference foodItemRef =
      FirebaseFirestore.instance.collection('menu')
  .doc(category).collection('menuItems');

  if (imageUrl != null) {
    foodItem.image = imageUrl;
  }

  if (isUpdating) {
    foodItem.updatedAt = Timestamp.now();
    print('updating:${foodItem.id}');
    await foodItemRef.doc(foodItem.id.toString()).update(foodItem.toMap());

    foodItemUploaded(foodItem);
    print('updated FoodItem with id: ${foodItem.id}');
    // Navigator.pop(context);
  } else {
    foodItem.isAvailable = true;
    foodItem.createdAt = Timestamp.now();

    DocumentReference documentRef = await foodItemRef.add(foodItem.toMap());

    foodItem.id = documentRef.id;

    print('uploaded FoodItem successfully: ${foodItem.toString()}');

    await documentRef.set(foodItem.toMap());

    foodItemUploaded(foodItem);
  }
}

changeAvailability(FoodItem? foodItem,String category, bool isAvailable) async {
  CollectionReference foodItemRef =
      FirebaseFirestore.instance.collection('menu').doc(category).collection('menuItems');
  print('updating:${foodItem?.id}');
  foodItem?.isAvailable = isAvailable;
  await foodItemRef.doc(foodItem?.id.toString()).update(foodItem!.toMap());
  print('Avaibility successfully changed for Fooditem: ${foodItem.toString()}');
}

deleteFoodItem(FoodItem foodItem, Function foodItemDeleted) async {
  if (foodItem.image != null) {
    final storageReference =
        FirebaseStorage.instance.refFromURL(foodItem.image.toString());

    await storageReference.delete();

    print('image deleted');
  }

  await FirebaseFirestore.instance.collection('menu').doc(foodItem.id).delete();
  foodItemDeleted(foodItem);
}
