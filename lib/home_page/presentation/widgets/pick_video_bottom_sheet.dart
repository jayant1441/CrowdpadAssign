import 'dart:io';
import 'package:crowdpad_assignment/style_constants.dart';
import 'package:crowdpad_assignment/upload_video_page/presentation/upload_video_page_index.dart';
import 'package:crowdpad_assignment/utils/colors_constant.dart';
import 'package:crowdpad_assignment/video_picker_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickVideoSourceBottomSheet extends StatefulWidget {
  const PickVideoSourceBottomSheet({Key? key}) : super(key: key);

  @override
  State<PickVideoSourceBottomSheet> createState() => _PickVideoSourceBottomSheetState();
}

class _PickVideoSourceBottomSheetState extends State<PickVideoSourceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16),),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [
                0.75,
                0.9,
              ],
              colors: [
                Colors.black,
                AppColors.neonPinkColor
                // AppColors.neonAquaColor.withOpacity(0.5),
              ]
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          ListTile(
              dense: true,
              leading: const SizedBox(),
              title: Center(child : Text("Choose From", style: w600TextStyle(color: Colors.white))),
              trailing: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel", style: TextStyle(color: Colors.white70, letterSpacing: 1),))
          ),

          ListTile(
              leading: Icon(CupertinoIcons.photo, color: AppColors.neonYellowColor,),
              title: Text("Gallery", style: w600TextStyle(color: Colors.white)),
              dense: true,
              onTap: (){
                pickVideo(ImageSource.gallery);
              }
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Divider(color: Colors.white,),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.camera, color: AppColors.greenColor,),
            title: Text("Camera", style: w600TextStyle(color: Colors.white)),
            dense: true,
            onTap: (){
              pickVideo(ImageSource.camera);
            },
          )
        ],
      ),
    );
  }

  void pickVideo(ImageSource imageSource) async{
    try {
      File? video = await VideoPickerUtils.pickVideoFromSource(imageSource);
      if (video != null) {
        Navigator.push(context, CupertinoPageRoute(builder: (_){
          return UploadVideoScreen(videoFile: video);
        }));
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }
}
