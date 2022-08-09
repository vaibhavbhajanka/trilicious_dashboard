class Restaurant{
  String? id;
  String? coverImage;
  String? profileImage;
  String? name;
  String? address;

  Restaurant({this.id,this.coverImage,this.profileImage,this.name,this.address});

  factory Restaurant.fromMap(map){
    return Restaurant(
      id:map['id'],
      coverImage:map['coverImage'],
      profileImage:map['profileImage'],
      name:map['name'],
      address:map['address'],
    );
  }
  
  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'coverImage':coverImage,
      'profileImage':profileImage,
      'name':name,
      'address':address,
    };
  }
}