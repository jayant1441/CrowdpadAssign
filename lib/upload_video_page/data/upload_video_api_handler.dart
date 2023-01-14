import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdpad_assignment/auth/data/models/UserModel.dart';
import 'package:crowdpad_assignment/common_models/VideoModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';


class UploadVideoApiHandler{

  static const uuid = Uuid();


  static Future<bool?> uploadVideo( String videoPath) async{

    try{
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDocument = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      String id  = uuid.v1();

      /// uploading video to firebase storage
      String videoUrl = await _uploadVideoToStorage( id, videoPath);

      /// uploading video thumbnail to firebase storage
      String thumbnail  = await _uploadVideoThumbToStorage(id , videoPath);

      final user = UserModel.fromJson(userDocument.data()! as Map<String , dynamic>);

      VideoModel video = VideoModel(
          uid: uid,
          username: "${user.name}",
          videoUrl: videoUrl,
          thumbnail: thumbnail,
          profilePic: "${user.profilePic}",
          id: id
      );
      await FirebaseFirestore.instance.collection("videos").doc(id).set(video.toJson());

      return true;

    }catch(e, stack){
      print(e);
      print(stack);
      throw Exception("Error Occurred $e");
    }
  }

  static Future<File> _getThumb(String videoPath) async{
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  static Future<String> _uploadVideoThumbToStorage(String id , String videoPath) async{
    Reference reference = FirebaseStorage.instance.ref().child("thumbnail").child(id);
    UploadTask uploadTask = reference.putFile(await _getThumb(videoPath));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Function to upload video to storage and give download URL
  static Future<String> _uploadVideoToStorage(String videoID , String videoPath) async{
    Reference reference = FirebaseStorage.instance.ref().child("videos").child(videoID);
    UploadTask uploadTask = reference.putFile(await _compressVideo(videoPath));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// This function will compress the video
  static Future<File> _compressVideo(String videoPath) async{
    final compressedVideo =
    await VideoCompress.compressVideo(videoPath, quality: VideoQuality.MediumQuality);
    return compressedVideo!.file!;
  }

}