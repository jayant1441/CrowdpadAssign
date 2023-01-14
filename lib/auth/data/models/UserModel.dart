class UserModel {
  UserModel({
      this.name, 
      this.profilePic, 
      this.email, 
      this.uid,});

  UserModel.fromJson(dynamic json) {
    name = json['name'];
    profilePic = json['profilePic'];
    email = json['email'];
    uid = json['uid'];
  }
  String? name;
  String? profilePic;
  String? email;
  String? uid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['profilePic'] = profilePic;
    map['email'] = email;
    map['uid'] = uid;
    return map;
  }

}