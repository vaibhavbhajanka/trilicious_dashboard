import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem{
  String? id;
  String? image;
  String? itemName;
  int? price;
  String? description;
  bool? isAvailable;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  MenuItem({this.id,this.image,this.itemName,this.price,this.description,this.isAvailable,this.createdAt,this.updatedAt});

  factory MenuItem.fromMap(map){
    return MenuItem(
      id:map['id'],
      image:map['image'],
      itemName:map['itemName'],
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
      'price':price,
      'description':description,
      'isAvailable':isAvailable,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}