import 'dart:io';
import 'dart:ui';
import 'package:crowdpad_assignment/home_page/business_logic/home_page_cubit.dart';
import 'package:crowdpad_assignment/style_constants.dart';
import 'package:crowdpad_assignment/upload_video_page/presentation/upload_video_page_index.dart';
import 'package:crowdpad_assignment/home_page/presentation/video_page_index.dart';
import 'package:crowdpad_assignment/utils/colors_constant.dart';
import 'package:crowdpad_assignment/video_picker_utils.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rive/rive.dart' as rive;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _offsetToTrigger = 180.0;


  @override
  void initState() {
    super.initState();
    /// Getting all videos from firebase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<HomePageCubit>(context).getAllVideos();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CROWDPAD"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[
                  AppColors.neonPinkColor,
                  AppColors.neonBlueColor,
                ]),
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16),)
                ),
                context: context, builder: (_){
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    ListTile(
                        dense: true,
                        leading: const SizedBox(),
                      title: Center(child : Text("Choose From", style: w600TextStyle())),
                      trailing: TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                          child: const Text("Cancel", style: TextStyle(color: Colors.grey, letterSpacing: 1),))
                    ),

                    ListTile(
                      leading: Icon(CupertinoIcons.photo, color: AppColors.neonYellowColor,),
                      title: Text("Gallery", style: w600TextStyle()),
                      dense: true,
                      onTap: (){
                        pickVideo(ImageSource.gallery);
                      }
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Divider(),
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.camera, color: AppColors.greenColor,),
                      title: Text("Camera", style: w600TextStyle()),
                      dense: true,
                      onTap: (){
                        pickVideo(ImageSource.camera);
                      },
                    )
                  ],
                ),
              );
            });
          },
              icon: const Icon(CupertinoIcons.video_camera, size: 30,))
        ],
      ),

      body: CustomRefreshIndicator(
        onRefresh: () => BlocProvider.of<HomePageCubit>(context).getAllVideos(),
        offsetToArmed: _offsetToTrigger,
        builder: (context, child,  controller){
          // todo learn more about AnimatedBuilder
          return AnimatedBuilder(
              animation: controller,
              child: child,
              builder: (context,child){
                return Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: _offsetToTrigger * controller.value,
                      child: rive.RiveAnimation.asset('assets/rocket.riv', fit: BoxFit.cover,)
                    ),
                    Transform.translate(
                        offset: Offset(0.0, _offsetToTrigger * controller.value),
                      child: controller.isLoading ? LoadingWidget() : child,
                    )

                ],
                );
              }
          );
        },
        child: BlocConsumer<HomePageCubit, HomePageState> (
          listener: (context, state){
            if(state is HomePageError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An Error Occurred")));
            }
          },
          builder: (context, state){
            if(state is HomePageLoading){
              return const LoadingWidget();
            }
            else if(state is HomePageLoaded){
              return Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[
                        AppColors.neonPinkColor,
                        AppColors.neonBlueColor,
                      ]),
                ),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.listOfVideos?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0
                  ),
                  itemBuilder: (BuildContext context, int index){
                    final _video = state.listOfVideos![index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (_){
                          return VideoPageIndex(listOfVideos: state.listOfVideos!, index: index, );
                        }));
                      },
                      child: PhysicalModel(color: Colors.black,
                        elevation: 10,
                        borderRadius: BorderRadius.circular(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child:Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.network("${_video.thumbnail}", fit: BoxFit.cover,),

                          ) ,
                        ),),
                    );
                  },
                )

              );
            }
            else if(state is HomePageError){
              return Center(
                child: Text("${state.errorMessage}"),
              );
            }

              return SizedBox();

          },
        ),

      )
    );
  }

  void pickVideo(ImageSource imageSource) async{
    try {
      File? _video = await VideoPickerUtils.pickVideoFromSource(imageSource);
      if (_video != null) {
        Navigator.push(context, CupertinoPageRoute(builder: (_){
          return UploadVideoScreen(videoFile: _video);
        }));
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 40,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0
      ),
      itemBuilder: (BuildContext context, int index){
        return Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16)
          ),

        );
      },
    );
  }
}

