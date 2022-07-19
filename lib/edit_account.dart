import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trilicious_dashboard/api/profile_api.dart';
import 'dart:io';
import 'package:trilicious_dashboard/models/restaurant.dart';
// import 'package:trilicious_dashboard/notifiers/category_notifier.dart';
// import 'package:trilicious_dashboard/notifiers/food_item_notifier.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_dashboard/notifiers/profile_notifier.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({Key? key}) : super(key: key);
  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // final TextEditingController addressController = TextEditingController();
  // final TextEditingController nameController = TextEditingController();

  Restaurant? _currentRestaurant;
  String? _coverImageUrl;
  File? _coverImageFile;
  String? _profileImageUrl;
  File? _profileImageFile;
  // String? _name;
  // String? _address;

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   ProfileNotifier profileNotifier =
  //       Provider.of<ProfileNotifier>(context);
  //   // setState(() {

  //   super.didChangeDependencies();
  // }
  @override
  void initState() {
    print("account called");
    ProfileNotifier profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);
    
    _currentRestaurant = profileNotifier.currentRestaurant ?? Restaurant();
    // });
    print(_currentRestaurant?.name);
    print(_currentRestaurant?.address);
    print(_currentRestaurant?.coverImage);
    print(_currentRestaurant?.profileImage);

    _coverImageUrl = _currentRestaurant?.coverImage;
    _profileImageUrl = _currentRestaurant?.profileImage;
    super.initState();
    // _name = _currentRestaurant?.name;
    // _address = _currentRestaurant?.address;
    // FoodItemNotifier foodItemNotifier =
    //     Provider.of<FoodItemNotifier>(context, listen: false);
    // _imageUrl = _currentFoodItem?.image;
  }

  _showImage(
      File? imgFile, String? imgUrl, VoidCallback onPressed, bool isCover) {
    if (imgFile == null && imgUrl == null) {
      return const Text("image placeholder");
    } else if (imgFile != null) {
      // print('showing image from local file');

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                imgFile,
                fit: BoxFit.cover,
                height: isCover ? 250 : 100,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(8)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black54),
              ),
              child: const Text(
                'Change Image',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              onPressed: onPressed,
            )
          ],
        ),
      );
    } else if (imgUrl != null) {
      // print('showing image from ');

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imgUrl.toString(),
                fit: BoxFit.cover,
                height: isCover ? 250 : 100,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(8)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black54),
              ),
              child: const Text(
                'Change Image',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              onPressed: onPressed,
            )
          ],
        ),
      );
    }
  }

  _getCoverImage() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _coverImageFile = File(imageFile.path);
      });
    }
  }

  _getProfileImage() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _profileImageFile = File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileNotifier profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);
    final nameField = TextFormField(
      autofocus: false,
      initialValue: _currentRestaurant!.name,
      keyboardType: TextInputType.text,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Restaurant Name cannot be Empty");
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 3 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        // nameController.text = value!;
        _currentRestaurant?.name = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Restaurant Name ',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
    final addressField = TextFormField(
      autofocus: false,
      initialValue: _currentRestaurant!.address,
      // controller: itemDescriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Restaurant address cannot be Empty");
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 3 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        // itemDescriptionController.text = value!;
        _currentRestaurant?.address = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Restaurant Address ',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );

    // _onFoodItemUploaded(FoodItem foodItem) {
    //   FoodItemNotifier foodItemNotifier =
    //       Provider.of<FoodItemNotifier>(context, listen: false);
    //   // CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);
    //   if (foodItem.updatedAt == null) {
    //     foodItemNotifier.addFoodItem(foodItem,foodItemNotifier.currentCategory.toString());
    //   }
    //   Navigator.pop(context);
    // }

    _saveProfile() {
      print('saveProfile Called');
      if (!_formKey.currentState!.validate()) {
        return;
      }

      _formKey.currentState!.save();
      print('form saved');
      ProfileNotifier profileNotifier =
          Provider.of<ProfileNotifier>(context, listen: false);
      // print(_currentRestaurant);
      // profileNotifier.currentRestaurant = _currentRestaurant;
      // print(profileNotifier.currentRestaurant);
      uploadProfile(_currentRestaurant!, _coverImageFile, _profileImageFile);
      // uploadFoodItemAndImage(_currentFoodItem!,foodItemNotifier.currentCategory.toString(), widget.isUpdating, _imageFile!,
      //     _onFoodItemUploaded);
    }

    // FoodItemNotifier foodItemNotifier =
    //     Provider.of<FoodItemNotifier>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Edit Account'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
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
                            //logout function
                          }),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ListTile(
                      title: const Text(
                        'Cover Image',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle:
                          _coverImageFile == null && _coverImageUrl == null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: OutlinedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(50.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.add),
                                            Text(
                                              'Add Image',
                                            ),
                                          ],
                                        ),
                                      ),
                                      onPressed: _getCoverImage,
                                    ),
                                  ),
                                )
                              : _showImage(_coverImageFile, _coverImageUrl,
                                  _getCoverImage, true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ListTile(
                      title: const Text(
                        'Profile Image',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: _profileImageFile == null &&
                              _profileImageUrl == null
                          ? Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: OutlinedButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.add),
                                      Text(
                                        'Add Image',
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: _getProfileImage,
                              ),
                            )
                          : _showImage(_profileImageFile, _profileImageUrl,
                              _getProfileImage, false),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: nameField,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: addressField,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              onPressed: () {
                _saveProfile();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 80, right: 80, top: 20, bottom: 20),
                child: Wrap(
                  children: const [
                    Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
