import 'dart:io';

import 'package:image_picker/image_picker.dart';

class VideoPickerUtils {

  static Future<File?> pickVideoFromSource(ImageSource src) async{
    try{
      final video = await ImagePicker().pickVideo(source: src);
      if(video != null){
        return File(video.path);
      }
      return null;
    }
    catch(e){
      throw Exception("Error while picking video");
    }
  }
}