import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:trilicious_dashboard/api/food_item_api.dart';
import 'package:trilicious_dashboard/models/food_item.dart';
// import 'package:trilicious_dashboard/notifiers/category_notifier.dart';
import 'package:trilicious_dashboard/notifiers/food_item_notifier.dart';
import 'package:provider/provider.dart';

class AddFoodItemScreen extends StatefulWidget {
  final bool isUpdating;
  const AddFoodItemScreen({Key? key, required this.isUpdating})
      : super(key: key);
  @override
  State<AddFoodItemScreen> createState() => _AddFoodItemScreenState();
}

class _AddFoodItemScreenState extends State<AddFoodItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController itemDescriptionController =
      TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  FoodItem? _currentFoodItem;
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    FoodItemNotifier foodItemNotifier =
        Provider.of<FoodItemNotifier>(context, listen: false);

    if (foodItemNotifier.currentFoodItem != null) {
      _currentFoodItem = foodItemNotifier.currentFoodItem;
    } else {
      _currentFoodItem = FoodItem();
    }
    _imageUrl = _currentFoodItem?.image;
  }

  // List<String> _options = ['Regular', 'Medium', 'Large'];
  //   String? _selectedOption = 'Regular';

  // List<String> _addOns = ['Mushroom', 'Olives', 'Cheese'];
  //   String? _selected = 'Regular';

  bool isLoading = false;
  bool isDeleting = false;

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
      initialValue: _currentFoodItem!.itemName,
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
        _currentFoodItem?.itemName = value;
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
      initialValue: _currentFoodItem?.description,
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
        _currentFoodItem?.description = value;
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
      initialValue: _currentFoodItem?.price.toString() == "null"
          ? ""
          : _currentFoodItem?.price.toString(),
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
        _currentFoodItem?.price = int.parse(value.toString());
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

    _onFoodItemUploaded(FoodItem foodItem) {
      FoodItemNotifier foodItemNotifier =
          Provider.of<FoodItemNotifier>(context, listen: false);
      // CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);
      if (foodItem.updatedAt == null) {
        foodItemNotifier.addFoodItem(
            foodItem, foodItemNotifier.currentCategory.toString());
      }
      final snackBar = SnackBar(
        content: widget.isUpdating == true
            ? const Text('Updated Item Info')
            : const Text('Added Item Info'),
        duration: const Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    }

    _saveFoodItem() {
      setState(() {
        isLoading = true;
      });
      print('saveFoodItem Called');
      if (!_formKey.currentState!.validate()) {
        return;
      }

      _formKey.currentState!.save();

      print('form saved');
      FoodItemNotifier foodItemNotifier =
          Provider.of<FoodItemNotifier>(context, listen: false);

      uploadFoodItemAndImage(
              _currentFoodItem!,
              foodItemNotifier.currentCategory.toString(),
              widget.isUpdating,
              _imageFile,
              _onFoodItemUploaded)
          .then((value) {
        isLoading = false;
      });
      // print("name: ${_currentFoodItem?.itemName}");
      // print("description: ${_currentFoodItem?.description}");
      // print("price: ${_currentFoodItem?.price.toString()}");
      // print("_imageFile ${_imageFile.toString()}");
      // print("_imageUrl $_imageUrl");
    }

    FoodItemNotifier foodItemNotifier =
        Provider.of<FoodItemNotifier>(context, listen: false);

    _onFoodItemDeleted(FoodItem foodItem) {
      // CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);
      final snackBar = SnackBar(
        content:const Text('Deleted Item Info'),
        duration: const Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
      
      // foodItemNotifier
      //     .deleteFoodItem(foodItem, foodItemNotifier.currentCategory.toString());
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: widget.isUpdating == true
            ? const Text('Update Food Item')
            : const Text('Add Food Item'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete this item?'),
                    actions: [
                      _DialogButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.of(context).pop()),
                      _DialogButton(
                          text: 'OK',
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              isLoading = true;
                            });
                            deleteFoodItem(
                                    _currentFoodItem!,
                                    _onFoodItemDeleted,
                                    foodItemNotifier.currentCategory.toString())
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          }),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                        onPressed: () {
                                          _getLocalImage();
                                        },
                                      ),
                                    ),
                                  )
                                : _showImage(),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     DropdownButton<String>(
                        //         value: _selectedOption,
                        //         items: _options.map(
                        //           (item) => DropdownMenuItem<String>(
                        //             value: item,
                        //             child: Text(item),
                        //           ),
                        //         ).toList(),
                        //         onChanged: (item)=>setState(() {
                        //           _selectedOption=item;
                        //         }),),
                        //   ],
                        // ),
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
                      // setState(() {
                      //   isLoading=true;
                      // });
                      _saveFoodItem();
                      // then((value){
                      //   setState(() {
                      //   isLoading=false;
                      // });
                      // });
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
