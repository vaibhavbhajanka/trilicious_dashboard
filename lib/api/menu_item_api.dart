import 'dart:io';
// import 'package:trilicious_dashboard/model/user_model.dart';
import 'package:trilicious_dashboard/models/menu_item.dart';
import 'package:trilicious_dashboard/notifiers/menu_item_notifier.dart';
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

// addChatRoom(chatRoom, chatRoomId) async {
//     await FirebaseFirestore.instance
//         .collection("chatRoom")
//         .doc(chatRoomId)
//         .set(chatRoom)
//         .catchError((e) {
//       print(e);
//     });
//   }

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
getMenuItems(MenuItemNotifier menuItemNotifier) async {
  // User? user = FirebaseAuth.instance.currentUser;
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('menu')
      // .doc(user!.uid)
      // .collection('properties')
      // .orderBy("date", descending: true)
      .get();

  List<MenuItem> _menuItemList = [];

  for (var document in snapshot.docs) {
    // print(document.data())
    MenuItem menuItem = MenuItem.fromMap(document.data());
    _menuItemList.add(menuItem);
  }

  menuItemNotifier.menuItemList = _menuItemList;
}

uploadMenuItemAndImage(MenuItem menuItem, bool isUpdating, File localFile, Function menuItemUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = const Uuid().v4();

    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('menu/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).whenComplete(() => null).catchError((onError) {
      print(onError);
      // return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadmenuItem(menuItem, isUpdating, menuItemUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadmenuItem(menuItem, isUpdating, menuItemUploaded);
  }
}

_uploadmenuItem(MenuItem menuItem, bool isUpdating, Function menuItemUploaded, {String? imageUrl}) async {
  CollectionReference menuItemRef = FirebaseFirestore.instance.collection('menu');

  if (imageUrl != null) {
    menuItem.image = imageUrl;
  }

  if (isUpdating) {
    menuItem.updatedAt = Timestamp.now();
    print('updating:${menuItem.id}');
    await menuItemRef.doc(menuItem.id.toString()).update(menuItem.toMap());

    menuItemUploaded(menuItem);
    print('updated menuItem with id: ${menuItem.id}');
    // Navigator.pop(context);
  } else {
    menuItem.isAvailable = true;
    menuItem.createdAt = Timestamp.now();

    DocumentReference documentRef = await menuItemRef.add(menuItem.toMap());

    menuItem.id = documentRef.id;

    print('uploaded menuItem successfully: ${menuItem.toString()}');

    await documentRef.set(menuItem.toMap());

    menuItemUploaded(menuItem);
  }
}

deleteMenuItem(MenuItem menuItem, Function menuItemDeleted) async {
  if (menuItem.image != null) {
    final storageReference =
        await FirebaseStorage.instance.refFromURL(menuItem.image.toString());

    // print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await FirebaseFirestore.instance.collection('menu').doc(menuItem.id).delete();
  menuItemDeleted(menuItem);
}