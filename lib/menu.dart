import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:trilicious_dashboard/api/menu_item_api.dart';
// import 'package:trilicious_dashboard/notifier/auth_notifier.dart';
import 'package:trilicious_dashboard/notifiers/menu_item_notifier.dart';
// import 'package:trilicious_dashboard/screens/detail.dart';
import 'package:trilicious_dashboard/add_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    MenuItemNotifier menuItemNotifier =
        Provider.of<MenuItemNotifier>(context, listen: false);
    getMenuItems(menuItemNotifier);
    super.initState();
  }

  // bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    // AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    MenuItemNotifier menuItemNotifier = Provider.of<MenuItemNotifier>(context);

    Future<void> _refreshList() async {
      getMenuItems(menuItemNotifier);
    }

    // print("building Menu");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            // authNotifier.user != null ? authNotifier.user.displayName : "Menu",
            'MENU'),
        backgroundColor: Colors.orange,
        // actions: <Widget>[
        //   // action button
        //   FlatButton(
        //     onPressed: () => signout(authNotifier),
        //     child: Text(
        //       "Logout",
        //       style: TextStyle(fontSize: 20, color: Colors.white),
        //     ),
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                menuItemNotifier.currentMenuItem = menuItemNotifier.menuItemList[index];
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const AddMenuItemScreen(
                    isUpdating: true,
                  );
                }));
              },
              child: ItemCard(
                image: menuItemNotifier.menuItemList[index].image.toString(),
                itemName:
                    menuItemNotifier.menuItemList[index].itemName.toString(),
                description: menuItemNotifier.menuItemList[index].description
                    .toString(),
                price: int.parse(
                    menuItemNotifier.menuItemList[index].price.toString()),
                    isAvailable: Switch(
                      value: menuItemNotifier.menuItemList[index].isAvailable??false,
                      onChanged: (value) {
                        menuItemNotifier.currentMenuItem = menuItemNotifier.menuItemList[index];
                        setState(() {
                          menuItemNotifier.menuItemList[index].isAvailable=value;
                        });
                      },
                    ),
              ),
            );
          },
          itemCount: menuItemNotifier.menuItemList.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 0,
              height: 0,
            );
          },
        ),
        onRefresh: _refreshList,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          menuItemNotifier.currentMenuItem = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return const AddMenuItemScreen(
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

class ItemCard extends StatefulWidget {
  final String image;
  final String itemName;
  final String description;
  final int price;
  Widget isAvailable;
  
  ItemCard(
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
                widget.image != null
                    ? widget.image
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
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
                    widget.itemName,
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    '\u{20B9}${widget.price}',
                    style: TextStyle(
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
                      widget.description,
                      style: TextStyle(
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
