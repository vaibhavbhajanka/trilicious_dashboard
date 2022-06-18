import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:trilicious_dashboard/api/menu_item_api.dart';
import 'package:trilicious_dashboard/models/menu_item.dart';
import 'package:trilicious_dashboard/notifiers/menu_item_notifier.dart';
import 'package:provider/provider.dart';

class AddMenuItemScreen extends StatefulWidget {
  final bool isUpdating;
  const AddMenuItemScreen({Key? key, required this.isUpdating})
      : super(key: key);
  @override
  State<AddMenuItemScreen> createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController itemDescriptionController =
      TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  MenuItem? _currentMenuItem;
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    MenuItemNotifier menuItemNotifier =
        Provider.of<MenuItemNotifier>(context, listen: false);

    if (menuItemNotifier.currentMenuItem != null) {
      _currentMenuItem = menuItemNotifier.currentMenuItem;
    } else {
      _currentMenuItem = MenuItem();
    }
    // print(_currentMenuItem!.image);
    // print(_currentMenuItem!.itemName);
    // print(_currentMenuItem!.description);
    // print(_currentMenuItem!.price);
    _imageUrl = _currentMenuItem?.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return const Text("image placeholder");
    } else if (_imageFile != null) {
      // print('showing image from local file');

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                _imageFile!,
                fit: BoxFit.cover,
                height: 250,
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
              onPressed: () => _getLocalImage(),
            )
          ],
        ),
      );
    } else if (_imageUrl != null) {
      // print('showing image from ');

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                _imageUrl.toString(),
                fit: BoxFit.cover,
                height: 250,
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
              onPressed: () => _getLocalImage(),
            )
          ],
        ),
      );
    }
  }

  _getLocalImage() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemNameField = TextFormField(
      autofocus: false,
      initialValue: _currentMenuItem!.itemName,
      keyboardType: TextInputType.text,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Item Name cannot be Empty");
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 3 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        // itemNameController.text = value!;
        _currentMenuItem?.itemName = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Item Name ',
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
    final itemDescriptionField = TextFormField(
      autofocus: false,
      initialValue: _currentMenuItem?.description,
      // controller: itemDescriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Item Description cannot be Empty");
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 3 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        // itemDescriptionController.text = value!;
        _currentMenuItem?.description = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Description ',
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
    final priceField = TextFormField(
      autofocus: false,
      initialValue: _currentMenuItem?.price.toString() == "null"
          ? ""
          : _currentMenuItem?.price.toString(),
      // controller: priceController,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regex = RegExp(r'^-?[0-9]+$');

        if (value!.isEmpty) {
          return ("Price cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter numbers only");
        }
        return null;
      },
      onSaved: (value) {
        // priceController.text = value!;
        _currentMenuItem?.price = int.parse(value.toString());
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Price ',
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

    _onMenuItemUploaded(MenuItem menuItem) {
      MenuItemNotifier menuItemNotifier =
          Provider.of<MenuItemNotifier>(context, listen: false);
      if (menuItem.updatedAt == null) {
        menuItemNotifier.addMenuItem(menuItem);
      }
      Navigator.pop(context);
    }

    _saveMenuItem() {
      print('saveMenuItem Called');
      if (!_formKey.currentState!.validate()) {
        return;
      }

      _formKey.currentState!.save();

      print('form saved');

      // _currentMenuItem.subIngredients = _subingredients;
      // print("name: ${_currentMenuItem?.itemName}");
      // print("description: ${_currentMenuItem?.description}");
      // print("price: ${_currentMenuItem?.price.toString()}");
      // print("_imageFile ${_imageFile.toString()}");
      // print("_imageUrl $_imageUrl");

      uploadMenuItemAndImage(_currentMenuItem!, widget.isUpdating, _imageFile!,
          _onMenuItemUploaded);

      // print("name: ${_currentMenuItem?.itemName}");
      // print("description: ${_currentMenuItem?.description}");
      // print("price: ${_currentMenuItem?.price.toString()}");
      // print("_imageFile ${_imageFile.toString()}");
      // print("_imageUrl $_imageUrl");
    }

    MenuItemNotifier menuItemNotifier =
        Provider.of<MenuItemNotifier>(context, listen: false);

    _onMenuItemDeleted(MenuItem menuItem) {
      Navigator.pop(context);
      menuItemNotifier.deleteMenuItem(menuItem);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('ADD MENU ITEM'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete this item?'),
                    actions: [
                      _DialogButton(
                          text: 'Cancel',
                          onPressed: ()=>Navigator.of(context).pop()),
                      _DialogButton(
                        text: 'OK',
                        onPressed: () {
                          Navigator.of(context).pop();
                          deleteMenuItem(
                            _currentMenuItem!, _onMenuItemDeleted);
                        } 
                      ),
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
                    padding: const EdgeInsets.all(15.0),
                    child: itemNameField,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ListTile(
                      title: const Text(
                        'Item Image',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: _imageFile == null && _imageUrl == null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
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
                                  onPressed: () {
                                    _getLocalImage();
                                  },
                                ),
                              ),
                            )
                          : _showImage(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: itemDescriptionField,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: priceField,
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
                _saveMenuItem();
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
