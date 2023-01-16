import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdpad_assignment/home_page/business_logic/home_page_cubit.dart';
import 'package:crowdpad_assignment/home_page/presentation/widgets/home_page_loading_widget.dart';
import 'package:crowdpad_assignment/home_page/presentation/widgets/pick_video_bottom_sheet.dart';
import 'package:crowdpad_assignment/style_constants.dart';
import 'package:crowdpad_assignment/home_page/presentation/video_page_index.dart';
import 'package:crowdpad_assignment/utils/colors_constant.dart';
import 'package:crowdpad_assignment/widgets/gredient_widget.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: GradientWidget(
        child: const Text("CROWDPAD"),
        gradient: AppGradients.neonPinkBlueGradient()
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: (){
            showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16),)
                ),
                context: context, builder: (_){

              return const PickVideoSourceBottomSheet();
            });
          },
              icon: GradientWidget(
                gradient : AppGradients.neonPinkBlueGradient(),
                  child: const Icon(CupertinoIcons.video_camera, size: 30,)
              )
          )
        ],
      ),

      body: Stack(children: [
        Container(
            padding: const EdgeInsets.all(12.0),
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover
                )
            )
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.shade200.withOpacity(0.1)),
          ),
        ),
        CustomRefreshIndicator(
          onRefresh: () => BlocProvider.of<HomePageCubit>(context).getAllVideos(fetchNewVideos: true),
          offsetToArmed: _offsetToTrigger,
          builder: (context, child,  controller){
            return AnimatedBuilder(
                animation: controller,
                child: child,
                builder: (context,child){
                  return Stack(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          height: _offsetToTrigger * controller.value,
                          child: const rive.RiveAnimation.asset('assets/rocket.riv', fit: BoxFit.cover,)
                      ),
                      Transform.translate(
                        offset: Offset(0.0, _offsetToTrigger * controller.value),
                        child: controller.isLoading ? const HomePageLoadingWidget() : child,
                      )

                    ],
                  );
                }
            );
          },
          child: BlocConsumer<HomePageCubit, HomePageState> (
            listener: (context, state){
              if(state is HomePageError){
                ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("An Error Occurred")));
              }
            },
            builder: (context, state){
              if(state is HomePageLoading){
                return Stack(
                  children: [
                    const HomePageLoadingWidget(),
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: ModalBarrier(
                        color: Colors.black.withOpacity(0.5),
                        dismissible: false,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.neonPinkColor,
                      ),
                    )
                  ],
                );
              }
              else if(state is HomePageLoaded){
                return Container(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: state.listOfVideos?.length ?? 0,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0
                      ),
                      itemBuilder: (BuildContext context, int index){
                        final video = state.listOfVideos![index];
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
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            "${video.thumbnail}"
                                        ),
                                        fit: BoxFit.fill,
                                      )
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors:[
                                                  Colors.transparent,
                                                  Colors.black
                                                ]
                                            )
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                        alignment: Alignment.bottomLeft,
                                        child:  Text("@${video.username}", style: w600TextStyle(color: Colors.white),),
                                      )
                                    ],
                                  )

                              ) ,
                            ),),
                        );
                      },
                    )

                );
              }
              else if(state is HomePageError){
                return Center(
                  child: Text(state.errorMessage),
                );
              }

              return const HomePageLoadingWidget();

            },
          ),
        )

      ],)
    );
  }


}


