class Restaurant{
  String? coverImage;
  String? profileImage;
  String? name;
  String? address;

  Restaurant({this.coverImage,this.profileImage,this.name,this.address});

  factory Restaurant.fromMap(map){
    return Restaurant(
      coverImage:map['coverImage'],
      profileImage:map['profileImage'],
      name:map['name'],
      address:map['address'],
    );
  }
  
  Map<String,dynamic> toMap(){
    return{
      'coverImage':coverImage,
      'profileImage':profileImage,
      'name':name,
      'address':address,
    };
  }
}