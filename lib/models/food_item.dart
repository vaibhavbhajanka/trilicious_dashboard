import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem{
  String? id;
  String? image;
  String? itemName;
  // Map<String,int>? options;
  // Map<String,int>? addOns;
  int? price;
  String? description;
  bool? isAvailable;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  FoodItem({this.id,this.image,this.itemName,this.price,this.description,this.isAvailable,this.createdAt,this.updatedAt});

  factory FoodItem.fromMap(map){
    return FoodItem(
      id:map['id'],
      image:map['image'],
      itemName:map['itemName'],
      // options: map['options'],
      // addOns: map['addOns'],
      price:map['price'],
      description:map['description'],
      isAvailable: map['isAvailable'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt']
    );
  }
  
  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'image':image,
      'itemName':itemName,
      // 'options':options,
      // 'addOns':addOns,
      'price':price,
      'description':description,
      'isAvailable':isAvailable,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}