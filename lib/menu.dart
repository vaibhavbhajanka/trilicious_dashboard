import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trilicious_dashboard/api/food_item_api.dart';
import 'package:trilicious_dashboard/api/profile_api.dart';
import 'package:trilicious_dashboard/models/food_item.dart';
// import 'package:trilicious_dashboard/api/profile_api.dart';
// import 'package:trilicious_dashboard/models/food_item.dart';
// import 'package:trilicious_dashboard/notifiers/category_notifier.dart';
// import 'package:trilicious_dashboard/notifier/auth_notifier.dart';
import 'package:trilicious_dashboard/notifiers/food_item_notifier.dart';
// import 'package:trilicious_dashboard/screens/detail.dart';
import 'package:trilicious_dashboard/add_food_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trilicious_dashboard/notifiers/profile_notifier.dart';
// import 'package:trilicious_dashboard/notifiers/profile_notifier.dart';

// final _firestore = FirebaseFirestore.instance;

User? user = FirebaseAuth.instance.currentUser;

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool isLoaded = false;
  @override
  void initState() {
    FoodItemNotifier foodItemNotifier =
        Provider.of<FoodItemNotifier>(context, listen: false);
    ProfileNotifier profileNotifier = Provider.of<ProfileNotifier>(context,listen:false);
    getProfile(profileNotifier);
    // print(profileNotifier.currentRestaurant);
    getCategories(foodItemNotifier).then((value) {
      setState(() {
        isLoaded=true;
      });
      // getFoodItems(foodItemNotifier);
    //   foodItemNotifier.currentCategory =
    //   foodItemNotifier.categoryList.isNotEmpty?
    //      foodItemNotifier.categoryList.first
    //      :"";
    });
    super.initState();
  }

  // bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    // AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FoodItemNotifier foodItemNotifier = Provider.of<FoodItemNotifier>(context);
    // List<FoodItem>? itemList = foodItemNotifier.foodItemMap[foodItemNotifier.currentCategory.toString()];

    Future<void> _refreshList() async {
      getCategories(foodItemNotifier).then((value) {
        getFoodItems(foodItemNotifier);
        // foodItemNotifier.currentCategory=foodItemNotifier.categoryList[0];
      });
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            // authNotifier.user != null ? authNotifier.user.displayName : "Menu",
            'MENU'),
        backgroundColor: Colors.orange,
      ),
      body: isLoaded==false?
      CircularProgressIndicator():
       Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.orange,
              child: Row(
                children: [
                  Flexible(
                    child: StreamBuilder(
                      // initialData: <S,
                        stream: FirebaseFirestore.instance
                            .collection('menu')
                            .doc(user!.email)
                            .collection('categories')
                            .doc('category')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          List<String> categories =
                              snapshot.data?['categories'].cast<String>();
                          // foodItemNotifier.currentCategory=categories[0];
                          return snapshot.hasData
                              ? ConstrainedBox(
                                  constraints: BoxConstraints.expand(
                                      width: double.infinity,
                                      height: size.height * 0.08),
                                  child: ListView.builder(
                                      itemCount: categories.length,
                                      // reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            // foodItemNotifier.currentCategory=categories[0];
                                        return CategoryButton(
                                          category: categories[index],
                                          onPressed: () {
                                            foodItemNotifier.currentCategory =
                                                categories[index];
                                            // foodItemNotifier.foodItemList =
                                            //     foodItemNotifier.foodItemMap[
                                            //             foodItemNotifier
                                            //                 .currentCategory
                                            //                 .toString()] ??
                                            //         [];
                                            // print(
                                            //     foodItemNotifier.foodItemList);
                                          },
                                          isSelected: foodItemNotifier
                                                  .currentCategory ==
                                              categories[index],
                                        );
                                      }),
                                )
                              : Container();
                        }),
                  ),
                  // foodItemNotifier.categoryList.isNotEmpty?
                  // Expanded(
                  //   child: ListView.builder(
                  //       itemCount: foodItemNotifier.categoryList.length,
                  //       // reverse: true,
                  //       scrollDirection: Axis.horizontal,
                  //       itemBuilder: (BuildContext context, int index) {
                  //         return CategoryButton(
                  //             category: foodItemNotifier.categoryList[index],
                  //             onPressed: () {
                  //               foodItemNotifier.currentCategory=foodItemNotifier.categoryList[index];
                  //               foodItemNotifier.foodItemList=foodItemNotifier.foodItemMap[foodItemNotifier.currentCategory.toString()]??[];
                  //               print(foodItemNotifier.foodItemList);
                  //             },
                  //             isSelected: foodItemNotifier.currentCategory==foodItemNotifier.categoryList[index],
                  //             );

                  //       }),
                  // ):Container(),
                  IconButton(
                    onPressed: () => showAddCategoryDialog(context),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('menu')
                  .doc(user!.email)
                  .collection('categories')
                  .doc(foodItemNotifier.currentCategory)
                  .collection('menuItems')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                print(snapshot.data?.docs);
                // List<FoodItem> _items =
                //       FoodItem.fromMap(snapshot.data?.docs) as List<FoodItem>;
                // print(_items);
                return snapshot.hasData
                    ? Flexible(
                        flex: 7,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            FoodItem foodItem =
                                FoodItem.fromMap(snapshot.data!.docs[index]);
                            return GestureDetector(
                              onTap: () {
                                foodItemNotifier.currentFoodItem =foodItem;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const AddFoodItemScreen(
                                    isUpdating: true,
                                  );
                                }));
                              },
                              child: ItemCard(
                                image: foodItem.image
                                    .toString(),
                                itemName: foodItem.itemName
                                    .toString(),
                                description: foodItem.description
                                    .toString(),
                                price: foodItem.price ??
                                    0,
                                isAvailable: Switch(
                                  value: foodItem.isAvailable ??
                                      false,
                                  onChanged: (value) {
                                    foodItemNotifier.currentFoodItem =
                                        foodItem;
                                        // Notifier.foodItemList[index];
                                    // setState(() {
                                    // foodItemNotifier.foodItemList[index]
                                    //     .isAvailable = value;
                                    foodItem.isAvailable=value;
                                    changeAvailability(
                                        // foodItemNotifier.foodItemList[index],
                                        foodItem,
                                        foodItemNotifier.currentCategory
                                            .toString(),
                                        value);
                                    // });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Flexible(
                        flex: 7,
                        child: Center(
                          child: Text('No Items in this category'),
                        ));
              }),
          // foodItemNotifier.foodItemList.isNotEmpty
          //     ? Flexible(
          //         flex: 7,
          //         child: RefreshIndicator(
          //           child: ListView.separated(
          //             itemBuilder: (BuildContext context, int index) {
          // return GestureDetector(
          //   onTap: () {
          //     foodItemNotifier.currentFoodItem =
          //         foodItemNotifier.foodItemList[index];
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (BuildContext context) {
          //       return const AddFoodItemScreen(
          //         isUpdating: true,
          //       );
          //     }));
          //   },
          //   child: ItemCard(
          //     image: foodItemNotifier.foodItemList[index].image
          //         .toString(),
          //     itemName: foodItemNotifier
          //         .foodItemList[index].itemName
          //         .toString(),
          //     description: foodItemNotifier
          //         .foodItemList[index].description
          //         .toString(),
          //     price:
          //         foodItemNotifier.foodItemList[index].price ?? 0,
          //     isAvailable: Switch(
          //       value: foodItemNotifier
          //               .foodItemList[index].isAvailable ??
          //           false,
          //       onChanged: (value) {
          //         foodItemNotifier.currentFoodItem =
          //             foodItemNotifier.foodItemList[index];
          //         // setState(() {
          //         foodItemNotifier
          //             .foodItemList[index].isAvailable = value;
          //         changeAvailability(
          //             foodItemNotifier.foodItemList[index],
          //             foodItemNotifier.currentCategory.toString(),
          //             value);
          //         // });
          //       },
          //     ),
          //   ),
          // );
          //             },
          //             itemCount: foodItemNotifier.foodItemList.length,
          //             separatorBuilder: (BuildContext context, int index) {
          //               return const SizedBox(
          //                 width: 0,
          //                 height: 0,
          //               );
          //             },
          //           ),
          //           onRefresh: _refreshList,
          //         ),
          //       )
          //     : const Flexible(
          //         flex: 7,
          //         child: Center(
          //           child: Text('No Items in this category'),
          //         )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          foodItemNotifier.currentFoodItem = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return const AddFoodItemScreen(
                isUpdating: false,
              );
            }),
          );
        },
        child: const Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String category;
  final VoidCallback onPressed;
  final bool isSelected;
  const CategoryButton(
      {Key? key,
      required this.category,
      required this.onPressed,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(category),
        style: OutlinedButton.styleFrom(
          // backgroundColor: Colors.white,
          primary: isSelected ? Colors.black : Colors.white,
          backgroundColor: isSelected ? Colors.white : Colors.transparent,
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

showAddCategoryDialog(BuildContext context) {
  // _onCategoryUploaded(List<String> categories) {
  //     foodItemNotifier foodItemNotifier =
  //         Provider.of<foodItemNotifier>(context, listen: false);
  //     if (foodItem.updatedAt == null) {
  //       foodItemNotifier.addFoodItem(foodItem);
  //     }
  //     Navigator.pop(context);
  //   }
  showDialog(
    context: context,
    builder: (_) {
      //   _onCategoryUploaded( foodItem) {
      //   FoodItemNotifier foodItemNotifier =
      //       Provider.of<FoodItemNotifier>(context, listen: false);
      //   if (foodItem.updatedAt == null) {
      //     foodItemNotifier.addFoodItem(foodItem);
      //   }
      //   Navigator.pop(context);
      // }
      FoodItemNotifier foodItemNotifier =
          Provider.of<FoodItemNotifier>(context);
      var categoryController = TextEditingController();
      return AlertDialog(
        title: const Text('Add Category'),
        content: TextFormField(
          controller: categoryController,
          decoration: const InputDecoration(hintText: 'Category'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Send them to your email maybe?
              String category = categoryController.text;
              foodItemNotifier.addCategory(category);
              uploadCategory(foodItemNotifier.categoryList);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

class ItemCard extends StatefulWidget {
  final String? image;
  final String? itemName;
  final String? description;
  final int price;
  final Widget isAvailable;

  const ItemCard(
      {Key? key,
      required this.image,
      required this.itemName,
      required this.description,
      required this.price,
      required this.isAvailable})
      : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.125,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.image ??
                    'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.itemName.toString(),
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    '\u{20B9}${widget.price}',
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      widget.description.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: widget.isAvailable,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
      {Key? key, required this.text, this.style, required this.gradient})
      : super(key: key);

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}


// ListTile(
//               leading: Image.network(
//                 menuItemNotifier.menuItemList[index].image != null
//                     ? menuItemNotifier.menuItemList[index].image.toString()
//                     : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
//                 width: 120,
//                 fit: BoxFit.fitWidth,
//               ),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     menuItemNotifier.menuItemList[index].itemName.toString(),
//                   ),
//                   Text(
//                     '\u{20B9}${menuItemNotifier.menuItemList[index].price.toString()}',
//                   ),
//                   Switch(
//                     value: switchValue,
//                     onChanged: (value) {
//                       setState(() {
//                         switchValue = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               subtitle: Text(
//                   menuItemNotifier.menuItemList[index].description.toString()),
              // onTap: () {
              //   // menuItemNotifier.currentMenuItem = menuItemNotifier.menuItemList[index];
              //   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
              //     return const AddMenuItemScreen(
              //       isUpdating: true,
              //     );
              //   }));
              // },
//             );


// class ItemCard extends StatelessWidget {
//   const ItemCard({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             Image.network(
//                 menuItemNotifier.menuItemList[index].image != null
//                     ? menuItemNotifier.menuItemList[index].image.toString()
//                     : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
//                 width: 120,
//                 fit: BoxFit.fitWidth,
//               ),
//             ListTile(
//               title: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       menuItemNotifier.menuItemList[index].itemName.toString(),
//                       style: TextStyle(
//                         fontSize: 19,
//                       ),
//                     ),
//                     Text(
//                       menuItemNotifier.menuItemList[index].price.toString(),
//                       style: TextStyle(
//                         fontSize: 19,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               subtitle: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                      Expanded(
//                       flex: 5,
//                       child: Text(
//                         menuItemNotifier.menuItemList[index].description.toString(),
//                         style: TextStyle(
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
