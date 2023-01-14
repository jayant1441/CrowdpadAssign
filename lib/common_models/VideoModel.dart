class VideoModel {
  VideoModel({
      this.username, 
      this.uid, 
      this.profilePic, 
      this.id, 
      this.videoUrl, 
      this.thumbnail,});

  VideoModel.fromJson(dynamic json) {
    username = json['username'];
    uid = json['uid'];
    profilePic = json['profilePic'];
    id = json['id'];
    videoUrl = json['videoUrl'];
    thumbnail = json['thumbnail'];
  }
  String? username;
  String? uid;
  String? profilePic;
  String? id;
  String? videoUrl;
  String? thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['uid'] = uid;
    map['profilePic'] = profilePic;
    map['id'] = id;
    map['videoUrl'] = videoUrl;
    map['thumbnail'] = thumbnail;
    return map;
  }

}