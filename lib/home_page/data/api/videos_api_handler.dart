import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdpad_assignment/common_models/VideoModel.dart';

class VideosApiHandler{
  static Future<List<VideoModel>> getAllVideos() async {
    try{
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('videos');
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Get data from docs and convert map to List
      final List<VideoModel> allVideos = querySnapshot.docs.map((doc) {
        return VideoModel.fromJson(doc.data() as Map<String , dynamic>);
      }).toList();

      return allVideos;
    }
    catch(E){
      throw Exception("Error Occurred $E");
    }
  }
}