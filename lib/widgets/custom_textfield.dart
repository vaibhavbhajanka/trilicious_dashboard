// import 'package:flutter/material.dart';

// final nameField = CustomTextField();

// class CustomTextField extends StatelessWidget {
//   String title;
//   String restaurantName;
//   TextInputType keyboardType;
//   const CustomTextField({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return     TextFormField(
    
//           initialValue: _name??'',
    
//           keyboardType: TextInputType.text,
    
//           validator: (value) {
    
//             // RegExp regex = RegExp(r'^.{3,}$');
    
//             if (value!.isEmpty) {
    
//               return ("Restaurant Name cannot be Empty");
    
//             }
  
//             return null;
    
//           },
    
//           onSaved: (value) {
    
//             // nameController.text = value!;
    
//             _currentRestaurant?.name = value;
    
//           },
    
//           textInputAction: TextInputAction.next,
    
//           decoration: InputDecoration(
    
//             labelStyle: Theme.of(context).textTheme.bodyText2,
    
//             labelText: ' Restaurant Name ',
    
//             floatingLabelBehavior: FloatingLabelBehavior.always,
    
//             enabledBorder: OutlineInputBorder(
    
//               borderSide: const BorderSide(width: 1, color: Colors.black),
    
//               borderRadius: BorderRadius.circular(15),
    
//             ),
    
//             focusedBorder: OutlineInputBorder(
    
//               borderRadius: BorderRadius.circular(20),
    
//               borderSide: const BorderSide(color: Colors.black, width: 1),
    
//             ),
    
//           ),
    
//         );
//   }
// }