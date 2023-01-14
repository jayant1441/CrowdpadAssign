import 'dart:io';
import 'package:crowdpad_assignment/auth/data/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class AuthApiHandler{

  //User Register

  /// The function [signUpUser] will signup the user
  static Future<bool?> signUpUser(String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && image != null) {
        /// creating a user in firebase auth
        UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        /// getting the url for the picture uploaded
        String downloadUrl = await _uploadProPic(image);

        UserModel user = UserModel(
            name: username,
            email: email,
            profilePic: downloadUrl,
            uid: credential.user!.uid
        );

        /// saving the user data into firebase firestore
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(user.toJson());

        return true;
      }
      return null;
    } catch (e) {
      print(e);
      throw Exception("Error Occurred $e");
    }
  }


  /// The functon [_uploadProPic] will upload profile pic to firebase storage
  static Future<String> _uploadProPic(File image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profilePics')
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String imageDwnUrl = await snapshot.ref.getDownloadURL();
    return imageDwnUrl;
  }


  /// The function [login] will login the user
  static Future<bool?> login(String email, String password) async {
    try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        return true;
    }
    catch(e){
      throw Exception("Error Occurred $e");
    }
  }

}