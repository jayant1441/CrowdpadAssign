import 'dart:io';
import 'package:crowdpad_assignment/home_page/presentation/home_page_index.dart';
import 'package:crowdpad_assignment/upload_video_page/business_logic/upload_video_cubit.dart';
import 'package:crowdpad_assignment/upload_video_page/data/upload_video_api_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class UploadVideoScreen extends StatefulWidget {
  final File videoFile;

  const UploadVideoScreen({Key? key , required this.videoFile}) : super(key: key);

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreen();
}

class _UploadVideoScreen extends State<UploadVideoScreen> {
  late VideoPlayerController videoPlayerController;
  bool _isVideoPlaying = true;

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UploadVideoCubit>(context).resetCubit();

    setState(() {
      videoPlayerController = VideoPlayerController.file(widget.videoFile);
    });
    videoPlayerController.initialize();
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
    // videoPlayerController.setVolume(0.7);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Video Page"),),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          child:  ( BlocProvider.of<UploadVideoCubit>(context).state is UploadVideoLoading ) ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Uploading"),
              SizedBox(width: 20,),
              SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,) ,)
            ],
          ): ( BlocProvider.of<UploadVideoCubit>(context).state is UploadVideoLoaded ) ?  Text("Uploaded") : Text("Upload"),
          onPressed: (){
            BlocProvider.of<UploadVideoCubit>(context).uploadVideos(widget.videoFile.path);
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            )
          ),
        ) ,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [

          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                    child: Stack(
                        children: [
                          VideoPlayer(videoPlayerController),
                          Center(
                            child: FloatingActionButton(
                              child: Icon(_isVideoPlaying ? Icons.pause : Icons.play_arrow ),
                              onPressed: (){
                                if(videoPlayerController.value.isPlaying){
                                  videoPlayerController.pause();
                                  setState(() {
                                    _isVideoPlaying = false;
                                  });
                                }else{
                                  videoPlayerController.play();
                                  setState(() {
                                    _isVideoPlaying = true;
                                  });
                                }
                              },
                            ),
                          )
                        ]
                    )
                ),
              ],
            ),
          ),
          BlocConsumer<UploadVideoCubit, UploadVideoState>(
            listener: (context, state){
              if(state is UploadVideoError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${state.errorMessage}")));
              }

            },
              builder: (context, state){
                if(state is UploadVideoLoading) {
                  return SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: ModalBarrier(
                      color: Colors.grey.withOpacity(0.3),
                      dismissible: false,
                    ),
                  );
                }

                else if(state is UploadVideoLoaded && state.isUploaded == true){
                  return Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Video Uploaded Successfully!"),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (_){
                                return MyHomePage();
                              }), (_) => false);
                            },
                            child: Text("Okay")
                        )
                      ],
                    ),
                  );
                }

                return SizedBox();
              }
          ),
        ],
      )

    );
  }
}
