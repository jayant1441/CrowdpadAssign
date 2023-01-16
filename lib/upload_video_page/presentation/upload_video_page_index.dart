import 'dart:io';
import 'package:crowdpad_assignment/home_page/presentation/home_page_index.dart';
import 'package:crowdpad_assignment/style_constants.dart';
import 'package:crowdpad_assignment/upload_video_page/business_logic/upload_video_cubit.dart';
import 'package:crowdpad_assignment/utils/colors_constant.dart';
import 'package:crowdpad_assignment/widgets/gredient_widget.dart';
import 'package:crowdpad_assignment/widgets/outlined_button.dart';
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: GradientWidget(
            gradient: AppGradients.neonPinkBlueGradient(),
            child: const Icon(Icons.arrow_back_ios_new),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: GradientWidget(
          gradient: AppGradients.neonPinkBlueGradient(),
          child: const Text("Upload Video"),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        child: MyOutlinedButton(
          gradient: AppGradients.neonPinkBlueGradient(),
          thickness: 4,
          child: ( BlocProvider.of<UploadVideoCubit>(context).state is UploadVideoLoading ) ?
          GradientWidget(
              gradient: AppGradients.neonPinkBlueGradient(),
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Uploading"),
              SizedBox(width: 20,),
              SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.neonPinkColor, strokeWidth: 2,) ,)
            ],
          )): ( BlocProvider.of<UploadVideoCubit>(context).state is UploadVideoLoaded ) ?  GradientWidget(gradient: AppGradients.neonPinkBlueGradient(),child: Text("Uploaded")) :
          GradientWidget(
            gradient: AppGradients.neonPinkBlueGradient(),
            child: Text("Upload", style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1)),
          ),
          onPressed: (){
            if(BlocProvider.of<UploadVideoCubit>(context).state is UploadVideoInitial) {
              BlocProvider.of<UploadVideoCubit>(context).uploadVideos(
                  widget.videoFile.path);
              setState(() {});
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
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
                            child: GestureDetector(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle
                                ),
                                child: Icon(_isVideoPlaying ? Icons.pause : Icons.play_arrow, size: 30, color: AppColors.neonPinkColor,),
                              ),
                              onTap: (){
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
                    SnackBar(content: Text(state.errorMessage)));
              }
              if(state is UploadVideoLoaded){
                setState(() {});
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
                    backgroundColor: Colors.black,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Video Uploaded Successfully!", style: w600TextStyle(color: Colors.white),),
                        const SizedBox(height: 16,),
                        MyOutlinedButton(
                            gradient: AppGradients.neonPinkBlueGradient(),

                            onPressed: (){
                              Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (_){
                                return const MyHomePage();
                              }), (_) => false);
                            },
                            child: const Text("Okay")
                        )
                      ],
                    ),
                  ));
                }

                return const SizedBox();
              }
          ),
        ],
      )

    );
  }
}


